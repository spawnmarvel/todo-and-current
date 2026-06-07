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
By default, Squid listens on port 3128. You would just point your private nodes to it by adding these lines back to their ~/.bashrc files, targeting your Linux jump box instead of the old Windows server:

```bash
export http_proxy="http://<INTERNAL_IP_OF_VMZABBIX03>:3128"
export https_proxy="http://<INTERNAL_IP_OF_VMZABBIX03>:3128"

```