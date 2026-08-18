# Version: 1.0.3
# Description: Queries the Application log for Event ID 1000 crashes caused by w3wp.exe, outputs Hostname, DateTime, and Source, and appends total error count with execution host and timestamp at the end.

function Get-W3wpErrors {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [int]$MaxEvents = 100
    )

    try {
        Write-Host "Querying Event Viewer for Event ID 1000 involving w3wp.exe..." -ForegroundColor Green

        # Define the filter hashtable for maximum query speed
        $Filter = @{
            LogName = 'Application'
            Id      = 1000
        }

        # Query events and filter for w3wp.exe in the message content
        $Events = Get-WinEvent -FilterHashtable $Filter -MaxEvents $MaxEvents -ErrorAction Stop | 
                  Where-Object { $_.Message -like "*w3wp.exe*" }

        $ErrorCount = $Events.Count
        $CurrentHost = $env:COMPUTERNAME
        $ExecutionTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

        if ($ErrorCount -eq 0) {
            Write-Host "No matching Event ID 1000 logs found for w3wp.exe." -ForegroundColor Yellow
            Write-Host "`nTotal Application Errors Found: 0 on $CurrentHost at $ExecutionTime" -ForegroundColor Green
            return
        }

        # Format and output Hostname, DateTime/Time, and Source
        $Results = $Events | Select-Object @{Name = 'Hostname'; Expression = { $_.MachineName }},
                                          @{Name = 'DateTime'; Expression = { $_.TimeCreated.ToString("yyyy-MM-dd HH:mm:ss") }},
                                          @{Name = 'Source';   Expression = { $_.ProviderName }}

        $Results | Format-Table -AutoSize

        # Summary line output at the end
        Write-Host "Total Application Errors Found: $ErrorCount on $CurrentHost at $ExecutionTime" -ForegroundColor Green
    }
    catch {
        Write-Host "Encountered Error: " $_.Exception.Message -ForegroundColor Red
    }
}

# Run the function
Get-W3wpErrors