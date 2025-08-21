This script is supported on macOS or Linux. Modify it to work cross-platform using a **terminal-based menu**.

---

## **How to Run This on macOS or Linux?**
1. **Use PowerShell Core (pwsh)** – Windows PowerShell (v5.1) is Windows-only, but PowerShell Core (v7+) works on macOS & Linux.  
2. **We’ll replace it with a text-based menu**.  
3. **Ensure Required Modules Are Installed**  
   - **ExchangeOnlineManagement** (`Install-Module ExchangeOnlineManagement`)  
   - **MSOnline** (`Install-Module MSOnline`)  

---

## **Updated Script for macOS & Linux**
This version works on **Windows, macOS, and Linux** using a **text-based menu**:

```powershell
# Check if PowerShell Core is installed
if ($PSVersionTable.PSEdition -ne "Core") {
    Write-Host "This script requires PowerShell Core (pwsh). Install it from https://aka.ms/powershell" -ForegroundColor Red
    exit
}

# Function to Connect to Exchange Online
function Connect-Exchange {
    try {
        Write-Host "`nConnecting to Exchange Online..."
        Connect-ExchangeOnline -ErrorAction Stop
        Write-Host "Connected to Exchange Online!" -ForegroundColor Green
    } catch {
        Write-Host "Error: Failed to connect to Exchange Online - $_" -ForegroundColor Red
    }
}

# Function to Get Room Mailbox Creation Date
function Get-RoomCreationDate {
    param ([string]$roomMailbox)

    try {
        $mailbox = Get-Mailbox -Identity $roomMailbox -ErrorAction Stop
        $creationDate = (Get-MsolUser -UserPrincipalName $mailbox.PrimarySmtpAddress).WhenCreated
        Write-Host "`nRoom Created On: $creationDate" -ForegroundColor Cyan
    } catch {
        Write-Host "Error: Could not retrieve creation date for $roomMailbox" -ForegroundColor Red
    }
}

# Function to Get Permission Changes from Audit Logs
function Get-PermissionChanges {
    param ([string]$roomMailbox)

    try {
        $startDate = (Get-Date).AddDays(-30)
        $endDate = Get-Date
        $auditLogs = Search-UnifiedAuditLog -StartDate $startDate -EndDate $endDate -RecordType ExchangeAdmin `
            -Operations "Add-MailboxPermission", "Remove-MailboxPermission", "Set-MailboxFolderPermission" -ResultSize 1000 |
            Where-Object { $_.ObjectId -match $roomMailbox }

        if ($auditLogs) {
            Write-Host "`nPermission Changes:`n" -ForegroundColor Yellow
            $auditLogs | Format-Table -AutoSize
        } else {
            Write-Host "No permission changes found in the last 30 days for $roomMailbox." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "Error: Unable to retrieve permission changes for $roomMailbox" -ForegroundColor Red
    }
}

# Function to Show Menu
function Show-Menu {
    Clear-Host
    Write-Host "===========================" -ForegroundColor Blue
    Write-Host "  Exchange Online Utility  " -ForegroundColor Green
    Write-Host "===========================" -ForegroundColor Blue
    Write-Host "1. Connect to Exchange Online"
    Write-Host "2. Get Room Creation Date"
    Write-Host "3. Get Permission Changes"
    Write-Host "4. Exit"

    $choice = Read-Host "`nEnter your selection (1-4)"
    
    switch ($choice) {
        1 {
            Connect-Exchange
            Start-Sleep -Seconds 2
            Show-Menu
        }
        2 {
            $roomMailbox = Read-Host "Enter Room Mailbox"
            if ($roomMailbox) {
                Get-RoomCreationDate -roomMailbox $roomMailbox
            } else {
                Write-Host "Room mailbox cannot be empty." -ForegroundColor Red
            }
            Start-Sleep -Seconds 3
            Show-Menu
        }
        3 {
            $roomMailbox = Read-Host "Enter Room Mailbox"
            if ($roomMailbox) {
                Get-PermissionChanges -roomMailbox $roomMailbox
            } else {
                Write-Host "Room mailbox cannot be empty." -ForegroundColor Red
            }
            Start-Sleep -Seconds 3
            Show-Menu
        }
        4 {
            Write-Host "Exiting..." -ForegroundColor Green
            exit
        }
        Default {
            Write-Host "Invalid selection, please choose a valid option." -ForegroundColor Red
            Start-Sleep -Seconds 2
            Show-Menu
        }
    }
}

# Run the Menu
Show-Menu
```

---
## How to install Homebrew on macOS
   - Step 1:
````
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew --version
````
   - Next steps:
````
echo >> /Users/ENTER YOUR USERNAME HERE/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/ENTER YOUR USERNAME HERE/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
````
   - Run brew --version:
````
brew --version
````

## **How to Run on macOS/Linux**
1. **Ensure PowerShell Core (pwsh) is installed**  
   - macOS: `brew install powershell`  
   - Linux: `sudo apt install powershell -y` (Debian/Ubuntu)  
   - Fedora: `sudo dnf install powershell -y`  

2. **Run Powershell**  
   - macOS: `pwsh`  
   - Linux: `powershell` (Debian/Ubuntu)  

3. **Install Required Modules** (Install a module only for the current user)
   - `Install-Module ExchangeOnlineManagement -Scope CurrentUser`  
   - `Install-Module MSOnline -Scope CurrentUser`
     
✅ **Find and install a module** 
✅ **This example finds a module in the repository and installs the module**
   - `Find-Module -Name PowerShellGet | Install-Module`

✅ ***The Find-Module uses the Name parameter to specify the PowerShellGet module. By default, the newest version of the module is downloaded from the repository. The object is sent down the pipeline to the Install-Module cmdlet. 
Install-Module installs the module for all users in $env:ProgramFiles\PowerShell\Modules.***

✅ **Other useful module to be install**
   - `Install-Module -Name PSWindowsUpdate -Scope CurrentUser`
   - `Install-Module -Name Az.Accounts -Scope CurrentUser` 
   - `Install-Module -Name DellBIOSProvider -Scope CurrentUser`


4. **Connecting Online**  
   - `Connect-ExchangeOnline -UserPrincipalName "Full.email.address@domain.com"`

4. **Run the Script**  
   - Save the script as `ExchangeMenu.ps1`  
   - Open Terminal & run:  
     ```bash
     pwsh ExchangeMenu.ps1
     ```

---

## **This Works on macOS**
✅ **Uses PowerShell Core (`pwsh`)**  
✅ **Provides a Text-Based Menu**  
✅ **Works in Any Terminal**  


## **Installing CotEditor via Homebrew

> [!TIP]
>> ## Open Terminal:**
> - Launch the Terminal application on your Mac (located in Applications > Utilities).
>> ### Ensure Homebrew is installed:
> - If you don't have Homebrew, you can install it by following the instructions on the Homebrew website.
> - After installation, run brew update to make sure Homebrew is up-to-date.
>> ### Install CotEditor:
> - Execute the following command in Terminal: ``` brew install --cask coteditor ```
>> ### Install TextMate:
> - Execute the following command in Terminal: ``` brew install --cask textmate ```
>> ### Install Gedit:
> - Execute the following command in Terminal: ``` brew install gedit ```
>> ### Install ghex:
> - Execute the following command in Terminal: ``` brew install ghex ```
>> ### Launch CotEditor, Textmate, gedit and ghex:
> - Once the installation completes, you'll find CotEditor in your Applications folder and can launch it like any other app.
