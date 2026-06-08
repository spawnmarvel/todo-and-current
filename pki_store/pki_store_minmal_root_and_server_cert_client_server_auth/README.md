# Minimal PKI

## Certs

* openssl
* Root
* Server with server and client auth for mtls applications

## SSL changes

Let’s Encrypt will be reducing the validity period of the certificates we issue. We currently issue certificates valid for 90 days, which will be cut in half to 45 days by 2028.

https://letsencrypt.org/2025/12/02/from-90-to-45.html


"Many uses of client authentication are better served by a private certificate authority, and so Let’s Encrypt is discontinuing support for TLS Client Authentication ahead of this deadline. "

https://letsencrypt.org/2025/05/14/ending-tls-client-authentication

* Mandatory Automation: Because a 45-day certificate needs to be rotated roughly every 30 days, manual renewals are dead. Systems must utilize ACME client protocols supporting ACME Renewal Information (ARI) to let the CA dictate fluid renewal windows.

* The Industry Push: This is not an isolated choice; it is driven by a CA/Browser Forum mandate (spearheaded by Google Chrome) to reduce public certificate lifespans worldwide to restrict the exposure window of stolen keys.

* Spot on. You have partitioned the concepts perfectly. This 45-day rule change applies strictly to Public Web PKI (the public internet web servers, browser handshakes, and inbound HTTPS connections). It has absolutely nothing to do with private backend mutual TLS (mTLS) pipelines. -


## Why This Bypasses Your Architecture

* Private Isolation: The CA/Browser Forum has zero authority or visibility over your private network loop. Because your components authenticate against a root file (rootCA.crt) that you generated and you maintain, your certificates can stay completely secure at 10 years

* Zero Verification Overhead: You don't have to worry about a cloud verification engine failing to validate your servers every 30 days over the internet. Your RabbitMQ nodes handle identity checks locally in memory using native math.

* Symmetric Protection: While the public web is forced to abandon persistent internal validation mechanics, your internal data transport channel remains highly hardened, decentralized, and entirely self-sustained

