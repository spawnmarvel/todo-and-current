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
* One root certificates

Copy from

https://github.com/spawnmarvel/quickguides/tree/main/securityPKI-CA

