# To add specific X509v3 extensions like Extended Key Usage (EKU)
# Since you want to include these in the CSR using the openssl req command, 
# the most reliable way is to use a small configuration file (or a temporary one)

# example 
wget https://github.com/spawnmarvel/learning-docker/blob/main/prod-ish/rmq/rmq-x2-ssl/README.md

#### Alternative: The "One-Liner" Approach 

# -newkey rsa:2048 vs -newkey ec -pkeyopt ec_paramgen_curve:prime256v1
# While you can certainly use -newkey rsa:2048
# In 2025, ECC is generally preferred over RSA for new setups.

mkdir test_simple_ssl
cd test_simple_ssl

sudo nano openssl_simple_root_and_cert_generator.sh
# Paste the 1. , 2. and 3. cmd in the script
# Run it
bash /openssl_simple_root_and_cert_generator.sh

# You will end up with this after running the script
ls
rmq.cloud.com.crt  rmq.cloud.com.csr  rmq.cloud.com.key  root.crt  root.key  root.srl  root_and_cert.sh
# root.srl, This is a "serial number" file created by the -CAcreateserial flag. It keeps track of how many certificates this Root CA has signed to prevent duplicate serial numbers.
# What to do with it: You should keep it alongside root.key if you plan to sign more certificates in the future with this same Root.

# 1. This creates your certificate authority. The private key is saved as root.key and the certificate as root.crt.

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

# 4. Verify the Extended Key Usage

openssl x509 -in rmq.cloud.com.crt -noout -text | grep -E "Subject:|DNS:|Extended Key Usage" -A 1

# 4 . Verify CN

openssl x509 -noout -subject -in rmq.cloud.com.crt

# 4. Verify Date

openssl x509 -noout -in rmq.cloud.com.crt -dates

# 4. Verify serial

openssl x509 -noout -in rmq.cloud.com.crt -serial


# 5. Bundle into PFX (PKCS#12)

openssl pkcs12 -export -out rmq.cloud.com.pfx \
    -inkey rmq.cloud.com.key -in rmq.cloud.com.crt \
    -certfile root.crt \
    -name "RMQ Cloud Certificate"

# 6. Verify the PFX Content

openssl pkcs12 -info -in rmq.cloud.com.pfx -noout


# 7 Generate a New Key and CSR
# Even if the old certificate is expired, you can't "extend" it. You must create a new request. Use a new filename (e.g., rmq.cloud.com_2026) to keep your folder organized.

# Step 1: Generate a New Key and CSR

openssl req -new -nodes -sha256 \
    -newkey ec -pkeyopt ec_paramgen_curve:prime256v1 \
    -keyout rmq.cloud.com_2026.key -out rmq.cloud.com_new.csr \
    -subj "/C=US/ST=WA/O=Contoso/CN=rmq.cloud.com"

# Step 2: Sign the New Request with the Root CA
# Use your existing root.crt and root.key to sign the new CSR. This will issue a fresh certificate for another 365 days
# Note: We use -CAserial root.srl instead of -CAcreateserial because the serial file already exists from your first run.

openssl x509 -req -in rmq.cloud.com_new.csr \
    -CA root.crt -CAkey root.key -CAserial root.srl \
    -out rmq.cloud.com_2026.crt -days 365 -sha256 \
    -extfile <(printf "extendedKeyUsage = serverAuth, clientAuth, codeSigning, emailProtection\nsubjectAltName = DNS:rmq.cloud.com")







