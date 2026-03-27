# This checklist ensures that when you hand the laptop over, the user is the sole owner, encryption is safe, and Jamf is updated.
Phase 1: Admin Pre-Configuration

* First Login: Admin (you) logs in first.
* Install Apps: Install Microsoft 365, Zoom, Box, Printers, etc.
* Escrow Check: Verify the Mac sent its "Master Key" to Jamf.
* Command: sudo profiles status -type bootstraptoken (Must say YES for Escrow).

Phase 2: Primary User Hand-off (The "Setup")

* User Login: Have the Primary User log in with their own credentials.
* App Activation:
* Open Outlook and sign them in.
   * Open Box/OneDrive and sync their folders.
   * Sign into Zoom and test the camera/mic.
* Token Generation: Because Phase 1 confirmed the Bootstrap Token, macOS automatically grants this user a Secure Token the moment they log in.

Phase 3: The "Point of No Return" Verification
Before you delete your Admin account, run your Pro Table Command to ensure the User is a "Volume Owner":

* Run Table Check:

echo -e "USERNAME\tUUID\tSTATUS" && diskutil apfs listUsers / -plist | grep -A1 "UUID" | grep "string" | sed 's/.*>\(.*\)<.*/\1/' | while read -r uuid; do name=$(dscl . -search /Users GeneratedUID "$uuid" | awk 'NR==1{print $1}'); if [ -z "$name" ]; then name="System/Recovery"; fi; echo -e "$name\t$uuid\t[SECURE TOKEN]"; done | column -t -s $'\t'

* Requirement: The Primary User’s name must appear in this list.
* Check FileVault: Run sudo fdesetup list. Ensure the user is listed here too.

Phase 4: Cleaning & Syncing

* Delete Admin: Remove your setup account securely so the user is the only one left.
* Command: sudo sysadminctl -deleteUser [YourAdminName] -secure
* Update Preboot: Tell the disk that the Admin is gone and the User is the new boss.
* Command: diskutil apfs updatePreboot /
* Sync Jamf: Force the Mac to tell the Jamf Pro Portal that the owner is set and encrypted.
* Command: sudo jamf recon

Phase 5: The "Proof" Restart

* Reboot the Mac: Have the user type their password at the very first screen (the black screen with the Apple logo).
* Confirm: If they get to the desktop, the hand-off is a success.

Pro-Tip: If the user is a Standard User, always perform Phase 4 via a Jamf Policy or while you are still logged into the Admin account, as they won't have the permissions to delete you!
Do you need the Jamf Pro Smart Group criteria to automatically track these M4 Macs once they hit the "Completed" status in your portal?

