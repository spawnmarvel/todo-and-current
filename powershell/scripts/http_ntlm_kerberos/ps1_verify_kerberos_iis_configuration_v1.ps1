# Version 1.0.7
# This script inspects the local IIS configuration for a specific nested application path to verify if useAppPoolCredentials is True.

Import-Module WebAdministration

$SiteName = "Default Web Site"
$AppName = "ProcessData"
$CombinedPath = "$SiteName/$AppName"

try {
    # Querying configuration targeting the nested application location
    $Prop = Get-WebConfigurationProperty -Filter "system.webServer/security/authentication/windowsAuthentication" -Name "useAppPoolCredentials" -PSPath "IIS:\" -Location $CombinedPath
    
    Write-Host "--- IIS Kerberos Configuration Check ---"
    Write-Host "Target Path: $CombinedPath"
    
    if ($Prop -and $Prop.Value -eq $true) {
        Write-Host "Result: SUCCESS (useAppPoolCredentials is enabled)"
    } else {
        Write-Host "Result: MISCONFIGURATION DETECTED"
        Write-Host "Reason: useAppPoolCredentials is set to False (or inherited as False) for $AppName. This will break Kerberos behind a Load Balancer."
    }
} catch {
    Write-Host "Error accessing IIS Configuration: $($_.Exception.Message)"
}