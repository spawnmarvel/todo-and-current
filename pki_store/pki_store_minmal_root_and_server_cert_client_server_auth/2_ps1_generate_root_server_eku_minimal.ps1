# Version: 1.7.0
# Description: Generates a 15-Year Root CA and uses it to sign a 10-Year dual-purpose Server/Client cert inside C:\temp.


#### NOTE!! Run this with CMD AS ADMININSTRATOR and navigate to where you have openssl installed, then run the following command to execute the script:
#### NOTE!! In my case it is:
c:\Program Files\OpenSSL-Win64\bin>openssl version
# OpenSSL 1.1.1m  14 Dec 2021

# ==========================================
# STEP 2: GENERATE THE ROOT CA (15 YEARS)
# ==========================================

# Generate Root Key
openssl genrsa -out "C:\temp\rootCA.key" 4096

# Create Root Certificate with a 15-year lifetime (5479 days)
openssl req -x509 -new -nodes -key "C:\temp\rootCA.key" -sha256 -days 5479 -out "C:\temp\rootCA.crt" -subj "/CN=InternalRootCA" -config "C:\temp\extensions.cnf" -extensions root_ca_ext

# ==========================================
# STEP 3: GENERATE SERVER KEY AND CSR
# ==========================================

# Generate Server Key
openssl genrsa -out "C:\temp\server.key" 2048

# Generate Server Request
openssl req -new -key "C:\temp\server.key" -out "C:\temp\server.csr" -subj "/CN=name.domain.no"

# ==========================================
# STEP 4: SIGN THE SERVER CERTIFICATE (10 YEARS)
# ==========================================

# Sign the server certificate with a 10-year lifetime (3652 days)
openssl x509 -req -in "C:\temp\server.csr" -CA "C:\temp\rootCA.crt" -CAkey "C:\temp\rootCA.key" -CAcreateserial -out "C:\temp\server.crt" -days 3652 -sha256 -extfile "C:\temp\extensions.cnf" -extensions server_client_ext


# ==========================================
# STEP 5: TEST CERTIFICATE
# ==========================================

# Rabbitmq uses pem format for certificates, so you may need to convert the server certificate and key to pem format if they are not already in that format.
# After you have added the root certificate to the Trusted Root Certification Authorities store at the server, you can test the server certificate with the following command:
# This assumes you have a client certificate with the same EKU (Client Authentication) and that you have added the root certificate to the Trusted Root Certification Authorities store at the client as well.
openssl s_client -connect your-broker-host:5671 -key C:\path\to\client.key.pem -cert C:\path\to\client.cert.pem -CAfile C:\path\to\cacert.pem -state

# output should show "Verify return code: 0 (ok)" if the certificate is valid and trusted.
# This is a test a to a live remote broker, it will not impact the shovel that are already running, but it will show you if the certificate is valid and trusted by the client and server.
# At server end you will see in the logs a messages handsshake timeout, handshake
# This is because the openssl s_client command does not complete the handshake, it just tests the certificate and then closes the connection.

