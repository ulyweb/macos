try
	-- Get the status with admin rights
	set statusRaw to do shell script "profiles status -type bootstraptoken" with administrator privileges
	
	-- Check for the specific "YES" status
	if statusRaw contains "escrowed to server: YES" then
		
		-- SUCCESS ALERT (BOLD & GREEN STYLE)
		display alert "✅ PHASE 1 COMPLETE: TOKENS SECURED" message "--------------------------------------------------
STATUS: ESCROW SECURED
--------------------------------------------------

The Master Token has been successfully saved to Jamf. 

DETAILS:
" & statusRaw as informational buttons {"Proceed to Phase 2"} default button "Proceed to Phase 2"
		
	else
		
		-- CRITICAL FAILURE ALERT (RED STYLE)
		display alert "🚨 CRITICAL ERROR: TOKEN NOT SECURED" message "--------------------------------------------------
STATUS: ESCROW FAILED
--------------------------------------------------

STOP! The token is NOT secured in Jamf. 

DO NOT hand this Mac to the user. Re-enroll or check Jamf connection.

DETAILS:
" & statusRaw as critical buttons {"Cancel Setup"} default button "Cancel Setup"
		
	end if
	
on error err
	display alert "SYSTEM ERROR" message "Could not communicate with security chip: " & err as critical
end try
