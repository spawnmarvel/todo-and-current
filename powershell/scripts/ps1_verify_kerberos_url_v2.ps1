# Version 1.0.2
# This script verifies if a URL is using Kerberos (Negotiate) or NTLM authentication.

$url = "http://vmhybrid01.lab.local:8080"

try {
    # Using a new WebSession helps force a clean authentication challenge
    $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
    $response = Invoke-WebRequest -Uri $url -UseDefaultCredentials -WebSession $session -Method Get

    # Check for authentication headers in the response
    $authHeader = $response.Headers['WWW-Authenticate']
    if (-not $authHeader) {
        $authHeader = $response.Headers['Persistent-Auth']
    }

    Write-Host "--- Authentication Results ---"
    Write-Host "URL: $url"
    
    if ($authHeader -and $authHeader -match "Negotiate\s+(YII|oYG)") {
        Write-Host "Result: SUCCESS (Kerberos detected)"
        Write-Host "Token Start: $($authHeader.Substring(0, 15))..."
    } 
    elseif ($authHeader -and $authHeader -match "Negotiate\s+TlRMTV") {
        Write-Host "Result: FALLBACK (NTLM detected)"
        Write-Host "Reason: The prefix indicates NTLM is being used."
    }
    elseif ($null -eq $authHeader) {
        # If headers are empty but the page loaded, the session might be pre-authenticated
        Write-Host "Result: SUCCESS (Session persistent)"
        Write-Host "Note: No fresh auth header found, but connection was successful."
    }
    else {
        Write-Host "Result: UNKNOWN"
        Write-Host "Header found: $authHeader"
    }

} catch {
    $exResponse = $_.Exception.Response
    if ($exResponse -and $exResponse.StatusCode -eq 401) {
        Write-Host "Result: UNAUTHORIZED (401)"
        Write-Host "Server offered: $($exResponse.Headers['WWW-Authenticate'])"
    } else {
        Write-Host "Error: $($_.Exception.Message)"
    }
}