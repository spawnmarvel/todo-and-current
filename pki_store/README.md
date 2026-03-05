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

mkdir c:\testCertificateAuth
mkdir c:\testCertificateAuth\server
mkdir c:\testCertificateAuth\certs
mkdir c:\testCertificateAuth\private

type NUL > c:\testCertificateAuth\index.txt
echo 1000 > c:\testCertificateAuth\serial
```

Make the openssl.cnf and paste the content in it

## Root certificate

Run openssl (cmd) and create root certificate

```cmd

c:\Program Files\OpenSSL-Win64-3\OpenSSL-Win64\bin>openssl version
OpenSSL 3.1.2 1 Aug 2023 (Library: OpenSSL 3.1.2 1 Aug 2023)

openssl req -x509 -config C:\testCertificateAuth\openssl.cnf -newkey rsa:4048 -nodes -keyout C:\testCertificateAuth\private\ca_private_key.pem -out C:\testCertificateAuth\ca_certificate.pem -extensions root_ca_extensions -days 3652

```
Press enter to keep the common name from the openssl.cnf

Check that we have all extension

```cmd
openssl x509 -in C:\testCertificateAuth\ca_certificate.pem -noout -text
```

```log


Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            58:4b:d2:ed:77:1c:9d:79:19:b7:ba:4b:bc:5e:4d:4d:67:4a:15:b2
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: CN = SOCRATES.INC, ST = HO, C = NO
        Validity
            Not Before: Mar  5 20:47:04 2026 GMT
            Not After : Mar  4 20:47:04 2036 GMT
        Subject: CN = SOCRATES.INC, ST = HO, C = NO
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (4048 bit)

 X509v3 extensions:
            X509v3 Basic Constraints: critical
                CA:TRUE
            X509v3 Key Usage: critical
                Certificate Sign, CRL Sign

```

Your Root CA is officially active and correctly configured. The output you provided shows that the Basic Constraints are set to critical, CA:TRUE and the Key Usage is limited to Certificate Sign, CRL Sign.

This is the perfect foundation for a Private PKI. Because the Basic Constraints are marked as critical, any compliant software (like a web server or browser) will know that this certificate is only allowed to act as a Certificate Authority and nothing else.

You now have a "Master Key" (your C:\testCertificateAuth\private\ca_private_key.pem) that can authorize any other certificate you generate for your servers or clients.

One vital note: Never share your ca_private_key.pem. The .cer file you just created is safe to distribute to any machine that needs to trust your new CA, but the private key must stay locked in your private folder.

And the C:\testCertificateAuth\ca_certificate.pem for root certificate

Make a .cer file also

```cmd
openssl x509 -in C:\testCertificateAuth\ca_certificate.pem -outform DER -out C:\testCertificateAuth\ca_certificate.cer
```

To make it valid, import it in cert trusted root certificates.

![root](https://github.com/spawnmarvel/todo-and-current/blob/main/pki_store/images/root.png)


## Server certificate

Run this command in your cmd window. This generates a new 2048-bit key and a request file that contains the server's identity information.

```cmd
openssl req -new -config C:\testCertificateAuth\openssl.cnf -newkey rsa:2048 -nodes -keyout C:\testCertificateAuth\server\server_amqp.key -out C:\testCertificateAuth\server\server_amqp.csr -subj "/CN=MY_RABBIT_SERVER"
```

Note: You will be prompted for DN information (Common Name, etc.), if you leave the -subject out. Ensure the Common Name matches the server's hostname or IP address that clients will use to connect.

In the context of RabbitMQ mTLS, the Common Name (CN) in the certificate is primarily used by RabbitMQ for user authentication/mapping (if configured via rabbitmq.conf with ssl_cert_login_from = common_name), rather than strictly for hostname verification like in a standard HTTPS/Web Server setup.

Because you are using this for RabbitMQ, you can name the CN whatever you like, as long as it matches the username defined in your RabbitMQ internal database (or the identity the server expects to see).

Lets continue with server cert.

That command successfully generated your Private Key and your Certificate Signing Request (CSR).

Since you did not provide a -subj flag, OpenSSL likely paused and asked you a series of questions. Because of your openssl.cnf defaults, you should have just been able to press Enter through most of them, making sure the Common Name (CN) was set correctly for your RabbitMQ node.

What you should have now:

1. C:\testCertificateAuth\server\server_amqp.key: This is your server's secret identity. Keep this file protected; if it is compromised, someone could impersonate your RabbitMQ server.

2. C:\testCertificateAuth\server\server_amqp.csr: This is the "request" that you now need to hand over to your Root CA to be signed.

The Final Step: Signing the Request

```cmd
openssl ca -config C:\testCertificateAuth\openssl.cnf -days 730 -in C:\testCertificateAuth\server\server_amqp.csr -out C:\testCertificateAuth\server\server_amqp.crt

```

What to watch for:
1. OpenSSL will display the details of your request.

2. It will ask: Sign the certificate? [y/n]. Type y.

3. It will ask: 1 out of 1 certificate requests certified, commit? [y/n]. Type y.

Log
```log
Using configuration from C:\testCertificateAuth\openssl.cnf
Check that the request matches the signature
Signature ok
The Subject's Distinguished Name is as follows
commonName            :ASN.1 12:'MY_RABBIT_SERVER'
Certificate is to be certified until Mar  4 21:13:37 2028 GMT (730 days)
Sign the certificate? [y/n]:y


1 out of 1 certificate requests certified, commit? [y/n]y
Write out database with 1 new entries
Database updated
```

One last verification

After that command finishes, you can check that the certificate was signed by your Root CA by running:

```cmd
openssl verify -CAfile C:\testCertificateAuth\ca_certificate.pem C:\testCertificateAuth\server\server_amqp.crt
```

If it returns C:\testCertificateAuth\server\server_amqp.crt: OK, your server certificate is successfully chained to your root!

```cmd
openssl x509 -in C:\testCertificateAuth\server\server_amqp.crt -noout -dates
openssl x509 -in C:\testCertificateAuth\server\server_amqp.crt -noout -ext extendedKeyUsage
```

Log

```log
-ext extendedKeyUsage
X509v3 Extended Key Usage:
    TLS Web Server Authentication, TLS Web Client Authentication
```

![server](https://github.com/spawnmarvel/todo-and-current/blob/main/pki_store/images/server.png)


## Client certificate (same)

The process for a Client Certificate is structurally identical to the server one, with one key logical difference: the Common Name (CN).


## Renew server certificate

In a production environment, the goal is always zero-downtime rotation. To do this, you follow a "Overlap" strategy. You don't revoke the old certificate until the new one is deployed and tested.

Even if you keep the same Common Name (MY_RABBIT_SERVER), it is best practice to generate a fresh private key for every renewal cycle.

```cmd
openssl req -new -config C:\testCertificateAuth\openssl.cnf -newkey rsa:2048 -nodes -keyout C:\testCertificateAuth\server\server_amqp_new.key -out C:\testCertificateAuth\server\server_amqp_new.csr -subj "/CN=MY_RABBIT_SERVER"

```

Sign the "New" CSR

Sign it with your CA to get the new .crt. Because you are signing a new CSR, the serial number will automatically increment (e.g., from 1000 to 1001) in your serial file and be marked as V (Valid) in your index.txt.

```cmd
openssl ca -config C:\testCertificateAuth\openssl.cnf -days 800 -in C:\testCertificateAuth\server\server_amqp_new.csr -out C:\testCertificateAuth\server\server_amqp_new.crt

```

Log

```log
Using configuration from C:\testCertificateAuth\openssl.cnf
Check that the request matches the signature
Signature ok
The Subject's Distinguished Name is as follows
commonName            :ASN.1 12:'MY_RABBIT_SERVER'
ERROR:There is already a certificate for /CN=MY_RABBIT_SERVER
The matching entry has the following details
Type          :Valid
Expires on    :280304211337Z
Serial Number :1001
File name     :unknown
Subject Name  :/CN=MY_RABBIT_SERVER
```

Since OpenSSL identified the conflicting certificate as Serial Number 1001, we will revoke it using that identifier.

The error you encountered is exactly how OpenSSL prevents you from accidentally issuing multiple valid certificates for the same entity. Since you used the same /CN=MY_RABBIT_SERVER for both requests, the CA database (index.txt) sees the first one as "Valid" and refuses to issue a second one.


Index.txt before

```txt
V	360304210653Z		1000	unknown	/CN=SERVER123/C=US
V	280304211337Z		1001	unknown	/CN=MY_RABBIT_SERVER

```

Execute the Revocation


```cmd
openssl ca -config C:\testCertificateAuth\openssl.cnf -revoke C:\testCertificateAuth\server\server_amqp.crt
```

log

```log
Using configuration from C:\testCertificateAuth\openssl.cnf
Revoking Certificate 1001.
Database updated
```
Index.txt after

```txt
V	360304210653Z		1000	unknown	/CN=SERVER123/C=US
R	280304211337Z	260305213407Z	1001	unknown	/CN=MY_RABBIT_SERVER

```

The Final Step
Now, run your signing command to officially issue the new 800-day certificate:

```cmd
openssl ca -config C:\testCertificateAuth\openssl.cnf -days 800 -in C:\testCertificateAuth\server\server_amqp_new.csr -out C:\testCertificateAuth\server\server_amqp_new.crt
```

log

```log
Using configuration from C:\testCertificateAuth\openssl.cnf
Check that the request matches the signature
Signature ok
The Subject's Distinguished Name is as follows
commonName            :ASN.1 12:'MY_RABBIT_SERVER'
Certificate is to be certified until May 13 21:35:53 2028 GMT (800 days)
Sign the certificate? [y/n]:y


1 out of 1 certificate requests certified, commit? [y/n]y
Write out database with 1 new entries
Database updated
```

Run this command on your new server certificate:

```cmd
openssl x509 -in C:\testCertificateAuth\server\server_amqp_new.crt -noout -text
```

## Format files, pem and cer

```cmd
copy C:\testCertificateAuth\server\server_amqp_new.crt C:\testCertificateAuth\server\server_amqp_new.cer

copy C:\testCertificateAuth\server\server_amqp_new.crt C:\testCertificateAuth\server\server_amqp_new.pem

copy C:\testCertificateAuth\server\server_amqp_new.key C:\testCertificateAuth\server\server_amqp_new.key.pem

````

If you ever want to double-check that the file is readable by OpenSSL (to ensure it isn't corrupted), you can use this command:

```cmd
openssl rsa -in C:\testCertificateAuth\server\server_amqp_new.key.pem -check
```

If it outputs RSA key ok, your file is perfectly formatted and ready to be used.
