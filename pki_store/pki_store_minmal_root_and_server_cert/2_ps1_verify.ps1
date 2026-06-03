# Version: 1.1.0
# Description: Verifies the expiration years and properties of both the Root CA and the Server Certificate in C:\temp.

Set-Location -Path "C:\temp"

Write-Host "========================================="
Write-Host " VERIFYING ROOT CA CERTIFICATE (15 YEARS) "
Write-Host "========================================="
if (Test-Path -Path "C:\temp\rootCA.crt") {
    # Extract Validity and Basic Constraints to prove it's a 15-year CA
    openssl x509 -in rootCA.crt -text -noout | Select-String -Pattern "Not Before", "Not After", "Subject:", "CA:"
} else {
    Write-Host "Error: rootCA.crt not found." -ForegroundColor Red
}

Write-Host "`n========================================="
Write-Host " VERIFYING SERVER CERTIFICATE (10 YEARS) "
Write-Host "========================================="
if (Test-Path -Path "C:\temp\server.crt") {
    # Extract Validity, EKU, and SAN properties
    openssl x509 -in server.crt -text -noout | Select-String -Pattern "Not Before", "Not After", "Subject:", "TLS Web Server", "DNS:"
} else {
    Write-Host "Error: server.crt not found." -ForegroundColor Red
}