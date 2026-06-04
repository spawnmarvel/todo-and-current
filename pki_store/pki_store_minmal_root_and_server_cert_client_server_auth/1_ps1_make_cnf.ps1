# Version: 1.7.0
# Description: Generates a 15-Year Root CA and uses it to sign a 10-Year dual-purpose Server/Client cert inside C:\temp.


#### NOTE!! Run this with powershell

# Ensure the target directory exists
$targetDir = "C:\temp"
if (-not (Test-Path -Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir | Out-Null
}

# Change directory context to target path
Set-Location -Path $targetDir

# ==========================================
# STEP 1: CREATE THE CONFIGURATION FILE
# ==========================================
Write-Host "Executing Step 1: Creating configuration file at C:\temp\extensions.cnf..."

$configContent = @"
[ req ]
default_bits        = 2048
distinguished_name  = req_distinguished_name
string_mask         = utf8only

[ req_distinguished_name ]
# Empty section allows -subj parameter values to override completely without errors

[ root_ca_ext ]
basicConstraints = critical, CA:TRUE
keyUsage = critical, digitalSignature, cRLSign, keyCertSign
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer

[ server_client_ext ]
basicConstraints = critical, CA:FALSE
keyUsage = critical, digitalSignature, keyEncipherment
extendedKeyUsage = critical, serverAuth, clientAuth
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
subjectAltName = @alt_names

# You must change this DNS to your actual DNS name or IP address for the server certificate to be valid for that name when used in browsers or other clients. 
# For testing purposes, you can use a placeholder, but it should match the CN or be included as a SAN for proper validation.
[ alt_names ]
DNS.1 = name.domain.no
"@

Set-Content -Path "C:\temp\extensions.cnf" -Value $configContent


