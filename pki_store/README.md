# SSL certificates change 2026


Let's Encrypt certificates will no longer be usable for client authentication starting 13 May 2026

You really should never do Mutual TLS with a public signed client certificate to begin with.

With your VPN scenario, if you were trusting the Let's Encrypt CA for VPN client authentication. It would mean any client cert signed from Let’s Encrypt could authenticate to your VPN/Device. (Like you mentioned, you lose control of your domain, someone could impersonate your device.  However, any cert would be authenticated if signed by the same Certificate Authority.

* If you were statically trusting the individual Let’s Encrypt certificates in you possession (e.g. only allow a specific CN), you could do the same with self-signed certificates without the risk of other CA signed certificates. 


* https://www.reddit.com/r/selfhosted/comments/1mt9ovs/lets_encrypt_certificates_will_no_longer_be/

Decreasing Certificate Lifetimes to 45 Days

* https://letsencrypt.org/2025/12/02/from-90-to-45.html

## Windows PKI store

* Set up a store
* One root certificates with signing properties, 15 years life
* Two certificates with server and client auth properties, 1 year life
* Renewal with database text file
* Test 

Copy from

https://github.com/spawnmarvel/quickguides/tree/main/securityPKI-CA


## Certificate Auth

```cmd

:: Create Root folders
mkdir C:\CertificateAuth\private
mkdir C:\CertificateAuth\certs
mkdir C:\CertificateAuth\certs_new
type nul > C:\CertificateAuth\index.txt
echo 1000 > C:\CertificateAuth\serial

:: Create Intermediate folders
mkdir C:\CertificateAuth\intermediate
mkdir C:\CertificateAuth\intermediate\private
mkdir C:\CertificateAuth\intermediate\certs
type nul > C:\CertificateAuth\intermediate\index.txt
echo 1000 > C:\CertificateAuth\intermediate\serial

```

Folder Definitions

* C:\CertificateAuth\: The root directory containing your master Root CA configuration, database, and serial tracking.
* C:\CertificateAuth\private\: The highly sensitive directory storing the Root CA's private key; access should be strictly limited.
* C:\CertificateAuth\certs\: A manual storage folder for organizing signed certificates or public CA certificates.
* C:\CertificateAuth\certs_new\: The automated archive where OpenSSL saves a copy of every certificate issued by the Root CA, named by serial number.
* C:\CertificateAuth\intermediate\: The workspace containing the Intermediate CA’s unique private key, database, and issued certificates.
* C:\CertificateAuth\intermediate\private\: The directory storing the Intermediate CA's private key, used for signing servers and clients.
* C:\CertificateAuth\intermediate\certs\: The operational directory where the Intermediate CA archives certificates it has signed.

File Definitions

* openssl.cnf: The master configuration file defining how the Root and Intermediate CAs behave, including policies and certificate extensions.
* index.txt: The "database" file that tracks the status (valid/revoked) of every certificate issued by that specific CA.
* serial: A text file containing the next unique hexadecimal number to be assigned to the next certificate issued by that CA.
* ca_private_key.pem: The Root CA's private key used to sign the Intermediate CA.
* ca_certificate.pem: The public Root CA certificate, which acts as the trust anchor for all devices.
* intermediate.key.pem: The Intermediate CA’s private key used for day-to-day signing operations.
* intermediate.cert.pem: The public certificate of the Intermediate CA, which bridges the gap between the server and the Root.

## Root certificate

Run openssl (cmd) and create root certificate

```cmd

c:\Program Files\OpenSSL-Win64-3\OpenSSL-Win64\bin>openssl version
OpenSSL 3.1.2 1 Aug 2023 (Library: OpenSSL 3.1.2 1 Aug 2023)

openssl req -x509 -config C:\CertificateAuth\openssl.cnf -newkey rsa:4048 -nodes -keyout C:\CertificateAuth\private\ca_private_key.pem -out C:\CertificateAuth\ca_certificate.pem -extensions root_ca_extensions -days 5479 -subj "/CN=Socrates Root CA/O=SOCRATES INC/C=NO"

```
Press enter to keep the common name from the openssl.cnf

After running this, it is good practice to confirm the expiry date and the "CA:TRUE" status:

```cmd
openssl x509 -in C:\CertificateAuth\ca_certificate.pem -noout -dates -ext basicConstraints

```

```log
notBefore=Mar  7 14:41:23 2026 GMT
notAfter=Mar  7 14:41:23 2041 GMT
X509v3 Basic Constraints: critical
    CA:TRUE

```

Your Root CA is officially active and correctly configured. The output you provided shows that the Basic Constraints are set to critical, CA:TRUE and the Key Usage is limited to Certificate Sign, CRL Sign.

This is the perfect foundation for a Private PKI. Because the Basic Constraints are marked as critical, any compliant software (like a web server or browser) will know that this certificate is only allowed to act as a Certificate Authority and nothing else.

You now have a "Master Key" (your C:\CertificateAuth\private\ca_private_key.pem) that can authorize any other certificate you generate for your servers or clients.

One vital note: Never share your ca_private_key.pem. The .cer file you just created is safe to distribute to any machine that needs to trust your new CA, but the private key must stay locked in your private folder.

And the C:\tCertificateAuth\ca_certificate.pem for root certificate

Make a .cer file also

```cmd
openssl x509 -in C:\CertificateAuth\ca_certificate.pem -outform DER -out C:\CertificateAuth\ca_certificate.cer
```

To make it valid, import it in cert trusted root certificates.

![root](https://github.com/spawnmarvel/todo-and-current/blob/main/pki_store/images/root.png)

## Intermediate certificate

Next Step: Since your Root is now ready, the next logical step is to generate the Intermediate CA Private Key and CSR.

Remember, the Intermediate CA is your "signing agent"—it is what you will use daily to issue certificates for your RabbitMQ servers and clients, keeping the Root key safely offline.

1. Generate the Intermediate Private Key

```cmd

openssl genrsa -out C:\CertificateAuth\intermediate\private\intermediate.key.pem 4096
```

2. Generate the Intermediate CSR

This creates the "Certificate Signing Request." You are essentially asking your Root CA to "vouch" for this Intermediate CA.

This creates the request using the key you just generated, ensuring your identity is baked into the request.


```cmd
openssl req -new -key C:\CertificateAuth\intermediate\private\intermediate.key.pem -out C:\CertificateAuth\intermediate\intermediate.csr -config C:\CertificateAuth\openssl.cnf -subj "/CN=Socrates Intermediate CA/O=SOCRATES INC/C=US"
  
```

3. Sign the Intermediate CSR with the Root CA

This is the moment the Root CA signs the Intermediate's request, granting it the power to sign other certificates.


```cmd
openssl ca -config C:\CertificateAuth\openssl.cnf -name socratesca -extensions intermediate_extensions -days 2920 -in C:\CertificateAuth\intermediate\intermediate.csr -out C:\CertificateAuth\intermediate\intermediate.cert.pem -batch

```

Log

```log
Using configuration from C:\CertificateAuth\openssl.cnf
Check that the request matches the signature
Signature ok
The Subject's Distinguished Name is as follows
commonName            :ASN.1 12:'Socrates Intermediate CA'
organizationName      :ASN.1 12:'SOCRATES INC'
countryName           :PRINTABLE:'US'
Certificate is to be certified until Mar  5 14:58:27 2034 GMT (2920 days)

Write out database with 1 new entries
Data Base Updated
```

Make a .cer file also

```cmd
openssl x509 -in C:\CertificateAuth\intermediate\intermediate.cert.pem -outform DER -out C:\CertificateAuth\intermediate\intermediate.cert.cer
```

To make it valid, import it in cert trusted root certificates.

![intermediate](https://github.com/spawnmarvel/todo-and-current/blob/main/pki_store/images/intermediate.png)


After running this, it is good practice to confirm the expiry date and the "CA:TRUE" status:

```cmd
openssl x509 -in C:\CertificateAuth\intermediate\intermediate.cert.pem -noout -dates -ext basicConstraints

```

Log


```log
notBefore=Mar  7 14:58:27 2026 GMT
notAfter=Mar  5 14:58:27 2034 GMT
X509v3 Basic Constraints: critical
    CA:TRUE, pathlen:0

```

## Server certificate

Run this command in your cmd window. This generates a new 2048-bit key and a request file that contains the server's identity information.

1. Generate Server Private Key and CSR

```cmd
openssl req -new -newkey rsa:2048 -nodes -keyout C:\CertificateAuth\intermediate\certs\server.key.pem -out C:\CertificateAuth\intermediate\certs\server.csr -config C:\CertificateAuth\openssl.cnf -subj "/CN=AMQP-IT1/O=SOCRATES INC/C=US"
```

Note: You will be prompted for DN information (Common Name, etc.), if you leave the -subject out. Ensure the Common Name matches the server's hostname or IP address that clients will use to connect.

In the context of RabbitMQ mTLS, the Common Name (CN) in the certificate is primarily used by RabbitMQ for user authentication/mapping (if configured via rabbitmq.conf with ssl_cert_login_from = common_name), rather than strictly for hostname verification like in a standard HTTPS/Web Server setup.

Because you are using this for RabbitMQ, you can name the CN whatever you like, as long as it matches the username defined in your RabbitMQ internal database (or the identity the server expects to see).

Lets continue with server cert.

That command successfully generated your Private Key and your Certificate Signing Request (CSR).

Since you did not provide a -subj flag, OpenSSL likely paused and asked you a series of questions. Because of your openssl.cnf defaults, you should have just been able to press Enter through most of them, making sure the Common Name (CN) was set correctly for your RabbitMQ node.

2. Sign the Server CSR with the Intermediate CA

Now, use the Intermediate CA to sign the request. This uses the intermediate_ca configuration section to validate the request and store the result in your intermediate\certs folder.

```cmd
openssl ca -config C:\CertificateAuth\openssl.cnf -name intermediate_ca -extensions mtls_extensions -days 365 -in C:\CertificateAuth\intermediate\certs\server.csr -out C:\CertificateAuth\intermediate\certs\server.crt -batch
```
log

```log
Using configuration from C:\CertificateAuth\openssl.cnf
Check that the request matches the signature
Signature ok
The Subject's Distinguished Name is as follows
commonName            :ASN.1 12:'AMQP-IT1'
organizationName      :ASN.1 12:'SOCRATES INC'
countryName           :PRINTABLE:'US'
Certificate is to be certified until Mar  7 15:10:09 2027 GMT (365 days)

Write out database with 1 new entries
Data Base Updated

```

Make the chain

```cmd
copy /b C:\CertificateAuth\intermediate\intermediate.cert.pem + C:\CertificateAuth\ca_certificate.pem C:\CertificateAuth\ca-chain.cert.pem

```

You can verify the identity and the trust chain of your new server certificate with this command:

```cmd
openssl verify -CAfile C:\CertificateAuth\ca-chain.cert.pem C:\CertificateAuth\intermediate\certs\server.crt
```
Log

```log
C:\CertificateAuth\intermediate\certs\server.crt: OK
```

convert to pem also

```cmd
copy C:\CertificateAuth\intermediate\certs\server.crt C:\CertificateAuth\intermediate\certs\server.pem
```
After running these, your server files are located here:

* Private Key: C:\CertificateAuth\intermediate\certs\server.key.pem
* Signed Certificate: C:\CertificateAuth\intermediate\certs\server.crt and server.pem
* Chain/CA File: C:\CertificateAuth\ca-chain.cert.pem (Created by combining the Intermediate and Root certificates)


![server](https://github.com/spawnmarvel/todo-and-current/blob/main/pki_store/images/server.png)


## Client certificate (same)

The process for a Client Certificate is structurally identical to the server one, with one key logical difference: the Common Name (CN).

1. Generate Server Private Key and CSR

```cmd
openssl req -new -newkey rsa:2048 -nodes -keyout C:\CertificateAuth\intermediate\certs\amqp-it2.key_2.pem -out C:\CertificateAuth\intermediate\certs\amqp-it2_2.csr -config C:\CertificateAuth\openssl.cnf -subj "/CN=AMQP-IT2/O=SOCRATES INC/C=US"
```

2. Sign the Server CSR with the Intermediate CA

Now, use the Intermediate CA to sign the request. This uses the intermediate_ca configuration section to validate the request and store the result in your intermediate\certs folder.

```cmd
openssl ca -config C:\CertificateAuth\openssl.cnf -name intermediate_ca -extensions mtls_extensions -days 365 -in C:\CertificateAuth\intermediate\certs\amqp-it2.csr -out C:\CertificateAuth\intermediate\certs\amqp-it2.crt -batch
```

log

```log
Using configuration from C:\CertificateAuth\openssl.cnf
Check that the request matches the signature
Signature ok
The Subject's Distinguished Name is as follows
commonName            :ASN.1 12:'AMQP-IT2'
organizationName      :ASN.1 12:'SOCRATES INC'
countryName           :PRINTABLE:'US'
Certificate is to be certified until Mar  7 15:21:26 2027 GMT (365 days)

Write out database with 1 new entries
Data Base Updated
```

Make the chain

```cmd
copy /b C:\CertificateAuth\intermediate\intermediate.cert.pem + C:\CertificateAuth\ca_certificate.pem C:\CertificateAuth\ca-chain.cert.pem

```

You can verify the identity and the trust chain of your new server certificate with this command:

```cmd
openssl verify -CAfile C:\CertificateAuth\ca-chain.cert.pem C:\CertificateAuth\intermediate\certs\amqp-it2.crt
```
Log

```log
C:\CertificateAuth\intermediate\certs\amqp-it2.crt: OK
```

convert to pem also

```cmd
copy C:\CertificateAuth\intermediate\certs\amqp-it2.crt C:\CertificateAuth\intermediate\certs\amqp-it2.pem
```
After running these, your server files are located here:

* Private Key: C:\CertificateAuth\intermediate\certs\amqp-it2.key.pem
* Signed Certificate: C:\CertificateAuth\intermediate\certs\amqp-it2.crt and amqp-it2.pem
* Chain/CA File: C:\CertificateAuth\ca-chain.cert.pem (Created by combining the Intermediate and Root certificates)


![server 2](https://github.com/spawnmarvel/todo-and-current/blob/main/pki_store/images/server2.png)

## Renew server certificate

In a production environment, the goal is always zero-downtime rotation. To do this, you follow a "Overlap" strategy. You don't revoke the old certificate until the new one is deployed and tested.

Even if you keep the same Common Name (AMQP-IT2), it is best practice to generate a fresh private key for every renewal cycle.

Run your command to generate the new key pair and the corresponding CSR:

```cmd
openssl req -new -newkey rsa:2048 -nodes -keyout C:\CertificateAuth\intermediate\certs\amqp-it2.key_2.pem -out C:\CertificateAuth\intermediate\certs\amqp-it2_2.csr -config C:\CertificateAuth\openssl.cnf -subj "/CN=AMQP-IT2/O=SOCRATES INC/C=US"

```

Sign that CSR using your Intermediate CA:

```cmd
openssl ca -config C:\CertificateAuth\openssl.cnf -name intermediate_ca -extensions mtls_extensions -days 365 -in C:\CertificateAuth\intermediate\certs\amqp-it2_2.csr -out C:\CertificateAuth\intermediate\certs\amqp-it2_2.crt -batch
```

log

```log
Using configuration from C:\CertificateAuth\openssl.cnf
Check that the request matches the signature
Signature ok
The Subject's Distinguished Name is as follows
commonName            :ASN.1 12:'AMQP-IT2'
organizationName      :ASN.1 12:'SOCRATES INC'
countryName           :PRINTABLE:'US'
ERROR:There is already a certificate for /CN=AMQP-IT2/C=US/O=SOCRATES INC
The matching entry has the following details
Type          :Valid
Expires on    :270307152126Z
Serial Number :1001
File name     :unknown
Subject Name  :/CN=AMQP-IT2/C=US/O=SOCRATES INC

```
How to resolve this
You have two primary ways to move forward:

Option 1: Revoke the old certificate (The "Correct" way)

Revoking a certificate in your index.txt database does not physically stop the software currently using that certificate.

```cmd
openssl ca -config C:\CertificateAuth\openssl.cnf -name intermediate_ca -revoke C:\CertificateAuth\intermediate\certs\amqp-it2.crt
```

log

```log
Using configuration from C:\CertificateAuth\openssl.cnf
Revoking Certificate 1001.
Data Base Updated
```

Proceed with Signing the New CSR
Now that the database is updated, you can proceed to sign your new amqp-it2_2.csr without receiving that "already exists" error:

```cmd
openssl ca -config C:\CertificateAuth\openssl.cnf -name intermediate_ca -extensions mtls_extensions -days 365 -in C:\CertificateAuth\intermediate\certs\amqp-it2_2.csr -out C:\CertificateAuth\intermediate\certs\amqp-it2_2.crt -batch

```

Log

```log
Using configuration from C:\CertificateAuth\openssl.cnf
Check that the request matches the signature
Signature ok
The Subject's Distinguished Name is as follows
commonName            :ASN.1 12:'AMQP-IT2'
organizationName      :ASN.1 12:'SOCRATES INC'
countryName           :PRINTABLE:'US'
Certificate is to be certified until Mar  7 15:47:08 2027 GMT (365 days)

Write out database with 1 new entries
Data Base Updated

```

![server 2 renew](https://github.com/spawnmarvel/todo-and-current/blob/main/pki_store/images/renew.png)

Chain

![server 2 renew cert](https://github.com/spawnmarvel/todo-and-current/blob/main/pki_store/images/renewed_cert.png)



Next Administrative Step: Update the CRL
Since you have revoked a certificate, it is best practice to regenerate your Certificate Revocation List (CRL). This is a file that informs any clients checking for revocations that the old amqp-it2 certificate is no longer trustworthy.

But, If no clients or applications are configured to check for certificate revocation, the CRL is essentially dead weight.

But this is how you genrate it:

```cmd
openssl ca -config C:\CertificateAuth\openssl.cnf -name intermediate_ca -gencrl -out C:\CertificateAuth\intermediate\crl.pem

```

The reality of your setup:

Since you are the administrator and operator of this private CA, you have absolute control over the entire lifecycle. If you suspect a certificate is compromised, you can simply remove it from your trust store or update the server configuration to point to a new key/cert pair.


