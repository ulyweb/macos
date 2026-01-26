Short answer: **No**—in **macOS Recovery** you generally **can’t** use  
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
  "https://swcdn.apple.com/content/downloads/XX/YY/ZZZZZZZZ/AAAAAA/InstallAssistant.pkg"
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

If you tell me the **exact version** you want (e.g., **15.7.2**), I’ll reply with a **direct Apple CDN link** you can paste into the `curl` command above. These links are listed by reputable admin sites and point **directly to Apple’s servers**—handy when `softwareupdate` is unreliable or you’re stuck in Recovery. [\[mrmacintosh.com\]](https://mrmacintosh.com/macos-sequoia-full-installer-database-download-directly-from-apple/)

***

### Quick recap

*   `softwareupdate --fetch-full-installer ...` → **works when macOS is booted**, saves to **/Applications**. **Not** the right tool inside Recovery. [\[osxdaily.com\]](https://osxdaily.com/2020/04/13/how-download-full-macos-installer-terminal/)
*   In Recovery, use **Terminal + `curl`** to download **Apple‑hosted `InstallAssistant.pkg`** to **/Volumes/Source**, **install** it there to get the **.app**, then **`createinstallmedia`** to build your second USB. [\[support.apple.com\]](https://support.apple.com/en-us/101578), [\[apple.stac...change.com\]](https://apple.stackexchange.com/questions/478657/error-fetching-full-installer-with-the-softwareupdate-command)

I’m happy to drop in the **exact `curl` line** with a current Sequoia pkg URL if you confirm the version/build you want.
