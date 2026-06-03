# Version: 1.7.0
# Description: Generates a 15-Year Root CA and uses it to sign a 10-Year dual-purpose Server/Client cert inside C:\temp.

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

[ alt_names ]
DNS.1 = remote-server.domain.com
DNS.2 = localhost
"@

Set-Content -Path "C:\temp\extensions.cnf" -Value $configContent

# ==========================================
# STEP 2: GENERATE THE ROOT CA (15 YEARS)
# ==========================================
Write-Host "Executing Step 2: Generating 4096-bit Root CA and 15-Year Self-Signed Certificate..."

# Generate Root Key
openssl genrsa -out "C:\temp\rootCA.key" 4096

# Create Root Certificate with a 15-year lifetime (5479 days)
openssl req -x509 -new -nodes -key "C:\temp\rootCA.key" -sha256 -days 5479 -out "C:\temp\rootCA.crt" -subj "/CN=MyInternalRootCA" -config "C:\temp\extensions.cnf" -extensions root_ca_ext

# ==========================================
# STEP 3: GENERATE SERVER KEY AND CSR
# ==========================================
Write-Host "Executing Step 3: Generating 2048-bit Server Key and Certificate Signing Request..."

# Generate Server Key
openssl genrsa -out "C:\temp\server.key" 2048

# Generate Server Request
openssl req -new -key "C:\temp\server.key" -out "C:\temp\server.csr" -subj "/CN=remote-server.domain.com"

# ==========================================
# STEP 4: SIGN THE SERVER CERTIFICATE (10 YEARS)
# ==========================================
Write-Host "Executing Step 4: Signing Server CSR with Root CA (10-Year Expiry, Dual Auth)..."

# Sign the server certificate with a 10-year lifetime (3652 days)
openssl x509 -req -in "C:\temp\server.csr" -CA "C:\temp\rootCA.crt" -CAkey "C:\temp\rootCA.key" -CAcreateserial -out "C:\temp\server.crt" -days 3652 -sha256 -extfile "C:\temp\extensions.cnf" -extensions server_client_ext

# Clean up temporary CSR file
if (Test-Path -Path "C:\temp\server.csr") {
    Remove-Item -Path "C:\temp\server.csr" -Force
}

Write-Host "Execution Complete. All resources successfully compiled into C:\temp."