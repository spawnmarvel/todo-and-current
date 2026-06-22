$alias = "varlimo.api.domain.com"
$port = 443

# We use the TcpClient to open the socket
$tcpClient = New-Object System.Net.Sockets.TcpClient($alias, $port)
$stream = $tcpClient.GetStream()

# The SslStream needs the target host (the alias) to handle SNI correctly
$sslStream = New-Object System.Net.Security.SslStream($stream, $false, { $true })

try {
    # This initiates the handshake using the alias
    $sslStream.AuthenticateAsClient($alias)
    
    $cert = [System.Security.Cryptography.X509Certificates.X509Certificate2]$sslStream.RemoteCertificate
    
    # Now we output the properties to the console
    Write-Host "--- Certificate Details for: $alias ---" -ForegroundColor Cyan
    Write-Host "Subject: $($cert.Subject)"
    Write-Host "Issuer:  $($cert.Issuer)"
    Write-Host "Expires: $($cert.NotAfter)"
    Write-Host "Thumbprint: $($cert.Thumbprint)"
}
catch {
    Write-Error "Could not connect to $alias : $_"
}
finally {
    $sslStream.Dispose()
    $tcpClient.Dispose()
}