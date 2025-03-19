-- Check interval in seconds
set interval to 2
set pingTarget to "google.com"

-- Initialize packet loss counters
set totalPings to 0
set failedPings to 0

-- Ensure log directory exists
set userProfile to (path to home folder as text)
set logDirectory to userProfile & "Temp:"
do shell script "mkdir -p " & quoted form of POSIX path of logDirectory

-- Generate log filename
set logFile to logDirectory & "WiFiLog_" & (do shell script "date +%Y%m%d_%H%M%S") & ".txt"

-- Function to write log
on writeLog(message, logFile)
    set timestamp to do shell script "date +%Y-%m-%d\\ %H:%M:%S"
    set logMessage to timestamp & " - " & message & linefeed
    do shell script "echo " & quoted form of logMessage & " >> " & quoted form of POSIX path of logFile
end writeLog

-- Function to get Wi-Fi info
on getWifiInfo()
    set ssid to do shell script "networksetup -getairportnetwork en0 | awk -F': ' '{print $2}'"
    set signal to do shell script "system_profiler SPAirPortDataType | awk '/agrCtlRSSI/ {print $2}'"
    set linkSpeed to do shell script "system_profiler SPAirPortDataType | awk '/lastTxRate/ {print $2}'"
    
    return {SSID:ssid, Signal:signal, LinkSpeed:linkSpeed}
end getWifiInfo

-- Function to test packet loss
on testPacketLoss(target)
    try
        set pingOutput to do shell script "ping -c 1 " & target
        set success to (pingOutput contains "bytes from")
        
        if success then
            set bytes to do shell script "echo " & quoted form of pingOutput & " | awk -F'bytes from' '{print $1}' | awk '{print $1}'"
            set time to do shell script "echo " & quoted form of pingOutput & " | awk -F'time=' '{print $2}' | awk '{print $1}'"
            set ttl to do shell script "echo " & quoted form of pingOutput & " | awk -F'TTL=' '{print $2}' | awk '{print $1}'"
            
            return {Success:true, Bytes:bytes, Time:time, TTL:ttl}
        else
            return {Success:false}
        end if
    on error
        return {Success:false}
    end try
end testPacketLoss

-- Main loop
set previousBSSID to ""
set currentSSID to ""

writeLog("Starting Wi-Fi monitoring script...", logFile)
repeat
    set currentWifi to getWifiInfo()
    
    if currentWifi's SSID is "Hidden SSID" then
        set wifiMessage to "Connected to a hidden Wi-Fi network"
        writeLog("Connected to a hidden Wi-Fi network", logFile)
    else
        if currentWifi's SSID is not currentSSID then
            set wifiMessage to "Connected to Wi-Fi: " & currentWifi's SSID
            writeLog("Connected to Wi-Fi: " & currentWifi's SSID, logFile)
            set currentSSID to currentWifi's SSID
        else
            set wifiMessage to "Current Wi-Fi: " & currentWifi's SSID
        end if
    end if
    
    -- Perform ping test
    set pingResult to testPacketLoss(pingTarget)
    set totalPings to totalPings + 1
    if pingResult's Success is false then
        set failedPings to failedPings + 1
    end if
    
    -- Calculate packet loss percentage
    if totalPings > 0 then
        set packetLoss to round ((failedPings / totalPings) * 100) rounding to nearest
    else
        set packetLoss to 0
    end if
    
    -- Log and display statistics
    if pingResult's Success then
        set pingMessage to "Ping to " & pingTarget & " : Bytes=" & pingResult's Bytes & ", Time=" & pingResult's Time & "ms, TTL=" & pingResult's TTL
    else
        set pingMessage to "Ping to " & pingTarget & " failed"
    end if
    
    set logMessage to "Signal Strength: " & currentWifi's Signal & " | Link Speed: " & currentWifi's LinkSpeed & " | Packet Loss: " & packetLoss & "% (Total: " & totalPings & ", Failed: " & failedPings & ") | " & pingMessage
    writeLog(logMessage, logFile)
    
    -- Display the result in a window
    display dialog logMessage buttons {"OK"} default button "OK" giving up after interval
    
    delay interval
end repeat
