# Version: 1.4.0
# Description: Generates a self-signed X.509 certificate (2 years expiry, Client/Server EKU) and exports both .pfx and .cer files to C:\temp.

# Ensure the target directory exists
$targetDir = "C:\temp"
if (-not (Test-Path -Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir | Out-Null
}

$pfxPath = Join-Path $targetDir "MyDualPurposeCert.pfx"
$cerPath = Join-Path $targetDir "MyDualPurposeCert.cer"
$password = ConvertTo-SecureString "Provide-ap-password" -AsPlainText -Force

$certParams = @{
    Subject = "CN=MyDualPurposeCert"
    DnsName = "MyDualPurposeCert.local"
    KeyLength = 2048
    KeyAlgorithm = "RSA"
    KeyExportPolicy = "Exportable"
    CertStoreLocation = "Cert:\LocalMachine\My"
    NotAfter = (Get-Date).AddYears(10)
    TextExtension = @(
        "2.5.29.37={text}1.3.6.1.5.5.7.3.1,1.3.6.1.5.5.7.3.2" 
    )
}

# 1. Generate the certificate in the Windows Certificate Store
$cert = New-SelfSignedCertificate @certParams

# 2. Export the PFX file (Includes Private Key)
Export-PfxCertificate -Cert $cert -FilePath $pfxPath -Password $password

# 3. Export the CER file (Public Key Only)
Export-Certificate -Cert $cert -FilePath $cerPath -Type CERT

Write-Host "Certificates generated and saved successfully."
Write-Host "PFX Location (Private + Public): $pfxPath"
Write-Host "CER Location (Public Only): $cerPath"
Write-Host "Thumbprint: $($cert.Thumbprint)"
Write-Host "Expires On: $($cert.NotAfter)"