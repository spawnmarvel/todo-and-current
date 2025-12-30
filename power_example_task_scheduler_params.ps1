# Task scheduler
# Ensure "Run with highest privileges" is checked.
# Ensure that the task is set to run even if the user is not logged on.
# Action is set to start a program.
# Program/script is set to "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
# Add arguments:
# -ExecutionPolicy Bypass -File "C:\OP\Jobs\ScheduleTasks\ps_web_app_pool_restart.ps1"

Import-Module WebAdministration
# Get-IISAppPool -Name "myAppPool"
Restart-WebAppPool -Name "myAppPool"
# Swap space goes down after 1 min to normal 15gb

# 1. Define the log file path
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