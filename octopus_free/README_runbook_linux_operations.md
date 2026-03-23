# Project Linux Day2 Operations

## Tips

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

### 3. Before you run a runbook, process->target tags

Before you run a runbook always go to

1. Process
2. Target tags, always check it

![process_always_check_target](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/process_always_check_target.png)

Either a vm or multiple vm's or a environment.

![targets_](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/targets_.png)

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
3. Transfer the packet

```bash
scp tentacle_9.1.3608_amd64.deb imsdal@172.64.0.5:/tmp/

imsdal@172.64.0.5's password:
# tentacle_9.1.3608_amd64.deb                          100%   40MB  56.3MB/s   00:00
```
4. No login to offline server

```bash
ssh imsdal@172.64.0.5
cd /tmp/
ls
# [...]
tentacle_9.1.3608_amd64.deb
```

Summary Checklist for your Offline Setup:
1. ​Transfer: Move the .deb file.
2. ​Extract: Use tar -xvf ... -C /opt/octopus.
3. ​Configure: Run the configure-tentacle.sh script.
4. ​Trust: Ensure you have the Octopus Server thumbprint ready to type in.

https://octopus.com/docs/infrastructure/deployment-targets/tentacle/linux

## Install and Operations Runbooks

### 5. Run diagnostic Runbook get

Run disk, cpu, ram, port exhaust status and check last 100 lines if journalctl for errors 

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
