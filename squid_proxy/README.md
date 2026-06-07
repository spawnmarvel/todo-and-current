# The Squid Proxy / Routing via vmzabbix03

## Squid is a caching proxy

Squid is a caching proxy for the Web supporting HTTP, HTTPS, FTP, and more. It reduces bandwidth and improves response times by caching and reusing frequently-requested web pages. Squid has extensive access controls and makes a great server accelerator. It runs on most available operating systems, including Windows and is licensed under the GNU GPL.

You can install Squid, a highly efficient open-source caching proxy, on your jump server:

https://www.squid-cache.org/


## Install it

Since you are tired of the Windows/WinGate routing loops, you can build a lightweight Linux-native proxy on vmzabbix03 since it already has internet access and internal connectivity to the other nodes.

```bash

# Run this on your public-facing jump box: vmzabbix03
sudo apt update && sudo apt install squid -y

```

Step 1: Apply Permanent Proxy on Private Nodes

By default, Squid listens on port 3128. You would just point your private nodes to it by adding these lines back to their ~/.bashrc files, targeting your Linux jump box instead of the old Windows server:

```bash
sudo tee -a /etc/environment << 'EOF'
http_proxy="http://172.16.0.4:3128"
https_proxy="http://172.16.0.4:3128"
HTTP_PROXY="http://172.16.0.4:3128"
HTTPS_PROXY="http://172.16.0.4:3128"
no_proxy="localhost,127.0.0.1,168.63.129.16"
NO_PROXY="localhost,127.0.0.1,168.63.129.16"
EOF
```

Step 2: Configure Dedicated Proxy Paths for Apt

```bash
sudo tee /etc/apt/apt.conf.d/99proxy << 'EOF'
Acquire::http::Proxy "http://172.16.0.4:3128/";
Acquire::https::Proxy "http://172.16.0.4:3128/";
EOF
```

Step 3: Verification Test

```bash
# To initialize the changes instantly without waiting for a machine reboot, reload your current shell environment parameters on the private nodes:
source /etc/environment

# Verify that the operating system recognizes the new permanent paths:
env | grep -i proxy

```

The Output Check: Your console should display the variables pointing to 172.16.0.4:3128.

The Final Egress Check: Test a secure header fetch: curl -I https://www.google.com. If you receive a valid web status code back, your private nodes are officially routing through your Squid gateway!