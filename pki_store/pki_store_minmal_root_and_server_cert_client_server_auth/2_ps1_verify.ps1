# Version: 1.1.0
# Description: Verifies the expiration years and properties of both the Root CA and the Server Certificate in C:\temp.

# Extract Validity and Basic Constraints to prove it's a 15-year CA
openssl x509 -in C:\temp\rootCA.crt -noout -subject -dates


# Extract Validity, EKU, and SAN properties
openssl x509 -in C:\temp\server.crt -noout -subject -dates -purpose


