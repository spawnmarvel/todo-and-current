#!/bin/bash
# 1. This creates your certificate authority. The private key is saved as root.key and the certificate as root.cr
openssl req -x509 -new -nodes -sha256 -days 3652 \
    -newkey ec -pkeyopt ec_paramgen_curve:prime256v1 \
    -keyout root.key -out root.crt \
    -subj "/CN=SocratesIncRoot" \
    -addext "basicConstraints = critical, CA:TRUE" \
    -addext "keyUsage = critical, keyCertSign, cRLSign"

# 2. Create the Leaf Private Key & CSR, This generates the key for your service and the signing request for rmq.cloud.com.
openssl req -new -nodes -sha256 \
    -newkey ec -pkeyopt ec_paramgen_curve:prime256v1 \
    -keyout rmq.cloud.com.key -out rmq.cloud.com.csr \
    -subj "/C=US/ST=WA/O=Contoso/CN=rmq.cloud.com"


# 3. Sign the Leaf Certificate, This step links your request to your root. 
# It applies the four Extended Key Usages and the mandatory Subject Alternative Name (SAN).
openssl x509 -req -in rmq.cloud.com.csr \
    -CA root.crt -CAkey root.key -CAcreateserial \
    -out rmq.cloud.com.crt -days 365 -sha256 \
    -extfile <(printf "extendedKeyUsage = serverAuth, clientAuth, codeSigning, emailProtection\nsubjectAltName = DNS:rmq.cloud.com")