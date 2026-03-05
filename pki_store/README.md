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







