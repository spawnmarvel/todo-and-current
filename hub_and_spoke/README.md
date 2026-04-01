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


vmhybrid01
* 192.168.3.7
* Public ip

docker03getmirrortest
* 172.64.0.5


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

## Add a new port proxy

vmchaos09
* 192.168.3.4

1. The "Signpost" Command (Windows)

v4tov4

```ps1
netsh interface portproxy add v4tov4 listenport=10935 listenaddress=0.0.0.0 connectport=10933 connectaddress=192.168.3.4
```

2. Open the Windows Firewall

```ps1
New-NetFirewallRule -DisplayName "Octopus Linux Forwarding" -Direction Inbound -LocalPort 10935 -Protocol TCP -Action Allow
```

## Octopus Deploy uses HTTPS (TLS) for its communication.

This is a critical distinction because it changes how you should approach the security of your portproxy setup. If Octopus is already using HTTPS, the data itself is already encrypted before it even touches your Windows Server portproxy.

What This Means for Your Security Strategy
Since the traffic is HTTPS-encrypted:

* The Payload is Safe: The "sniffing" risk is largely mitigated because an attacker capturing the packets would only see encrypted TLS traffic.

* The portproxy Role: Your Windows Server is now acting as a Layer 4 TCP Forwarder. It is effectively a "blind pipe." It does not decrypt or inspect the HTTPS traffic; it just passes the encrypted packets from the Octopus Server to the Linux Tentacle.

* Trust is Key: Because the proxy is blind, the TLS handshake happens directly between the Octopus Server and the Linux Tentacle. The Windows Server never sees the cleartext data or the SSL certificates.