-- Phase 1: Verify Bootstrap Token Status
try
	-- Run the command with admin privileges to get the "live" status
	set tokenStatus to do shell script "profiles status -type bootstraptoken" with administrator privileges
	
	-- Check if the output contains "YES" for escrow
	if tokenStatus contains "escrowed to server: YES" then
		display dialog "✅ BOOTSTRAP TOKEN VERIFIED!
		
The Mac has successfully sent the Master Key to Jamf.
		
STATUS DETAILS:
" & tokenStatus buttons {"Proceed to Phase 2"} default button "Proceed to Phase 2" with icon note
	else
		-- If it says NO or isn't found
		display alert "❌ ERROR: TOKEN NOT ESCROWED" message "The Bootstrap Token is NOT saved in Jamf. 
		
DO NOT hand this Mac to the user yet. 

Current Status:
" & tokenStatus as critical
	end if
	
on error errorMessage
	display alert "System Error" message "Could not verify token: " & errorMessage as critical
end try
