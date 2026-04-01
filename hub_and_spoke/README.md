# Hub and Spoke networking model

![hub and spoke](https://github.com/spawnmarvel/todo-and-current/blob/main/hub_and_spoke/images/topology.png)

## Environment

vnet-noe-europe
* 172.64.0.0/26, 64 addresses

Peered virtual network address space
* vnet-noe-2-uks peered to vnet-uks-central

vnet-uks-central
* 192.168.0.0/20, 4096 addresses


### Network gateway and port proxy

Network gateway and port proxy for vm with no public ip

Since your Windows Server (vmhybrid01) has a public IP and is peered with the network as your private Linux box (docker03getmirrortest), you can use it as a ***Network Gateway***.

docker03getmirrortest

* Just private, 172.64.0.5


1. The "Signpost" Command (Windows)

v4tov4

* Adds a proxy rule to listen on an IPv4 address and port, forwarding incoming TCP connections to another IPv4 address and port.

On your Windows Server 2025, open PowerShell as Administrator and run this command:

```ps1
# Add the new one on Port 10934
# Run this on your Windows Server to create a dedicated lane for the Linux traffic:
netsh interface portproxy add v4tov4 listenport=10934 listenaddress=0.0.0.0 connectport=10933 connectaddress=172.64.0.5
```
* listenport=10934: The port Octopus will call, we up one port since we already have at tentacle for vmhybrid01
* listenaddress=0.0.0.0: Tells Windows to listen on all its IPs (including the public one).
* connectaddress: This is the internal/private IP of your Linux machine.

2. Open the Windows Firewall

```ps1
New-NetFirewallRule -DisplayName "Octopus Linux Forwarding" -Direction Inbound -LocalPort 10934 -Protocol TCP -Action Allow
```

Add NSG also for vmhybrid01 for inbound 10934 since we already have a tenatcle for vmhybrid01, we must use a different port for docker03getmirrortes.