# Version: 1.0.0
# Description: Queries the Application log for Event ID 1000 crashes caused by w3wp.exe and outputs TimeCreated and Source.

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

        if ($Events.Count -eq 0) {
            Write-Host "No matching Event ID 1000 logs found for w3wp.exe." -ForegroundColor Yellow
            return
        }

        # Format and output the requested properties
        $Results = $Events | Select-Object @{Name = 'DateTime'; Expression = { $_.TimeCreated }},
                                          @{Name = 'Source';   Expression = { $_.ProviderName }}

        $Results | Format-Table -AutoSize
    }
    catch {
        Write-Host "Encountered Error: " $_.Exception.Message -ForegroundColor Red
    }
}

# Run the function
Get-W3wpErrors