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
* dmzdocker03

Ssh clients
* penguin

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

This approach follows Path 1, where Octopus logs in as your user (YOUR-USERNAME) and uses a "Master Key" to manage the VM. This is the cleanest way to handle many laptops because once Octopus has the key, you just use your browser to manage the server.

🛠️ Step 1: Generate the "Master Key" (On your Laptop)

Run this once to create the key pair that Octopus will use to "talk" to your Zabbix VM.

```bash
# login penguin
ls
id_ed25519  id_ed25519.pub  known_hosts  known_hosts.old

ssh-keygen -t ed25519 -f ~/.ssh/octopus_key -C "octopus-deploy"

cd ~/.ssh
ls
id_ed25519  id_ed25519.pub  known_hosts  known_hosts.old  octopus_key  octopus_key.pub


```
This creates octopus_key (Private) and octopus_key.pub (Public).

🛠️ Step 2: Prepare the Zabbix VM (The "Lock")
You need to tell the VM to accept this specific key and allow YOUR-USERNAME to run admin commands.

1. Add the Public Key:
```bash
# Copy the text of your new public key
cat ~/.ssh/octopus_key.pub
# Paste that text into the VM's file: 
sudo nano ~/.ssh/authorized_keys
```



2. Give YOUR-USERNAME "Sudo" Powers (No Password):

```bash
sudo visudo
# Add this line at the very bottom:
YOUR-USERNAME ALL=(ALL) NOPASSWD:ALL
```

3. Final SSH Lockdown:

```bash
sudo nano /etc/ssh/sshd_config
# PasswordAuthentication no
# AllowUsers YOUR-USERNAME
sudo systemctl restart ssh
```

🛠️ Step 3: Configure Octopus (The "Keyring")

Now, go to your Octopus Web Portal from any laptop.

* Add the Account:
* Go to Infrastructure > Accounts > Add Account > SSH Key.
* Username: YOUR-USERNAME.
* Private Key: Run cat ~/.ssh/octopus_key on your laptop and paste the entire block here.
* Click Save.

Add/update the Target (The VM):

* Go to Infrastructure > Deployment Targets > Add Target > Linux.
* Hostname: Use your Azure Public IP (or the Windows VM IP if using the PortProxy).
* Port: Use 22 (or 10935 if using your netsh proxy).
* Authentication: Select the SSH Account you just made.
* Click Save.

💡 Why this is better for "Many Laptops"

* You don't need to put SSH keys on every laptop.
* You only manage one key (stored safely in Octopus).
* To manage Zabbix, you just log into the Octopus website from any machine.

## Octopus Deploy uses HTTPS (TLS) for its communication.

This is a critical distinction because it changes how you should approach the security of your portproxy setup. If Octopus is already using HTTPS, the data itself is already encrypted before it even touches your Windows Server portproxy.

What This Means for Your Security Strategy
Since the traffic is HTTPS-encrypted:

* The Payload is Safe: The "sniffing" risk is largely mitigated because an attacker capturing the packets would only see encrypted TLS traffic.

* The portproxy Role: Your Windows Server is now acting as a Layer 4 TCP Forwarder. It is effectively a "blind pipe." It does not decrypt or inspect the HTTPS traffic; it just passes the encrypted packets from the Octopus Server to the Linux Tentacle.

* Trust is Key: Because the proxy is blind, the TLS handshake happens directly between the Octopus Server and the Linux Tentacle. The Windows Server never sees the cleartext data or the SSL certificates.

