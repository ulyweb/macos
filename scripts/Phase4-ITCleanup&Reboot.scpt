-- Phase 4: Identify Admin to Remove
display dialog "Enter the Short Name of the IT Admin account to remove:" default answer "admin" buttons {"Cancel", "Delete Admin"} default button "Delete Admin" with icon caution
set adminName to text returned of result

-- Confirmation Warning
display dialog "This will securely delete the IT Admin account and update startup security. Proceed?" buttons {"Cancel", "Yes, Cleanup"} default button "Yes, Cleanup" with icon stop

try
	-- Perform the background cleanup
	do shell script "sysadminctl -deleteUser " & adminName & " -secure" with administrator privileges
	do shell script "diskutil apfs updatePreboot /" with administrator privileges
	do shell script "/usr/local/bin/jamf recon" with administrator privileges
	
	-- Post-Cleanup Success Message
	display dialog "Success! The Admin has been removed, Preboot is updated, and Jamf has been synced." buttons {"OK"} default button "OK"
	
	-- NEW: The Force Reboot Prompt
	display dialog "To finalize the security setup (Phase 5), a restart is required. 
	
Please save all work and close running apps before continuing." buttons {"Restart Later", "Restart Now"} default button "Restart Now" with icon note
	
	set userChoice to button returned of result
	
	if userChoice is "Restart Now" then
		-- Force a graceful restart
		tell application "System Events" to restart
	else
		display dialog "Cleanup complete. Please remember to manually restart your Mac soon to verify the login screen." buttons {"Got it"} default button "Got it"
	end if
	
on error errorMessage
	display dialog "Error: " & errorMessage buttons {"OK"} default button "OK" with icon stop
end try
