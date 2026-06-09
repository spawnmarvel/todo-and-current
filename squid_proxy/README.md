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

# Step 1: Create an Allowed Domains List
sudo nano /etc/squid/allowed-domains.txt

# Add the required domains for Ubuntu operations:
.ubuntu.com
.debian.org

# Step 2: Update squid.conf
sudo nano /etc/squid/squid.conf

# Locate the section where ACLs are defined (usually near the top) and define your whitelist rule. Crucially, ensure your http_access allow rule is placed above any catch-all http_access deny all lines:
# Define an ACL pointing to your whitelist file
acl allowed_ubuntu_sites dstdomain "/etc/squid/allowed-domains.txt"

# Allow access from your internal networks to these sites
http_access allow allowed_ubuntu_sites

# Keep your existing default rules below this line
http_access deny all

# Step 3: Reload Squid
sudo squid -k reconfigure
# Or alternatively
sudo systemctl reload squid
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

 # Export the contents of /etc/environment into your current session
export $(cat /etc/environment | grep -v '^#' | xargs)

# Verify that the operating system recognizes the new permanent paths:
env | grep -i proxy

```

The Output Check: Your console should display the variables pointing to 172.16.0.4:3128.

The Final Egress Check: Test a secure header fetch: curl -I https://www.google.com. If you receive a valid web status code back, your private nodes are officially routing through your Squid gateway!

```bash
# Test 1: Verify system environment proxying via curl
curl -I https://www.google.com

# Test 2: Verify apt package manager proxying
sudo apt-get update
```