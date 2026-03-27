-- Ask for the Staging Admin's short name
display dialog "Enter the Short Name of the IT Admin account to remove:" default answer "admin" buttons {"Cancel", "Delete Admin"} default button "Delete Admin" with icon caution
set adminName to text returned of result

-- Confirmation Warning
display dialog "This will securely delete the account '" & adminName & "' and update the startup disk security. Proceed?" buttons {"Cancel", "Yes, Cleanup"} default button "Yes, Cleanup" with icon stop

-- Execute the Phase 4 commands with Admin Privileges
try
    do shell script "sysadminctl -deleteUser " & adminName & " -secure" with administrator privileges
    do shell script "diskutil apfs updatePreboot /" with administrator privileges
    do shell script "/usr/local/bin/jamf recon" with administrator privileges
    
    display dialog "Success! The Admin has been removed, Preboot is updated, and Jamf has been synced." buttons {"OK"} default button "OK"
on error aria
    display dialog "Error: " & aria buttons {"OK"} default button "OK" with icon stop
end try
