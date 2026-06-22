$url = "https://vhuebguiubuib/DataREST.dll/" # Replace with your URL

try {
    # 1. First, we clear any existing session to ensure a fresh auth handshake
    $response = Invoke-WebRequest -Uri $url -UseDefaultCredentials -Method Get

    # 2. Check the "WWW-Authenticate" or "Persistent-Auth" headers
    # Note: In a successful 200 OK, the server often sends back a 'Set-Cookie' 
    # or 'Persistent-Auth' header containing the confirmation token.
    
    $authHeader = $response.Headers['WWW-Authenticate']
    if (-not $authHeader) {
        $authHeader = $response.Headers['Persistent-Auth']
    }

    Write-Host "--- Authentication Results ---" -ForegroundColor Cyan
    Write-Host "URL: $url"
    
    if ($authHeader -match "Negotiate\s+(YII|oYG)") {
        Write-Host "Result: SUCCESS (Kerberos detected)" -ForegroundColor Green
        Write-Host "Token Start: $($authHeader.Substring(0, 15))..."
    } 
    elseif ($authHeader -match "Negotiate\s+TlRMTV") {
        Write-Host "Result: FALLBACK (NTLM detected)" -ForegroundColor Yellow
        Write-Host "Reason: The 'TlRMTV' prefix indicates NTLM is being used instead of Kerberos."
    }
    else {
        Write-Host "Result: UNKNOWN" -ForegroundColor Red
        Write-Host "Header found: $authHeader"
    }

} catch {
    if ($_.Exception.Response.StatusCode -eq 401) {
        Write-Host "Result: UNAUTHORIZED (401)" -ForegroundColor Red
        Write-Host "The server offered: $($_.Exception.Response.Headers['WWW-Authenticate'])"
    } else {
        Write-Error $_.Exception.Message
    }
}

# example output
# URL: https://vhuebguiubuib/DataREST.dll/
# Result: SUCCESS (Kerberos detected)
# Token Start: Negotiate oYG1M...