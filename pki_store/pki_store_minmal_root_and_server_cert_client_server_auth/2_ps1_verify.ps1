# Version: 1.1.0
# Description: Verifies the expiration years and properties of both the Root CA and the Server Certificate in C:\temp.

# Extract Validity and Basic Constraints to prove it's a 15-year CA
openssl x509 -in C:\temp\rootCA.crt -noout -subject -dates


# Extract Validity, EKU, and SAN properties
openssl x509 -in C:\temp\server.crt -noout -subject -dates -purpose


# Server Asset Verification One-Liner
openssl x509 -noout -modulus -in C:\temp\server.crt | openssl sha256 && openssl rsa -noout -modulus -in C:\temp\server.key | openssl sha256

# (stdin)= 6d6ab7e5d5d2ff8c6b0bd5ca28baea5eadb294584f0beeeb9b53a2c45d085a50
# (stdin)= 6d6ab7e5d5d2ff8c6b0bd5ca28baea5eadb294584f0beeeb9b53a2c45d085a50

# Line 1: The fingerprint of your server certificate's public key component.
# Line 2: The fingerprint of your private key's modulus.
# If the two alpha-numeric strings match exactly, your key pair matches.