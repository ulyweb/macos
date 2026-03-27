Step 1:
I login with my credentials 

Then you'll get prompt for "Enabling FileVault"

I select "Don't Enable"

Accessiblity "Not Now"

Touch ID

Set Up Touch ID Later
Continue

Choose Your Look
Auto
Continue

Welcome to Mac
Continue

Now You'll see the Welcome! for Zero-Touch  enrollment.
Let it finish.
While it's installing all of the apps 

you can enable your account to be an admin
but first you'll need to get the currently password from the Jamf Pro portal for
that particular device.
After you login to Jamf Pro, search fo that device.
Once you found it, under Inventory, General, In the Managed Local Administory Accounts:
Select "View accounts and password"
This will route you to Managed Local Administrator Accounts
Now select username called _jssadm and click View password from the right side.
That's the password for you to change your account to be admin.
So go to Setting in the macOS device that you are working.
Scroll down to "Users & Groups"
Select Your username and click the I icon.
Click the button to "Allow this user to administer this computer"
It will prompt for username and password:
the username is: _jssadmin
and the password: grab it from the Jamf Pro Portal.


````
sysadminctl -secureTokenStatus Username
sudo profiles status -type bootstraptoken
diskutil apfs listUsers /
sudo fdesetup list
````

````
USER="usernameHERE"; echo "--- FileVault Users ---"; sudo fdesetup list | grep "$USER"; echo "--- APFS Tokens ---"; diskutil apfs listUsers / | grep -i $(sudo fdesetup list | grep "$USER" | awk -F',' '{print $NF}')
````

````
read -p "Enter Primary Username: " USER; echo "--- Verification for: $USER ---"; UUID=$(sudo fdesetup list | grep -i "$USER" | awk -F',' '{print $NF}'); if [ -z "$UUID" ]; then echo "Error: User not found in FileVault list."; else echo "FileVault UUID: $UUID"; echo "--- APFS Token Match ---"; diskutil apfs listUsers / | grep -i "$UUID"; fi
````

````
sysadminctl -secureTokenStatus Username
sudo sysadminctl interactive -secureTokenOn  username
Jamf recon
````

to list users type in:
````
Jamf listUsers
````
