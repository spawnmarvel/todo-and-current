# Minimal PKI

## Certs

* Root
* Server with server and client auth for mtls applications

## SSL changes

Let’s Encrypt will be reducing the validity period of the certificates we issue. We currently issue certificates valid for 90 days, which will be cut in half to 45 days by 2028.

https://letsencrypt.org/2025/12/02/from-90-to-45.html


Many uses of client authentication are better served by a private certificate authority, and so Let’s Encrypt is discontinuing support for TLS Client Authentication ahead of this deadline.

https://letsencrypt.org/2025/05/14/ending-tls-client-authentication

