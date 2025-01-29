-- Define constants
property logFile : "/private/var/log/jamf_unenrollment.log"
property jamfBinary : "/usr/local/jamf/bin/jamf"

-- Display a confirmation dialog
set confirmation to button returned of (display dialog "Are you sure you want to unenroll this Mac from Jamf? This action cannot be undone." buttons {"Cancel", "Unenroll"} default button "Cancel" with icon caution with title "Jamf Unenrollment")

-- If the user confirms, proceed with unenrollment
if confirmation is "Unenroll" then
    try
        -- Check if enrolled
        set enrollmentStatus to do shell script jamfBinary & " checkJSSConnection"
        if enrollmentStatus does not contain "Successfully connected to the JSS" then
            display dialog "This Mac is not enrolled in Jamf." buttons {"OK"} default button "OK" with icon note with title "Not Enrolled"
        else
            -- Run the unenrollment commands with admin privileges
            do shell script "echo 'Starting Jamf unenrollment at '$(date) >> " & logFile with administrator privileges
            do shell script "sudo " & jamfBinary & " removeMDMProfile >> " & logFile & " 2>&1" with administrator privileges
            do shell script "sudo " & jamfBinary & " removeFramework >> " & logFile & " 2>&1" with administrator privileges
            
            -- Notify the user that unenrollment is complete and prepare for reboot
            display dialog "Jamf unenrollment completed. Your Mac will restart in 10 seconds." buttons {"OK"} default button "OK" with icon note with title "Unenrollment Successful"
            
            -- Pause for 10 seconds
            delay 10
            
            -- Force reboot
            do shell script "sudo shutdown -r now" with administrator privileges
        end if
    
    on error errMsg
        -- Log the error
        do shell script "echo 'Error: " & errMsg & "' >> " & logFile
        
        -- Display an error message
        display dialog "An error occurred during Jamf unenrollment: " & errMsg buttons {"OK"} default button "OK" with icon stop with title "Unenrollment Error"
    end try
else
    -- User canceled the operation
    display dialog "Jamf unenrollment canceled." buttons {"OK"} default button "OK" with icon caution with title "Unenrollment Canceled"
end if

-- Offer to show the log file (only if we haven't rebooted)
set showLog to button returned of (display dialog "Would you like to view the unenrollment log?" buttons {"No", "Yes"} default button "No" with title "View Log")
if showLog is "Yes" then
    do shell script "open " & logFile
end if
