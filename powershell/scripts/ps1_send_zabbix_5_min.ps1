# Task scheduler
# General, Ensure "Run with highest privileges" is checked, set to run even if the user is not logged on.
# Trigger, daily, recur every 1 days, repeat task every 5 min, for a duration of indefinitely, stop of runs longer then 30 min
# Action is set to start a program.
# Program/script is set to "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
# Add arguments:
# -ExecutionPolicy Bypass -File "C:\OP\Jobs\ScheduleTasks\ps_send_zabbix.ps1"  <-- Update this path!
# Settings, stop if longer then 1 hour

# Zabbix server
# Set zabbix item to, trapper agent, type numeric float, units mb
# Result for item: vmhybrid01, WorkingSetMBTrapper, 47.36 mb

$processName = "zabbix_agent2"

# Function to append to the log file
function Write-Log {
    param(
        [string]$Message
    )
	$logFile = "C:\OP\Jobs\ScheduleTasks\ps_send_zabbix.log"  # Log file for tracking deletions
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp - $Message"
    $logEntry | Out-File -FilePath $logFile -Append
}


$st = "Start script"
Write-Log $st
$value = [math]::Round((Get-Process -Name $processName).WorkingSet / 1MB, 2)
# Write-Host $value.GetType().Name
Write-Log $value
$info = "WorkingSetMBTrapper: $value"
Write-Log $info

$result = C:\OP\Zabbix\zabbix_agent-7.0.24-windows-amd64-openssl\bin\zabbix_sender.exe -z 192.168.3.5 -s "vmhybrid01"  -k "WorkingSetMBTrapper" -o $value
Write-Host $result
Write-Log $result