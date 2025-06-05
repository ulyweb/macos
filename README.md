# macos
macOS information

````
sudo /usr/local/jamf/bin/Jamf RemoveMDMProfile && sudo /usr/local/jamf/bin/Jamf removeFramework && sudo Reboot
````

````
sudo profiles renew -type enrollment && sudo jamf recon && jamf policy && sudo Reboot
````


````
-- Display a confirmation dialog
set confirmation to button returned of (display dialog "Are you sure you want to enroll from Jamf?" buttons {"Cancel", "enroll"} default button "Cancel" with title "enroll Jamf")

-- If the user confirms, proceed with unenrollment
if confirmation is "enroll" then
	-- Define the commands to unenroll from Jamf
	-- Run the commands with admin privileges
	do shell script "sudo profiles renew -type enrollment" with administrator privileges
	do shell script "sudo jamf recon && jamf policy" with administrator privileges
	-- do shell script "sudo /usr/local/jamf/bin/Jamf RemoveMDMProfile" with administrator privileges
	-- do shell script "sudo /usr/local/jamf/bin/Jamf removeFramework" with administrator privileges
	
	
	
	
	
	-- Notify the user that unenrollment is complete
	display dialog "Jamf enrollment completed." buttons {"OK"} default button "OK" with title "enroll Jamf"
else
	-- User canceled the operation
	display dialog "Jamf enrollment canceled." buttons {"OK"} default button "OK" with title "enroll Jamf"
end if
````

#### How to install Homebrew & install pip (Python Package Manager)

````
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew --version

````

````
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
source ~/.zshrc

or

echo >> /Users/userHERE/.zprofile
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/userHERE/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
````

### Install pip (Python Package Manager)

````
brew install python
pip3 --version

or
Option 2: Install pip Manually
If you want to install pip without Homebrew, run:

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py
````


To map or access a network folder or SMB share in macOS using the terminal, you can use the following methods:

1. Using the `mount` command:

```bash
mkdir ~/mountpoint
mount -t smbfs //username@server/share ~/mountpoint
```

Replace "username", "server", "share", and "mountpoint" with your specific details.

2. Using the `open` command:

```bash
open "smb://username@server/share"
```

This method will open the network share in Finder.

3. For more complex setups, especially if connecting to an Active Directory domain:

```bash
mount_smbfs //'DOMAIN;username'@server.example.com/share ~/mountpoint
```

Replace "DOMAIN", "username", "server.example.com", "share", and "mountpoint" as needed.

When using these commands:
- You'll be prompted for a password if required.
- Ensure you have the necessary permissions to access the share.
- The mountpoint directory should exist before mounting.

To unmount the share:

```bash
umount ~/mountpoint
```

Remember to replace "mountpoint" with the actual directory name you used.

To install an installer .pkg file using the macOS terminal, you can use the following command:

```bash
sudo installer -pkg /path/to/your/package.pkg -target /
```

Replace "/path/to/your/package.pkg" with the actual path to your .pkg file. This command will install the package to the root directory (/).

If you want to install the package without entering your password each time, you can use:

```bash
echo "your_admin_password" | sudo -S installer -pkg /path/to/your/package.pkg -target /
```

However, be cautious with this method as it may expose your password in the command history.

For a more secure approach, you can also use:

```bash
sudo installer -allowUntrusted -verboseR -pkg /path/to/your/package.pkg -target /
```

This command allows for untrusted packages and provides verbose output during installation.

Remember that you'll need administrator privileges to install most .pkg files. If you don't have admin access, you can install to your home directory using:

```bash
installer -pkg /path/to/your/package.pkg -target ~
```

>[!Note]
>### How to download Chrome via terminal command.
> >#### ***Open Terminal, then type or copy&pasta the command below:***
>
>````
>cd Downloads 
>pwd
>curl https://dl.google.com/chrome/mac/universal/stable/CHFA/googlechrome.dmg --output ./googlechrome.dmg
>````
