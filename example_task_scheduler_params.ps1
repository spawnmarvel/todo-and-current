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
