# Version 1.0.5
# This script verifies if a URL is using Kerberos (Negotiate) or NTLM authentication by inspecting response headers and exceptions.

$url = "http://name.example.com"

try {
    # Using a new WebSession helps force a clean authentication challenge
    $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
    $response = Invoke-WebRequest -Uri $url -UseDefaultCredentials -WebSession $session -Method Get

    # Check for authentication headers in a successful response
    $authHeader = $response.Headers['WWW-Authenticate']
    if (-not $authHeader) {
        $authHeader = $response.Headers['Persistent-Auth']
    }

    Write-Host "--- Authentication Results ---"
    Write-Host "URL: $url"
    
    if ($authHeader -and $authHeader -match "Negotiate\s+(YII|oYG|oXQ)") {
        Write-Host "Result: SUCCESS (Kerberos detected)"
        Write-Host "Token Start: $($authHeader.Substring(0, 15))..."
    } 
    elseif ($authHeader -and ($authHeader -match "Negotiate\s+TlRMTV" -or $authHeader -match "NTLM")) {
        Write-Host "Result: FALLBACK (NTLM detected)"
        Write-Host "Reason: The header or token prefix indicates NTLM is being used."
    }
    elseif ($null -eq $authHeader) {
        # If the page loaded successfully but headers are stripped, look at connection flags if available
        Write-Host "Result: SUCCESS (Authenticated)"
        Write-Host "Note: Connection established successfully using default credentials."
    }
    else {
        Write-Host "Result: UNKNOWN"
        Write-Host "Header found: $authHeader"
    }

} catch {
    $exResponse = $_.Exception.Response
    if ($exResponse -and $exResponse.StatusCode -eq 401) {
        Write-Host "--- Authentication Results ---"
        Write-Host "URL: $url"
        Write-Host "Result: UNAUTHORIZED (401)"
        
        $rawChallenge = $exResponse.Headers['WWW-Authenticate']
        Write-Host "Server offered: $rawChallenge"

        # Evaluate the token offered in the 401 response
        if ($rawChallenge -match "Negotiate\s+(YII|oYG|oXQ)") {
            Write-Host "Protocol: Kerberos (Negotiate) token detected in the 401 challenge."
        }
        elseif ($rawChallenge -match "Negotiate\s+TlRMTV" -or $rawChallenge -match "NTLM") {
            Write-Host "Protocol: NTLM detected in the 401 challenge."
        }
        else {
            Write-Host "Protocol: Standard Negotiate/NTLM offering without an immediate token payload."
        }
    } else {
        Write-Host "Error: $($_.Exception.Message)"
    }
}