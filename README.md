# macos
macOS information

````
sudo /usr/local/jamf/bin/Jamf RemoveMDMProfile
sudo /usr/local/jamf/bin/Jamf removeFramework
Reboot
````

````
sudo profiles renew -type enrollment
sudo jamf recon && jamf policy
Reboot
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
