# Project Linux Day2 Operations

## Tips

### 0. Docs and samples

1. Getting started
* https://octopus.com/docs/getting-started

2. Samples and examples
* https://octopus.com/docs/getting-started/samples-instance

3. Install, Best pratice, Deployments, Runbooks, Rest etc

### 1. apt or apt-get for install

```bash
# The standard "Automation" way
sudo apt-get update
sudo apt-get install -y snmp

# # The "I'm a Human" way
sudo apt update
sudo apt install -y snmp

# WARNING: apt does not have a stable CLI interface. Use with caution in scripts.
# — is a standard message whenever the apt command is used programmatically or in scripts.  
# It’s informing you that apt is intended for interactive use, and that scripting against it could 
# break in future versions (since its options/output format may change). **For scripts**, the 
# recommended command is apt-get or apt-cache instead, 
# because they have a stable interface meant for automation.  

# The standard "Automation" way
sudo apt-get remove -y snmp

# The "I'm a Human" way
sudo apt remove -y snmp

```

The "Rules of the Road" for 2026

* apt-get is for Scripts/Octopus. It is the "stable" version. Its output doesn't change much between Linux versions, which prevents scripts from breaking unexpectedly.

* apt is for Humans. It has pretty progress bars, colors, and friendly summaries. It's what you type when you are sitting at the keyboard.



### 2. In draft vs publish

In draft mode you can edit, save and it picks up changes at once.

Publishing a runbook will snapshot the runbook process and the associated assets (packages, scripts, variables) as they existed at that moment in time. After publishing a runbook, any future edits made will be considered a “draft.” For a trigger to pick up those new changes, a new publish event will need to occur.



### 3. Before you run a runbook, process-> target tags

Before you run a runbook always go to

1. Process
2. Target tags, always check it

![process_always_check_target](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/process_always_check_target.png)

Either a vm or multiple vm's or a environment.

![targets_](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/targets_.png)

### 4. (Network gateway and port proxy for vm with no public ip)

Since your Windows Server (vmhybrid01) has a public IP and sits in the same network as your private Linux box (docker03getmirrortest), you can use it as a ***Network Gateway***.

NSG outbound for offline vm docker03getmirrortest is internet deny and it has no public IP, so we cannot reach it.

* Just private, 172.64.0.5

![deny_internet](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/deny_internet.png)

1. The "Signpost" Command (Windows)
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

### 4. Install linux tentacle offline

Sometimes we do not have internet access, lets Make a bundle of what we need for an offline vm.

The Octopus Server can communicate with Linux targets in two ways:

* Using the Linux Tentacle(Recommended)
* Over SSH using an SSH target.

Get architecture for ubuntu vm

```bash
uname -a
Linux vmzabbix02 6.17.0-1008-azure #8~24.04.1-Ubuntu SMP Mon Jan 26 18:35:40 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux

dpkg --print-architecture
amd64

```
* x86_64: This is standard 64-bit Intel/AMD (Download the linux-x64 version).
* aarch64 or arm64: This is ARM (like a Raspberry Pi or Graviton instance).

Download tentacle

* tentacle_9.1.3608_amd64.deb

Using the .deb file is better than the .tar.gz because it automatically registers the service with systemd and handles the folder permissions for you.

1. Login in to a server that has internet access.
2. Download the packet

```bash
hostname
vmzabbix02

```

Use the Archive page, just change the version and file
```bash

wget https://download.octopusdeploy.com/linux-tentacle/tentacle_9.1.3608_amd64.deb -O tentacle_9.1.3608_amd64.deb

ls
# tentacle_9.1.3608_amd64.deb
```
3. Transfer the packet to the offline vm docker03getmirrortest


```bash
scp tentacle_9.1.3608_amd64.deb imsdal@172.64.0.5:/tmp/

imsdal@172.64.0.5's password:
# tentacle_9.1.3608_amd64.deb                          100%   40MB  56.3MB/s   00:00
```
4. Now login to offline server

```bash
ssh imsdal@172.64.0.5
cd /tmp/
ls
# [...]
tentacle_9.1.3608_amd64.deb
# cp to home
cp /tmp/tentacle_9.1.3608_amd64.deb tentacle_9.1.3608_amd64.deb
```

5. Run this to unpack the Tentacle software. Since you're using dpkg, it won't try to call home to the internet.

```bash
sudo dpkg -i /tmp/tentacle_9.1.3608_amd64.deb

```

6. This script is the "Wizard" that sets up the instance. It will ask you for your Octopus Server details.

```bash
# To set up a Tentacle instance, run the following script:
/opt/octopus/tentacle/configure-tentacle.sh
```

log

```log
Press enter to continue...
Creating empty configuration file: /etc/octopus/docker03getmirrortest/tentacle-docker03getmirrortest.config
Saving instance: docker03getmirrortest
Setting home directory to: /etc/octopus/docker03getmirrortest
A new certificate has been generated and installed. Thumbprint:
1ABXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
These changes require a restart of the Tentacle.
Removing all trusted Octopus Servers...
Application directory set to: /home/Octopus/Applications
Services listen port: 10933
Tentacle will listen on a TCP port
These changes require a restart of the Tentacle.
Adding 1 trusted Octopus Servers
These changes require a restart of the Tentacle.
Service installed: docker03getmirrortest
Service started: docker03getmirrortest
```

Check it
```bash
sudo service docker03getmirrortest status
```

In the octopus mananger portal we used, enter manual:

* Name, docker03getmirrortest
* Environment, development, tag docker03getmirrortest
* Tentacle URL https://vmhybrid01-public-ip:10934/
* Thumbrint

https://octopus.com/docs/infrastructure/deployment-targets/tentacle/linux

![hybrid_connection](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/hybrid_connection.png)


## Install and Operations Runbooks

So now we have 2 linux vm's and one windows vm.

![3_targets](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/3_targets.png)



### 5. Run diagnostic Runbook get: Linux Get Disk Usage and more

Run disk, cpu, ram, port exhaust status and check last 100 lines if journalctl for errors.


### 6. Upload a packet to linux

### 7. Use variables

Turn those commands into a Bash or PowerShell script. Replace hardcoded values with variables for automation.

```bash
# Bad: 
mysql --user=root --password=Password123
# Good: 
mysql --user=#{MySQL.User} --password=#{MySQL.Password}
```

### 8 Install MySql Runbook

Here we use apt-get and variables


### 8 Upgrade MySql with a packet Runbook

Here we use apt-get, variables and we have a downloaded MySql 8.4 packet

### 9 Make SSL cert Runbook

Make a cert

Renew a cert and mv files


### 10 Zabbix stack (MySql is in a different runbook) Runbook 
