# Hub and Spoke networking model

The "Hub" Hierarchy
To keep the mental model clear:

1. Architecture: Hub and Spoke.

2. Technique: Port Forwarding / Port Proxy.

3. Windows Service: iphlpsvc (IP Helper).

4. Configuration Tool: netsh.

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

vmsnmpsim01
* 192.168.3.6

1. The "Signpost" Command (Windows)

v4tov4

```ps1
netsh interface portproxy add v4tov4 listenport=10936 listenaddress=0.0.0.0 connectport=10933 connectaddress=192.168.3.6
```

2. Open the Windows Firewall

```ps1
New-NetFirewallRule -DisplayName "Octopus Linux Forwarding" -Direction Inbound -LocalPort 10936 -Protocol TCP -Action Allow
```

## netsh netsh interface portproxy show all

```ps1
# This shows you exactly what iphlpsvc is currently forwarding
netsh interface portproxy show all
```

log
```log
Listen on ipv4:             Connect to ipv4:

Address         Port        Address         Port
--------------- ----------  --------------- ----------
0.0.0.0         10934       172.64.0.5      10933
0.0.0.0         10935       192.168.3.4     10933
0.0.0.0         10936       192.168.3.6     10933

```

## Install Fail2Ban (The Automated Guard) (option)

```bash
# install: 
sudo apt install fail2ban
# The default configuration usually protects SSH out of the box.
```
## Hardened "Standard" SSH (The "No-New-Software" Path)

Vm
* vmzabbix02

Ssh clients
* penguin

Check your logs now to see if people are already trying to get in:

```bash
# (shows failed login attempts)
sudo lastb  
# or 
tail -f /var/log/auth.log.
```
If you don't want a VPN at all, you can keep SSH public but make it impossible to break into.

1. Kill Password Logins (Crucial)

This stops the "brute force" bots in your logs cold. They can guess passwords all day, but the server will simply refuse to even ask for one.

```bash
# Create an SSH key on your laptop: 
ssh-keygen -t ed25519

# Copy it to the VM: 
ssh-copy-id imsdal@<your-azure-ip>

ssh username@ip

# Edit 
sudo nano /etc/ssh/sshd_config and set:

# PasswordAuthentication no
# PubkeyAuthentication yes
# PermitRootLogin no
# AllowUsers your-user-name

# Restart: 
sudo systemctl restart ssh
```
By setting PermitRootLogin no, you are telling the SSH server: 
* "If someone tries to log in directly as 'root', disconnect them immediately, even if they have a valid key." 
* This is a security best practice because every Linux bot in existence targets the name root first.

Login passwordless

```bash
ssh username@ip
```

By disabling passwords and using SSH keys on Port 22, you have eliminated 99.9% of the automated risk. Here is the reality of your current security posture:

🛡️ What you have defeated

* Brute-Force Bots: The bots in your lastb logs can try a trillion passwords; the server will simply refuse to even listen.

* Credential Stuffing: Even if your personal email/password was leaked in a data breach, it can't be used to enter this VM.

* Dictionary Attacks: Common usernames like admin or test are now useless because of your AllowUsers whitelist.

### Add a new

If you have followed the "No-New-Software" path and disabled password authentication, a new VM (let’s call it VM-B) cannot simply SSH into your Zabbix VM (VM-A) using a password. It will get a Permission denied (publickey) error.

1. The Client Side (The New Machine)
The person on the new machine must generate their own cryptographic identity.

```bash
# Run this command: 
ssh-keygen -t ed25519

# They should then find the file named 

id_ed25519.pub and send the text inside it to you.

# It will look like: ssh-ed25519 AAAAC3Nza... user@new-laptop
```

2. The Server Side

You must now "register" that key. Since you added the AllowUsers rule, there are two things you must check:

A. Add the Key to the Authorized List

```bash
# Log into your Zabbix VM and open the keys file:
sudo nano ~/.ssh/authorized_keys

# Go to a new line at the bottom.
# Paste the new public key string.
# Save and exit (Ctrl+O, Enter, Ctrl+X).
``` 

B. Update the "VIP List" (AllowUsers)

If the new person is logging in as a different Linux username, you must tell SSH they are allowed. If they are also logging in as same user, you can skip this step.


## Octopus Deploy uses HTTPS (TLS) for its communication.

This is a critical distinction because it changes how you should approach the security of your portproxy setup. If Octopus is already using HTTPS, the data itself is already encrypted before it even touches your Windows Server portproxy.

What This Means for Your Security Strategy
Since the traffic is HTTPS-encrypted:

* The Payload is Safe: The "sniffing" risk is largely mitigated because an attacker capturing the packets would only see encrypted TLS traffic.

* The portproxy Role: Your Windows Server is now acting as a Layer 4 TCP Forwarder. It is effectively a "blind pipe." It does not decrypt or inspect the HTTPS traffic; it just passes the encrypted packets from the Octopus Server to the Linux Tentacle.

* Trust is Key: Because the proxy is blind, the TLS handshake happens directly between the Octopus Server and the Linux Tentacle. The Windows Server never sees the cleartext data or the SSL certificates.

## Do you still need IPsec?

In most enterprise environments, you do not need IPsec if you are already using HTTPS, unless:

Compliance Requirements: Your security policy mandates "Encryption in Transit" at the network layer in addition to the application layer.

Header Protection: You want to hide metadata (like the source/destination IPs or timing patterns) that TLS might still expose to a network-level observer.

For most users, relying on the native HTTPS security of Octopus Deploy is sufficient, provided your firewall is . locked down to the specific Octopus Server IP.

## Security Checklist for "Blind Pipe" Proxies

Since your Windows portproxy is "blind" (it just passes the encrypted bits), you should focus on these three layers to lock it down completely:

Firewall Lockdown: Ensure the Windows firewall rule explicitly allows only the IP of the Octopus Server.

Command: Set-NetFirewallRule -DisplayName "Octopus Linux Forwarding" -RemoteAddress <Your_Octopus_Server_IP>

Certificate Pinning: Octopus Deploy automatically handles certificate pinning. Never ignore "Certificate Mismatch" errors in your Octopus logs; these are your primary indicator that someone might be attempting a "Man-in-the-Middle" (MitM) attack.

Service Hardening: Since the Windows Hub is the "Gatekeeper," minimize the services running on it. A clean, updated Windows Server with only iphlpsvc exposed is significantly harder to compromise.