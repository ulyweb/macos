-- Define constants
property logFile : "/private/var/log/jamf_enrollment.log"
property jamfBinary : "/usr/local/jamf/bin/jamf"

-- Display a confirmation dialog
set confirmation to button returned of (display dialog "Are you sure you want to enroll this Mac in Jamf?" buttons {"Cancel", "Enroll"} default button "Cancel" with icon caution with title "Jamf Enrollment")

-- If the user confirms, proceed with enrollment
if confirmation is "Enroll" then
    try
        -- Check if already enrolled
        set enrollmentStatus to do shell script jamfBinary & " checkJSSConnection"
        if enrollmentStatus contains "Successfully connected to the JSS" then
            display dialog "This Mac is already enrolled in Jamf." buttons {"OK"} default button "OK" with icon note with title "Already Enrolled"
        else
            -- Run the enrollment command with admin privileges
            do shell script "echo 'Starting Jamf enrollment at '$(date) >> " & logFile with administrator privileges
            do shell script "sudo " & jamfBinary & " enroll -verbose >> " & logFile & " 2>&1" with administrator privileges
            
            -- Verify enrollment
            set verifyEnrollment to do shell script jamfBinary & " checkJSSConnection"
            if verifyEnrollment contains "Successfully connected to the JSS" then
                display dialog "Jamf enrollment completed successfully. Please restart your Mac to apply all changes." buttons {"OK"} default button "OK" with icon note with title "Enrollment Successful"
            else
                error "Enrollment verification failed"
            end if
        end if
    
    on error errMsg
        -- Log the error
        do shell script "echo 'Error: " & errMsg & "' >> " & logFile
        
        -- Display an error message
        display dialog "An error occurred during Jamf enrollment: " & errMsg buttons {"OK"} default button "OK" with icon stop with title "Enrollment Error"
    end try
else
    -- User canceled the operation
    display dialog "Jamf enrollment canceled." buttons {"OK"} default button "OK" with icon caution with title "Enrollment Canceled"
end if

-- Offer to show the log file
set showLog to button returned of (display dialog "Would you like to view the enrollment log?" buttons {"No", "Yes"} default button "No" with title "View Log")
if showLog is "Yes" then
    do shell script "open " & logFile
end if
