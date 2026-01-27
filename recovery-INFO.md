**macOS Recovery** you generally **can’t** use  
`softwareupdate --fetch-full-installer` to pull Sequoia and put it on **/Volumes/Source**. That command is designed to run on a **booted macOS system**, and it puts the installer app into **/Applications** of the running OS—not onto an external volume. (Apple and multiple admin guides note the full‑installer workflow downloads to **/Applications**, and the flag is supported on Catalina or later while booted normally.) [\[osxdaily.com\]](https://osxdaily.com/2020/04/13/how-download-full-macos-installer-terminal/), [\[discussion....apple.com\]](https://discussions.apple.com/docs/DOC-250007895)

When Safari in Recovery keeps crashing, the **most reliable Recovery‑only path** is:

*   Use **Terminal** to **download the Apple‑hosted `InstallAssistant.pkg`** with `curl` **directly to your first USB** (`/Volumes/Source`),
*   **Expand** it on that same USB to get **Install macOS Sequoia.app**, then
*   Run **`createinstallmedia`** to build the second USB.  
    This matches Apple’s own bootable‑installer guidance: first get the **full installer**, then run `createinstallmedia`. [\[support.apple.com\]](https://support.apple.com/en-us/101578)

Below I’ll give you **copy‑paste commands** that work in Recovery Terminal.

***

## Option A — Terminal‑only method in Recovery (no Safari)

> You will need a **direct Apple CDN URL** for `InstallAssistant.pkg`. If you don’t already have one, you can copy a Sequoia link from a trusted list (e.g., Mr. Macintosh) on another device and bring the URL, or use a known good Sequoia link. Apple CDN links look like:  
> `https://swcdn.apple.com/content/downloads/.../InstallAssistant.pkg` (these are **Apple‑hosted**). [\[mrmacintosh.com\]](https://mrmacintosh.com/macos-sequoia-full-installer-database-download-directly-from-apple/), [\[apple.stac...change.com\]](https://apple.stackexchange.com/questions/478657/error-fetching-full-installer-with-the-softwareupdate-command)

### 0) Prepare the two USBs (Source and Installer)

```bash
# Identify disks
diskutil list

# Example: /dev/disk5 = Source, /dev/disk6 = Installer (replace as needed)
diskutil eraseDisk APFS "Source" GPT /dev/disk5
diskutil eraseDisk APFS "Installer" GPT /dev/disk6
```

### 1) Download the full installer **pkg** straight to **Source**

> Replace the example URL with the **actual** Sequoia `InstallAssistant.pkg` URL you copied (from Apple’s CDN).

```bash
curl -L --retry 5 --continue-at - \
  -o "/Volumes/Source/InstallAssistant.pkg" \
  "https://swcdn.apple.com/content/downloads/47/16/089-70987-A_PWKNKEFQ1D/sjlq45liw0g5lor3a6i89vz7paml1xpq6w/InstallAssistant.pkg"
```

*   `-L` follows redirects, `--retry` makes it more resilient, `--continue-at -` resumes if the connection drops.
*   If you want to **verify the pkg is Apple‑signed** before using it:

```bash
pkgutil --check-signature "/Volumes/Source/InstallAssistant.pkg"
```

(A Stack Exchange thread shows admins using direct `swcdn.apple.com` pkg links specifically when `softwareupdate` fails.) [\[apple.stac...change.com\]](https://apple.stackexchange.com/questions/478657/error-fetching-full-installer-with-the-softwareupdate-command)

### 2) Expand the pkg **onto the Source USB** (this yields the .app)

```bash
installer -pkg "/Volumes/Source/InstallAssistant.pkg" -target "/Volumes/Source"
```

After a few minutes you should have:

    /Volumes/Source/Applications/Install macOS Sequoia.app

(Apple’s doc states the result of downloading the full installer should be an app named **Install macOS \[Version]**. Installing the `InstallAssistant.pkg` produces that app.) [\[support.apple.com\]](https://support.apple.com/en-us/101578)

### 3) Build the bootable USB on **Installer** with `createinstallmedia`

```bash
"/Volumes/Source/Applications/Install macOS Sequoia.app/Contents/Resources/createinstallmedia" \
  --volume "/Volumes/Installer"
```

This is Apple’s official method for making a bootable installer. It will **erase** the target volume and make it bootable. [\[support.apple.com\]](https://support.apple.com/en-us/101578)

### 4) Boot from the USB installer (Apple Silicon)

1.  Shut down.
2.  Insert the **Installer** USB.
3.  **Press and hold the Power button** until **Startup Options** appears → select the USB installer. (This is the documented flow for Apple Silicon.) [\[macobserver.com\]](https://www.macobserver.com/tips/how-to/15-mac-startup-key-combinations-guide/)

***

## Option B — If you *can* use `softwareupdate` (not in Recovery)

For completeness: when you’re booted into a **normal macOS** (not Recovery), you can do:

```bash
# See what full installers Apple offers your Mac
softwareupdate --list-full-installers

# Fetch a specific full installer (e.g., Sequoia 15.7.2)
softwareupdate --fetch-full-installer --full-installer-version 15.7.2
```

This places the installer app in **/Applications**. From there:

```bash
sudo /Applications/Install\ macOS\ Sequoia.app/Contents/Resources/createinstallmedia \
  --volume /Volumes/Installer
```

Guides consistently note `softwareupdate --fetch-full-installer` **downloads to /Applications**, and it’s available on **Catalina or later**—again, while **booted** into macOS, not Recovery. Also, Apple has periodically had outages/quirks where this flag fails; in those cases, admins fall back to **direct Apple CDN pkg links** like in Option A. [\[osxdaily.com\]](https://osxdaily.com/2020/04/13/how-download-full-macos-installer-terminal/), [\[discussion....apple.com\]](https://discussions.apple.com/docs/DOC-250007895), [\[discussion....apple.com\]](https://discussions.apple.com/thread/256042015)

***

## Why `softwareupdate` in Recovery isn’t the right tool

*   The documented behavior of `softwareupdate --fetch-full-installer` is to **place the app in /Applications** of the running macOS—**Recovery doesn’t have a userland /Applications the same way** you do when booted normally. That’s why Apple’s **bootable installer** doc says: first **download the full installer** (App Store / **web browser** / Terminal), **then** run `createinstallmedia`. In Recovery, the practical Terminal method is **downloading the `InstallAssistant.pkg`** and expanding it to an external volume (Option A). [\[support.apple.com\]](https://support.apple.com/en-us/101578), [\[osxdaily.com\]](https://osxdaily.com/2020/04/13/how-download-full-macos-installer-terminal/)

***

## Need a working Sequoia URL?

Here's **exact version** you want (e.g., **15.7.2**), I’ll reply with a **direct Apple CDN link** you can paste into the `curl` command above. These links are listed by reputable admin sites and point **directly to Apple’s servers**—handy when `softwareupdate` is unreliable or you’re stuck in Recovery. [\[mrmacintosh.com\]](https://mrmacintosh.com/macos-sequoia-full-installer-database-download-directly-from-apple/)

***

### Quick recap

*   `softwareupdate --fetch-full-installer ...` → **works when macOS is booted**, saves to **/Applications**. **Not** the right tool inside Recovery. [\[osxdaily.com\]](https://osxdaily.com/2020/04/13/how-download-full-macos-installer-terminal/)
*   In Recovery, use **Terminal + `curl`** to download **Apple‑hosted `InstallAssistant.pkg`** to **/Volumes/Source**, **install** it there to get the **.app**, then **`createinstallmedia`** to build your second USB. [\[support.apple.com\]](https://support.apple.com/en-us/101578), [\[apple.stac...change.com\]](https://apple.stackexchange.com/questions/478657/error-fetching-full-installer-with-the-softwareupdate-command)






## What’s happening (why your internal SSD won’t erase or accept install)

1.  **You’re booted from the internal disk you’re trying to erase.**  
    In your `diskutil list physical` you have on **/dev/disk0**:

*   `Apple_APFS_ISC` (disk0s1) — iBoot System Container
*   *(free space \~245 GB)* — your main APFS container was deleted
*   `Apple_APFS_Recovery` (disk0s3) — “1 True Recovery” / fallback recovery

On Apple‑silicon Macs, **RecoveryOS and the iBoot System Container (ISC) live on the same physical SSD**. If you start Recovery from there, the **kernel is running from disk0**, so trying to erase **disk0** returns:

> “The volume on disk0 couldn’t be unmounted because it is in use by process 0 (kernel) … -69877” — exactly what your Terminal shows. [\[discussion....apple.com\]](https://discussions.apple.com/thread/253777530), [\[macmegasite.com\]](https://macmegasite.com/2024/10/22/boot-volume-layout-and-structure-in-macos-sequoia/)

2.  **Your main APFS container is missing**, so the installer can’t build the required APFS volume group (System/Data/Preboot/Recovery). That’s why the GUI shows **“Unable to set target system volume for preflight.”** This class of preflight errors appears when the target container/volumes aren’t in a valid state for Sequoia to stage the SSV (Signed System Volume). [\[macmegasite.com\]](https://macmegasite.com/2024/10/22/boot-volume-layout-and-structure-in-macos-sequoia/), [\[discussion....apple.com\]](https://discussions.apple.com/thread/254869144)

3.  **USB installers and “normal” Recovery don’t help** because they still end up using internal recovery components or can’t modify the disk while it’s busy. On Apple silicon, the reliable fix when the container layout is damaged is **External Recovery (Fallback Recovery)** or **DFU Restore** to rebuild firmware + recovery + the internal disk structure. [\[support.apple.com\]](https://support.apple.com/guide/mac-help/macos-recovery-a-mac-apple-silicon-mchl82829c17/mac), [\[talk.tidbits.com\]](https://talk.tidbits.com/t/recovery-on-apple-silicon-macs/21465)

***

## Two proven ways to fix it

### Option A — Recreate the missing APFS container from Recovery *without* erasing ISC/1TR

If you are in **External Recovery/Fallback Recovery** (see how to get there below), you can add back a fresh APFS container into the free space **between** the ISC (s1) and the Recovery (s3), then install macOS to it.

**Why this works:** Apple silicon treats the **ISC (s1)** and **Apple\_APFS\_Recovery (s3)** as protected, system‑critical partitions; you don’t erase them. You only need to restore the **main APFS container** in the free space. Apple techs commonly use a `diskutil addPartition` flow for this exact scenario. [\[discussion....apple.com\]](https://discussions.apple.com/thread/253777530)

**Steps (from Recovery > Utilities > Terminal):**

```bash
# 1) Confirm internal disk number
diskutil list

# You should see disk0s1 = Apple_APFS_ISC, large free space, disk0s3 = Apple_APFS_Recovery

# 2) Create a new APFS container filling the free space AFTER disk0s1
#    This adds a container and creates an APFS volume named "Macintosh HD".
#    Adjust disk identifier if your ISC isn't disk0s1 (rare).
diskutil addPartition disk0s1 APFS "Macintosh HD" 0

# 3) Quit Terminal, then run "Reinstall macOS" and select the new "Macintosh HD".
```

If the command errors, run **Disk Utility > View > Show All Devices**, select the **new container**, run **First Aid**, quit, then retry the installer. [\[discussion....apple.com\]](https://discussions.apple.com/thread/253777530)

> If you **aren’t** in Fallback/External Recovery, `disk0` may still be “busy”. See the next box to ensure you are.

***

### How to enter **Fallback Recovery (1TR)** so `disk0` isn’t “in use”

Fallback Recovery is a second, independent copy of RecoveryOS used **when normal Recovery is damaged or can’t service the internal disk**.

**Enter Fallback Recovery on Apple silicon:**

1.  Shut down the Mac completely.
2.  **Press the power button twice quickly, then hold it on the second press** until you see *Loading startup options…*
3.  Choose **Options** → Continue (you’re now in Fallback Recovery). [\[iboysoft.com\]](https://iboysoft.com/wiki/fallback-recovery-os-mode.html), [\[forums.macrumors.com\]](https://forums.macrumors.com/threads/omg-hidden-m1-boot-mode.2288213/), [\[eclecticlight.co\]](https://eclecticlight.co/2023/03/02/recovery-on-apple-silicon-macs-has-changed-again/)

Once there, repeat **Option A** above or try a standard **Reinstall macOS** to the newly created **Macintosh HD**.

***

### Option B — **DFU Restore** (the “100% reset” that rebuilds firmware + recovery + disk)

If Option A still fails, do a **DFU Restore** from another Mac using **Apple Configurator 2**. This:

*   Reinstalls firmware
*   Recreates RecoveryOS and the correct internal partitioning
*   Lays down a fresh macOS

This is Apple’s official remedy when the internal containering/recovery is corrupted. [\[talk.tidbits.com\]](https://talk.tidbits.com/t/recovery-on-apple-silicon-macs/21465)

**What you need**

*   Another Mac (Intel or Apple silicon) with **Apple Configurator 2**
*   USB‑C ↔ USB‑C (or USB‑A↔C) data cable
*   Stable internet on the working Mac

**High‑level steps**

1.  Install/open **Apple Configurator 2** on the working Mac.
2.  Connect the cable to your MacBook Air (the one to fix).
3.  Put the Air into **DFU mode** (button sequence differs from Recovery; follow Configurator’s prompts).
4.  In Configurator: **Restore** (you can try **Revive** first, but Restore is the clean sweep). [\[support.apple.com\]](https://support.apple.com/guide/mac-help/macos-recovery-a-mac-apple-silicon-mchl82829c17/mac), [\[talk.tidbits.com\]](https://talk.tidbits.com/t/recovery-on-apple-silicon-macs/21465)

***

## Why the GUI installer says “Unable to set target system volume for preflight”

Sequoia needs to create an **APFS volume group** (System + Data + Preboot + Recovery + VM) inside a valid **APFS container**. Because your main container was deleted (only ISC and 1TR containers remain), the installer can’t “preflight” (stage the SSV, cryptexes, etc.), so it blocks selection of the internal disk. Re‑creating the container (Option A) or doing a DFU Restore (Option B) resolves this. [\[macmegasite.com\]](https://macmegasite.com/2024/10/22/boot-volume-layout-and-structure-in-macos-sequoia/)

***

## What **not** to do

*   Don’t try to `eraseDisk` **/dev/disk0** while you’re booted from internal RecoveryOS—**it will always be “in use by kernel”**. Use Fallback Recovery or DFU. [\[discussion....apple.com\]](https://discussions.apple.com/thread/253777530)
*   Don’t delete `Apple_APFS_ISC` or `Apple_APFS_Recovery`—they’re required for Apple‑silicon secure boot and recovery. If they’re damaged/missing, **DFU Restore** is the fix. [\[macmegasite.com\]](https://macmegasite.com/2024/10/22/boot-volume-layout-and-structure-in-macos-sequoia/)

***

## Based on your screenshots, here’s the fastest path for you

1.  Boot into **Fallback Recovery** (double‑press, then hold Power). [\[iboysoft.com\]](https://iboysoft.com/wiki/fallback-recovery-os-mode.html)
2.  Open **Terminal** → run the `diskutil addPartition` command shown above to recreate the main APFS container + “Macintosh HD”. [\[discussion....apple.com\]](https://discussions.apple.com/thread/253777530)
3.  Quit Terminal → **Reinstall macOS Sequoia** to **Macintosh HD**. [\[support.apple.com\]](https://support.apple.com/guide/mac-help/macos-recovery-a-mac-apple-silicon-mchl82829c17/mac)

If any step fails, go straight to **Option B: DFU Restore** with Apple Configurator 2. It’s the sure, Apple‑supported “factory fresh” path that also repairs firmware and recovery. [\[talk.tidbits.com\]](https://talk.tidbits.com/t/recovery-on-apple-silicon-macs/21465)

***

