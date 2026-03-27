> [!Note]
> ## IT Standard Operating Procedure (SOP) for provisioning MacBook Pro devices on macOS 15.x.
>> __*Explains the "Why" behind every step so the team understands the security logic.*__
------------------------------
### **MacBook Pro: Secure Provisioning GuideObjective**
>>**To ensure the Primary User (Owner) has full cryptographic ownership of the device, can authorize sudo commands, and can unlock FileVault encryption, while safely removing the Staging Admin account used for setup.**
------------------------------
### **Phase 1: Admin Pre-Configuration (The "Builder" Phase)**

* **Action:** Log in as a local IT Admin first. Install all required software (Office, Zoom, Box, Printers).
* **The "Why":**
* **Secure Token Initiation:** The first user to log into an Apple Silicon Mac "claims" the first Secure Token. This admin account acts as the "Master Key" to authorize the rest of the system's security.
   * **Bootstrap Token Escrow:** By logging in first and being managed by Jamf, the Mac sends a **Bootstrap Token** to the Jamf Pro server. This is a "backup key" that allows Jamf to grant tokens to future users automatically.
* **Verification:**
```
Run sudo profiles status -type bootstraptoken.
```
* ___**IT Note: If this says NO, the rest of the workflow will fail. Stop here and re-enroll.**___

### **Phase 2: Primary User Onboarding (The "Hand-off")**

* **Action:** Have the Primary User log in and configure their Outlook, Zoom, and Box profiles.
* **The "Why":**
* **Automatic Token Granting:** Because the Bootstrap Token is in Jamf (Phase 1), macOS silently grants the Primary User their own **Secure Token** the moment they log in.
   * Volume Ownership: On Macs, a user must be a "Volume Owner" to perform updates or use ``sudo``. This happens automatically during this login.

### **Phase 3: The "Trust Chain" Audit**

* **Action:** Run the Pro Table Command to verify both the Admin and User are listed.
* **The "Why":**
* **Prevent Lockouts:** We must verify the Primary User has a token before deleting the Admin. If you delete the only token-holder on the Mac, the disk becomes "orphaned," and you may have to wipe the entire laptop to fix it.
   * **Verification Command:**
````
echo -e "USERNAME\tUUID\tSTATUS" && diskutil apfs listUsers / -plist | grep -A1 "UUID" | grep "string" | sed 's/.*>\(.*\)<.*/\1/' | while read -r uuid; do name=$(dscl . -search /Users GeneratedUID "$uuid" | awk 'NR==1{print $1}'); if [ -z "$name" ]; then name="System/Recovery"; fi; echo -e "$name\t$uuid\t[SECURE TOKEN]"; done | column -t -s $'\t'
````

### **Phase 4: Admin Removal & Final Sync**

* **Action:** Delete the Staging Admin account (sysadminctl -deleteUser) and run sudo jamf recon.
* **The "Why":**
* **Security Best Practice:** We remove the local admin so there is only one authorized user on the device, reducing the "attack surface."
   * **Preboot Update:** Running ``diskutil apfs updatePreboot /`` ensures the macOS login screen (before the OS even loads) knows the Admin is gone and only shows the Primary User.
   * **Jamf Reporting:** The recon command ensures the Jamf Pro Portal correctly shows "FileVault: On" and "Secure Token: Yes" for the Primary User.

### **Phase 5: The "Cold Boot" Test**

* **Action:** Restart the Mac and have the user log in from a powered-off state.
* **The "Why":**
* **FileVault Success:** If the user can type their password at the first screen and the progress bar starts, they have successfully decrypted the disk. The Mac is now fully secured and owned by the user.

------------------------------
Summary for the Team:
On Macs, **Tokens = Ownership.** We use the Admin to "prime" the system and the User to "claim" the disk. This workflow ensures no one gets locked out of encrypted drives.


