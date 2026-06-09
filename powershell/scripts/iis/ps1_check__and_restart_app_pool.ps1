# Task scheduler
# Ensure "Run with highest privileges" is checked.
# Ensure that the task is set to run even if the user is not logged on.
# Action is set to start a program.
# Program/script is set to "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
# Add arguments:
# -ExecutionPolicy Bypass -File "C:\OP\Jobs\ScheduleTasks\ps_check_aspenapppoolx64_start.ps1"  <-- Update this path!


# AppPool-Watchdog.ps1
# Checks the state of a specific IIS Application Pool and attempts to start it if stopped.

# --- Configuration ---
Import-Module WebAdministration

# 1. Define the Application Pool to monitor
$AppPoolName = "myAppPool"


# 2. Define the log file path
$logFile = "F:\LogsPS1\AppPool_Watchdog_log.txt" 

# --- Function ---
# Function to append to the log file
function Write-Log {
    param(
        [string]$Message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp - $Message"
    $logEntry | Out-File -FilePath $logFile -Append
}

# --- Main Logic ---
Write-Log "--- Starting Check for $AppPoolName ---"

try {
    # Attempt to retrieve the App Pool object
    $AppPool = Get-Item "IIS:\AppPools\$AppPoolName" -ErrorAction Stop
}
catch {
    # If the App Pool doesn't exist, log the error and exit the script
    $ErrorMessage = "App Pool '$AppPoolName' not found. Error: $($_.Exception.Message)"
    Write-Host $ErrorMessage
    Write-Log $ErrorMessage
    exit 1
}

# Get the initial state
$State = $AppPool.State
$InitialStatusMessage = "Initial state of '$AppPoolName' is '$State'."
Write-Host $InitialStatusMessage
Write-Log $InitialStatusMessage


# --- Remediation ---
if ($State -ne "Started") {
    $AttemptMessage = "App Pool '$AppPoolName' is '$State'. Attempting to START..."
    Write-Host $AttemptMessage
    Write-Log $AttemptMessage

    try {
        # Execute the restart command
        $AppPool.Start()
        
        # Wait a few seconds for the state change to register
        Start-Sleep -Seconds 5 
        
        # Re-check the state
        $NewState = (Get-Item "IIS:\AppPools\$AppPoolName").State
        
        if ($NewState -eq "Started") {
            $SuccessMessage = "SUCCESS: '$AppPoolName' is now '$NewState'."
            Write-Host $SuccessMessage
            Write-Log $SuccessMessage
        } else {
            $FailMessage = "FAILURE: Could not start '$AppPoolName'. Final state is '$NewState'."
            Write-Host $FailMessage
            Write-Log $FailMessage
        }
    }
    catch {
        $ErrorMessage = "CRITICAL ERROR during Start attempt: $($_.Exception.Message)"
        Write-Host $ErrorMessage
        Write-Log $ErrorMessage
    }
}
else {
    # App Pool is already Started.
    $RunningMessage = "'$AppPoolName' is already '$State'. No action needed."
    Write-Host $RunningMessage
    Write-Log $RunningMessage
}

Write-Log "--- Check Complete ---`n" 
