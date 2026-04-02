# Hub and Spoke networking model (and ssh keys)

The "Hub" Hierarchy
To keep the mental model clear:

1. Architecture: Hub and Spoke.

2. Technique: Port Forwarding / Port Proxy.

3. Windows Service: iphlpsvc (IP Helper).

4. Configuration Tool: netsh.

![hub and spoke](https://github.com/spawnmarvel/todo-and-current/blob/main/hub_and_spoke/images/topology.png)

## Environment

vnet-noe-europe
172.64.0.0/26, 64 addresses

Subnets
* default 172.64.0.0/28 - 9

Peered virtual network address space
* vnet-noe-2-uks peered to vnet-uks-central

vnet-uks-central
192.168.0.0/20, 4096 addresses

Subnet
* Vms03 192.168.3.0/24 - 247
* Dmzs02 192.168.2.0/28 - 11



### Network gateway and port proxy

Network gateway and port proxy for vm with no public ip

Since your Windows Server (vmhybrid01) has a public IP and is peered with the network as your private Linux box (docker03getmirrortest), you can use it as a ***Network Gateway***.


vmhybrid01
* 192.168.3.7
* Public ip

docker03getmirrortest
* 172.64.0.5

#### Network Gateway

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

Add NSG also for vmhybrid01 for inbound 10934 since we already have a tenatcle for vmhybrid01, we must use a different port for docker03getmirrortest.

## Add a new port proxy

### Network Gateway

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

### Network Gateway

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

vm
* vmzabbix
* dmzdocker03

```bash
# install: 
sudo apt install fail2ban
# The default configuration usually protects SSH out of the box.

fail2ban-server -V

# Check if the service is running
sudo fail2ban-client ping
# Expected response: "Server replied: pong"

# See all active jails (e.g., sshd)
sudo fail2ban-client status

# See detailed stats for your SSH jail
sudo fail2ban-client status sshd

# Fail2Ban settings are stored in /etc/fail2ban/

# Important: Never edit the .conf files directly. 
# Always check or create .local files, as these override the defaults and won't be deleted during updates.
cd /etc/fail2ban
ls
ction.d  fail2ban.conf  fail2ban.d  filter.d  jail.conf  jail.d  paths-arch.conf  paths-common.conf  paths-debian.conf  paths-opensuse.conf

# View your main jail configuration if you made it
cat /etc/fail2ban/jail.local
```
Since you have PasswordAuthentication no and are using SSH Keys, you are almost immune to being locked out by Fail2Ban.

⚠️ The One Exception (The "Too Many Keys" Error)
There is only one way you might accidentally trigger a lockout while using keys:

If you have many different SSH keys on one laptop (for GitHub, GitLab, and other servers), your SSH client might try to "offer" all of them to your Linux VM one by one.


```bash
sudo sshd -T | grep -i maxauthtries
# maxauthtries 6
```
## Hardened "Standard" SSH (The "No-New-Software" Path)

Vm
* vmzabbix02
* dmzdocker03

Ssh clients
* penguin
* ber

Check your logs now to see if people are already trying to get in :

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
ssh-copy-id YOUR-USERNAME@<your-azure-ip>

ssh username@ip

# Edit 
sudo nano /etc/ssh/sshd_config
#  and set:

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

### Disabling passwords and using SSH keys on Port 22

By disabling passwords and using SSH keys on Port 22, you have eliminated 99.9% of the automated risk. Here is the reality of your current security posture:

🛡️ What you have defeated

* Brute-Force Bots: The bots in your lastb logs can try a trillion passwords; the server will simply refuse to even listen.

* Credential Stuffing: Even if your personal email/password was leaked in a data breach, it can't be used to enter this VM.

* Dictionary Attacks: Common usernames like admin or test are now useless because of your AllowUsers whitelist.


### Add a new client

If you have followed the "No-New-Software" path and disabled password authentication, a new client (let’s call it laptop-B) cannot simply SSH into your VM (VM-A) using a password. It will get a Permission denied (publickey) error.

🚫 Why it fails for the next client:

Once you set PasswordAuthentication no in your sshd_config, the door for passwords is dead.

1. The Client Side (The New Machine)
The person on the new machine must generate their own cryptographic identity.

```bash
# Either use the key you all ready have
# check it

# linux
sudo cat ~/.ssh/id_ed25519.pub
# windows
Get-Content $HOME\.ssh\id_ed25519.pub

# or run this command if you have no ssh keys: 
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
sudo cat ~/.ssh/authorized_keys

# edit it
sudo nano ~/.ssh/authorized_keys

# Go to a new line at the bottom.
# Paste the new public key string.
# Save and exit (Ctrl+O, Enter, Ctrl+X).
``` 

B. Update the "VIP List" (AllowUsers)

If the new person is logging in as a different Linux username, you must tell SSH they are allowed. If they are also logging in as same user, you can skip this step.

#### How to sync them up with github

Since you created a new key on your laptop, your previous "identity" is gone as far as GitHub is concerned. Your laptop is now presenting a brand-new "ID card" that GitHub doesn't recognize yet.

To fix this, you need to "introduce" this new key to your GitHub account.

```bash
cat ~/.ssh/id_ed25519.pub
# it should start with ssh-ed25519 and end with your laptop's name
```

🛠️ Step : Add it to GitHub

* Log into GitHub.com and go to Settings (click your profile icon in the top right).
* On the left-hand menu, click SSH and GPG keys.
* Click the green New SSH key button.
* Title: Give it a name like "Laptop April 2026".
* Key: Paste the string you copied in Step 1.
* Click Add SSH key.

🛠️ Step 3: Test the Connection

```bash
ssh -T git@github.com
# Hi username! You've successfully authenticated, but GitHub does not provide shell access.
``` 

## Octopus Deploy ssh keys

If you switch to SSH Keys, you are moving away from the Octopus Tentacle Agent ($10933$).

### Why the Octopus tentacle still works

When you see ##OCTOLINE## and ##OCTOCOPY##, that is the Calamari engine (the Tentacle's brain) talking back to the Octopus Server. Even though you hardened the SSH service on the VM, the Tentacle service is still running in the background on its own port ($10933$).

🔍 Why the Tentacle still works
Hardening your SSH config (sshd_config) only affects connections trying to enter through Port 22.

🛡️ SSH Service: Now requires keys and blocks passwords.

🐙 Tentacle Service: Still uses its own Certificate Thumbprint to authenticate. It doesn't care about your SSH settings because it doesn't use the SSH protocol.

⚠️ The Risk of "Dual Entry"

If you keep both, you have two "Front Doors" into your VM:

* The SSH Door: (Hardened with Keys).

* The Tentacle Door: (Using the Octopus Agent).


## Octopus Deploy uses HTTPS (TLS) for its communication.

This is a critical distinction because it changes how you should approach the security of your portproxy setup. If Octopus is already using HTTPS, the data itself is already encrypted before it even touches your Windows Server portproxy.

What This Means for Your Security Strategy
Since the traffic is HTTPS-encrypted:

* The Payload is Safe: The "sniffing" risk is largely mitigated because an attacker capturing the packets would only see encrypted TLS traffic.

* The portproxy Role: Your Windows Server is now acting as a Layer 4 TCP Forwarder. It is effectively a "blind pipe." It does not decrypt or inspect the HTTPS traffic; it just passes the encrypted packets from the Octopus Server to the Linux Tentacle.

* Trust is Key: Because the proxy is blind, the TLS handshake happens directly between the Octopus Server and the Linux Tentacle. The Windows Server never sees the cleartext data or the SSL certificates.

## Windows Server (vmhybrid01) as a Network Gateway/Proxy

To harden this Windows "Hub" while keeping the Octopus traffic flowing, follow these steps:


### 1. Scoped Firewall Rules (IP Whitelisting)

By default, your New-NetFirewallRule allows anyone on the internet to hit port 10934. You should restrict this so only Octopus can talk to that port.

```ps1
# Get the Public IP of your Octopus Server first, then run:
Set-NetFirewallRule -DisplayName "Octopus Linux Forwarding" -RemoteAddress "YOUR_OCTOPUS_SERVER_IP"
``` 

Do the same in the Azure NSG:

Change the Source from Any to IP Addresses.

Enter the specific static IP of your Octopus Cloud or Server.

### 2. Disable Unnecessary "PortProxy" Listeners

Windows keeps the iphlpsvc (IP Helper) running, but you should ensure it isn't listening on ports you aren't using.

Check active proxies: netsh interface portproxy show all

Delete old/unused proxies: netsh interface portproxy delete v4tov4 listenport=OLD_PORT listenaddress=0.0.0.0

### 3. Lockdown the "IP Helper" Service

The netsh portproxy command relies on the IP Helper service. You can harden the service itself:

Service Account: Ensure the service is running as LocalService (default), not LocalSystem.

Audit Logging: Enable "Filtering Platform Connection" auditing in Windows to see every time the proxy is used.

```ps1
auditpol /set /subcategory:"Filtering Platform Connection" /success:enable /failure:enable
```


### 4. Disable Administrative Shares and SMB

Since this VM is acting as a Gateway, it doesn't need to be a File Server. Attackers love SMB (Port 445).

Disable SMB v1/v2/v3 if not needed for internal management.

Disable Administrative Shares (C$, ADMIN$) via Registry to prevent lateral movement if an attacker gets a foothold.


### 5. Rename and Protect the Local Admin

Since Octopus and your laptops are using SSH Keys for the Linux box, you should make sure the Windows box isn't vulnerable to "Brute Force" on its own login.

Rename the 'Administrator' account to something unique.

Enable Account Lockout Policy: Set it to lock the account for 30 minutes after 5 failed attempts.

Azure Bastion: If possible, remove the Public IP for RDP (Port 3389) entirely and use Azure Bastion to manage the Windows VM. This leaves Port 10934 as the only "hole" in the wall.

### 6. Use a "Non-Standard" Port for the Proxy

You are already doing this by using 10934 instead of 22. This is called Security by Obscurity. It doesn't stop a determined hacker, but it stops 99% of automated botnets that only scan for port 22.

🛠️ Verification Command
After hardening, run this on the Windows VM to see exactly what is exposed to the world:

```ps1
netstat -ano | findstr "LISTENING" | findstr ":10934"
```
🔹 This confirms that your "Gateway" is active only on the specific port you designated for the Linux Spoke.


### 🛡️ 7. Harden the IP Helper Service (Registry)
The netsh portproxy relies on the IP Helper service (iphlpsvc). You can prevent the service from being easily manipulated by non-admin users.

Disable IPv6 transition technologies: Since you are using v4tov4, you don't need Teredo or 6to4, which are often used by attackers for tunneling.

```ps1
netsh interface ipv6 set teredo disable
netsh interface ipv6 6to4 set state disabled
```

## 💡 8. Final Recommendation: Remote Desktop (RDP)

🛡️ 1. Enable NLA in Windows
Network Level Authentication (NLA) is your first line of defense—it forces the user to authenticate before the full RDP session even starts.

This ensures that any "ghost" connections that don't have a valid username/password are dropped immediately before they can use system resources.

Open PowerShell as Administrator.

Run this command to force NLA on:

```ps1
(Get-WmiObject -class "Win32_TSGeneralSetting" -Namespace "Root\Cimv2\TerminalServices" -Filter "TerminalName='RDP-Tcp'").SetUserAuthenticationRequired(1)
```

To verify via UI: Go to Settings > System > Remote Desktop > Advanced Settings and ensure "Require computers to use Network Level Authentication to connect" is checked.

🛡️ 2. Restrict Source IP in Azure NSG

This is the most powerful hardening step. You are telling the Azure Firewall: "Only allow my physical house/office to talk to Port 3389."


Note: If your home IP changes (Dynamic IP), you will lose access and need to log into the Azure Portal to update this rule. This is a small price to pay for massive security.

