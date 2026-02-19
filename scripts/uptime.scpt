-- Uptime Report v4 — AppleScript
-- Fixes: compile error (no 'does not match'), robust numeric check, matches Terminal `uptime`.
-- Features: Uptime (weeks + d/h/m/s), CPU, Memory, Load, Clipboard, Log save + Reveal, Raw `uptime`.

on run
  -- ======= Configuration =======
  set copyReportToClipboard to true   -- copy the final report to clipboard
  set saveLogToFile to true           -- save a log file
  -- Preferred log directory (falls back to /var/tmp if not writable)
  set preferredLogDir to POSIX path of ((path to desktop folder) as text)
  -- =============================

  try
    ----------------------------------------------------------------------
    -- 1) Get boot epoch from 'sysctl -n kern.boottime' robustly
    -- Example: { sec = 1770315194, usec = 18409 } Thu Feb  5 10:13:14 2026
    -- We take the 4th field (seconds) to avoid matching 'usec'.
    ----------------------------------------------------------------------
    set bootEpochStr to do shell script "/usr/sbin/sysctl -n kern.boottime 2>/dev/null | /usr/bin/awk -F'[ ,]+' '{print $4}'"
    if bootEpochStr is "" then error "Unable to parse kern.boottime (empty)."
    if my matchesRegex(bootEpochStr, "^[0-9]+$") is false then error "kern.boottime not numeric: " & bootEpochStr
    set bootEpoch to (bootEpochStr as integer)
    if bootEpoch < 978307200 then error "Suspicious boot epoch: " & bootEpochStr -- earlier than 2001-01-01

    ----------------------------------------------------------------------
    -- 2) Compute uptime seconds
    ----------------------------------------------------------------------
    set nowEpoch to (do shell script "/bin/date +%s") as integer
    set uptimeSeconds to nowEpoch - bootEpoch
    if uptimeSeconds < 0 then error "Clock anomaly: uptime negative."

    ----------------------------------------------------------------------
    -- 3) Break uptime into weeks/days/hours/minutes/seconds
    ----------------------------------------------------------------------
    set days to (uptimeSeconds div 86400)
    set rem1 to (uptimeSeconds mod 86400)
    set hours to (rem1 div 3600)
    set rem2 to (rem1 mod 3600)
    set mins to (rem2 div 60)
    set secs to (rem2 mod 60)
    set weeks to (days div 7)
    set rdays to (days mod 7)

    ----------------------------------------------------------------------
    -- 4) Human-readable times (Perl/POSIX strftime; avoids `date -r` pitfalls)
    ----------------------------------------------------------------------
    set nowStr to do shell script "/bin/date \"+%a %b %d, %Y %H:%M:%S %Z\""
    set lastBootStr to do shell script ("/usr/bin/perl -MPOSIX=strftime -e 'print strftime(\"%a %b %d, %Y %H:%M:%S %Z\", localtime(" & bootEpoch & "))'")

    ----------------------------------------------------------------------
    -- 5) Load averages (1m 5m 15m)
    ----------------------------------------------------------------------
    set loadRaw to do shell script "/usr/sbin/sysctl -n vm.loadavg | /usr/bin/sed -E 's/[{}]//g' | /usr/bin/xargs"
    set {la1, la5, la15} to my first3(loadRaw)

    ----------------------------------------------------------------------
    -- 6) CPU usage (user/sys/idle) and Memory usage (PhysMem + Swap)
    ----------------------------------------------------------------------
    set cpuLine to do shell script "/usr/bin/top -l 1 -n 0 | /usr/bin/awk -F': ' '/CPU usage/ {print $2; exit}' 2>/dev/null || echo \"n/a\""
    set physMemLine to do shell script "/usr/bin/top -l 1 -n 0 | /usr/bin/awk -F': ' '/PhysMem/ {print $2; exit}' 2>/dev/null || echo \"n/a\""
    set swapLine to do shell script "/usr/sbin/sysctl vm.swapusage 2>/dev/null | /usr/bin/sed -E 's/^vm\\.swapusage: //g' || echo \"n/a\""

    ----------------------------------------------------------------------
    -- 7) Logged-in user count & raw `uptime` line for cross-check
    ----------------------------------------------------------------------
    set userCount to do shell script "/usr/bin/who | /usr/bin/wc -l | /usr/bin/tr -d ' '"
    set rawUptime to do shell script "/usr/bin/uptime"

    ----------------------------------------------------------------------
    -- 8) Compose report
    ----------------------------------------------------------------------
    set compact to (days as string) & "d " & my pad2(hours) & "h:" & my pad2(mins) & "m:" & my pad2(secs) & "s"
    set verbose to my joinVerbose(days, hours, mins, secs)

    set report to "🖥️ macOS Uptime Report" & return & ¬
      "────────────────────────────────────────" & return & ¬
      "Current Time     : " & nowStr & return & ¬
      "Last Boot Time   : " & lastBootStr & return & ¬
      "Uptime (weeks)   : " & weeks & "w " & rdays & "d" & return & ¬
      "Uptime (compact) : " & compact & return & ¬
      "Uptime (verbose) : " & verbose & return & ¬
      "Logged-in Users  : " & userCount & return & ¬
      "Load Averages    : 1m=" & la1 & "  5m=" & la5 & "  15m=" & la15 & return & ¬
      "CPU Usage        : " & cpuLine & return & ¬
      "Memory (PhysMem) : " & physMemLine & return & ¬
      "Memory (Swap)    : " & swapLine & return & ¬
      "Raw 'uptime'     : " & rawUptime

    ----------------------------------------------------------------------
    -- 9) Clipboard + optional log save
    ----------------------------------------------------------------------
    if copyReportToClipboard then set the clipboard to report

    set extraNote to ""
    set savedPath to ""
    if saveLogToFile then
      set ts to do shell script "/bin/date +%Y%m%d-%H%M%S"
      set hostName to do shell script "/usr/sbin/scutil --get LocalHostName 2>/dev/null || /bin/hostname -s"
      set logDir to preferredLogDir
      try
        set writableCheck to do shell script "[ -d " & quoted form of logDir & " ] && [ -w " & quoted form of logDir & " ] && echo yes || echo no"
        if writableCheck is not "yes" then set logDir to "/var/tmp"
      on error
        set logDir to "/var/tmp"
      end try
      set savedPath to logDir & "/uptime_report_" & hostName & "_" & ts & ".log"
      do shell script "/usr/bin/printf '%s\\n' " & quoted form of report & " > " & quoted form of savedPath
      set extraNote to return & "Log saved to: " & savedPath
    end if

    ----------------------------------------------------------------------
    -- 10) Show dialog; offer Reveal Log if we saved a file
    ----------------------------------------------------------------------
    if saveLogToFile then
      set dlg to display dialog (report & extraNote) buttons {"OK", "Reveal Log"} default button "OK" with title "Uptime Report v4"
      if button returned of dlg is "Reveal Log" then do shell script "/usr/bin/open -R " & quoted form of savedPath
    else
      display dialog report buttons {"OK"} default button "OK" with title "Uptime Report v4"
    end if

  on error errMsg number errNum
    display dialog "Uptime check failed." & return & errMsg & " (err " & errNum & ")" buttons {"OK"} default button "OK" with title "Uptime Report v4"
  end try
end run

-- ======= Helpers =======

on pad2(n)
  if n < 10 then return "0" & (n as string)
  return n as string
end pad2

on plural(n)
  if n = 1 then return ""
  return "s"
end plural

on joinVerbose(d, h, m, s)
  set parts to {}
  if d > 0 then set end of parts to (d as string) & " day" & plural(d)
  if h > 0 then set end of parts to (h as string) & " hour" & plural(h)
  if m > 0 then set end of parts to (m as string) & " minute" & plural(m)
  if s > 0 or (count parts) = 0 then set end of parts to (s as string) & " second" & plural(s)
  set AppleScript's text item delimiters to ", "
  set txt to parts as string
  set AppleScript's text item delimiters to ""
  return txt
end joinVerbose

on first3(s)
  -- Return first three whitespace‑separated tokens; fallback to "n/a"
  set toks to my splitBy(s, " ")
  set a to "n/a"
  set b to "n/a"
  set c to "n/a"
  try
    if (count toks) ≥ 1 then set a to item 1 of toks
    if (count toks) ≥ 2 then set b to item 2 of toks
    if (count toks) ≥ 3 then set c to item 3 of toks
  end try
  return {a, b, c}
end first3

on splitBy(t, delim)
  set {oldTID, AppleScript's text item delimiters} to {AppleScript's text item delimiters, delim}
  set arr to text items of t
  set AppleScript's text item delimiters to oldTID
  return arr
end splitBy

-- POSIX ERE check via grep -E, returns true if s matches pattern
on matchesRegex(s, pattern)
  try
    do shell script "/usr/bin/printf %s " & quoted form of s & " | /usr/bin/grep -Eq " & quoted form of pattern
    return true
  on error
    return false
  end try
end matchesRegex
