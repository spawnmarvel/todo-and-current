Import-Module WebAdministration

# look at support 000102143
# If you want an even more concise report, here's one that shows the current values alongside the recommended values:

$DateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$HostName = $env:COMPUTERNAME

Write-Host ""
Write-Host "$DateTime $HostName"
Write-Host ""

$appPools = @(
    "xxxxxxxAppPool",
    "xxxxxxxAppPoolx64"
)

foreach ($pool in $appPools) {

    Write-Host "`n==============================="
    Write-Host "Application Pool: $pool"
    Write-Host "==============================="

    $ap = Get-Item "IIS:\AppPools\$pool"

    $log = Get-WebConfigurationProperty `
        -PSPath 'MACHINE/WEBROOT/APPHOST' `
        -Filter "system.applicationHost/applicationPools/add[@name='$pool']/recycling" `
        -Name logEventOnRecycle

    [PSCustomObject]@{
        Setting         = "Idle Timeout (minutes)"
        Current         = $ap.processModel.idleTimeout.TotalMinutes
        Recommended     = 0
    }

    [PSCustomObject]@{
        Setting         = "Recycle Interval (minutes)"
        Current         = $ap.recycling.periodicRestart.time.TotalMinutes
        Recommended     = 0
    }

    [PSCustomObject]@{
        Setting         = "Rapid-Fail Protection"
        Current         = $ap.failure.rapidFailProtection
        Recommended     = $false
    }

    [PSCustomObject]@{
        Setting         = "Log Configuration Change"
        Current         = ($log -contains "ConfigurationChange")
        Recommended     = $true
    }

    [PSCustomObject]@{
        Setting         = "Log Manual Recycle"
        Current         = ($log -contains "Manual")
        Recommended     = $true
    }

    [PSCustomObject]@{
        Setting         = "Log Private Memory"
        Current         = ($log -contains "PrivateMemory")
        Recommended     = $true
    }

    [PSCustomObject]@{
        Setting         = "Log Request Limit"
        Current         = ($log -contains "Requests")
        Recommended     = $true
    } | Format-Table -AutoSize
}