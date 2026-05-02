# Project Linux Day 2 Operations Runbooks

## Table of Contents

- [Project Linux Day 2 Operations Runbooks](#project-linux-day-2-operations-runbooks)
  - [Table of Contents](#table-of-contents)
  - [Runbooks vs Deployments](#runbooks-vs-deployments)
  - [Tips Octopus](#tips-octopus)
    - [1. Docs and samples](#1-docs-and-samples)
    - [2. In draft vs publish](#2-in-draft-vs-publish)
    - [3. Deployment target and add step generic tag](#3-deployment-target-and-add-step-generic-tag)
    - [4. How to Target a Single Host for a Runbook (or a full envirnment)](#4-how-to-target-a-single-host-for-a-runbook-or-a-full-envirnment)
    - [5. Delete a runbook or prefix it](#5-delete-a-runbook-or-prefix-it)
  - [Tips Linux](#tips-linux)
    - [1. apt or apt-get for install for automation](#1-apt-or-apt-get-for-install-for-automation)
    - [2 Run "bulletproof" in a CI/CD environment](#2-run-bulletproof-in-a-cicd-environment)
      - [New "Bulletproof" Script Template](#new-bulletproof-script-template)
    - [2 Octopus green with white warning fix](#2-octopus-green-with-white-warning-fix)
    - [3. Variables for automation](#3-variables-for-automation)
    - [(Network gateway and port proxy for vm with no public ip)](#network-gateway-and-port-proxy-for-vm-with-no-public-ip)
    - [Install linux tentacle offline](#install-linux-tentacle-offline)
- [Install and Operations Runbooks](#install-and-operations-runbooks)
  - [1. Diagnostoics Runbook](#1-diagnostoics-runbook)
  - [2. Upload packet Runbook](#2-upload-packet-runbook)
  - [3 Renew SSL cert Runbook](#3-renew-ssl-cert-runbook)
    - [Install linux tentacle (this vm has internet access), AD DS must be running](#install-linux-tentacle-this-vm-has-internet-access-ad-ds-must-be-running)
    - [Make SSL cert Runbook with folder, backup, new cert and key](#make-ssl-cert-runbook-with-folder-backup-new-cert-and-key)
  - [3.1 Apache add new SSL cert Runbook](#31-apache-add-new-ssl-cert-runbook)
  - [That completes the basic for now](#that-completes-the-basic-for-now)
- [4. Upload packet versions and working with vars (2. Upload packet Runbook extended)](#4-upload-packet-versions-and-working-with-vars-2-upload-packet-runbook-extended)
  - [4.1 Upload a text file and edit versions](#41-upload-a-text-file-and-edit-versions)

## Runbooks vs Deployments


They are similar in many ways: a runbook process is a series of steps, which can reference packages and variables.

The key differences are:

* No release needs to be created to execute a runbook.
* Lifecycles do not apply to runbooks.
* Runbook executions are not displayed on the deployment dashboards.
* Many runbooks can live in the same project, along with a deployment process.
* Runbooks have different roles and permissions to deployments.

A project’s variables are shared between the deployment process and any runbooks in the project (though specific values can be scoped exclusively to specific runbooks or to the deployment process)

https://octopus.com/docs/runbooks/runbooks-vs-deployments

## Tips Octopus

### 1. Docs and samples

1. Getting started
* https://octopus.com/docs/getting-started

2. Samples and examples
* https://octopus.com/docs/getting-started/samples-instance

3. Install, Best pratice, Deployments, Runbooks, Rest etc

### 2. In draft vs publish

In draft mode you can edit, save and it picks up changes at once.

Publishing a runbook will snapshot the runbook process and the associated assets (packages, scripts, variables) as they existed at that moment in time. After publishing a runbook, any future edits made will be considered a “draft.” For a trigger to pick up those new changes, a new publish event will need to occur.

### 3. Deployment target and add step generic tag

When you add a deployment target, tag it with environment, os and hostname as a minimum.

![tag vm](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/tag_vm.png)


When you make add a step, use the environment tags

* Dev
* linux or windows, do not use a hostname.

![target generic 2](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/target_generic2.png)

That make is easier when you are later going to change the setting from "All applicable targets" to "Specific targets".


### 4. How to Target a Single Host for a Runbook (or a full envirnment)

Yes, you can target a single host (or a subset of targets) for a runbook, but the interface is a bit different than the standard "Deploy" screen.

You don't have to manually edit every step in the runbook to change the target; instead, you use Target Filters during the runbook execution process.

When you are ready to execute your runbook, follow these steps to narrow your scope:

1. Navigate to your Runbook and click the Run... button, and select environment.

![runbook run](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/runbook_run2.png)

2. In the execution setup screen, look for the Targeting section (usually under the Environment selection).

![show advanced](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/show_adva.png)

3. Change the setting from Innclude all to, ***Include specific deployments targets***
4. A search box will appear where you can select the individual host(s) you want to run the script against.
5. The other servers that are also tagged with os name and vmname will be unchecked.
6. Run the runbook (then it is alwaay mapped to a generic tag and on the run, we give it a target tag)

![target ready](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/target_ready.png)



***Once these changes are made, running the runbook will execute the configured steps on all deployment targets matching the specified tags within the selected environment.***

### 5. Delete a runbook or prefix it

Go to the runbook, settings and all the way to the right on the 3 ...

Prefix it

Go to the runbook, settings and append below example it then save.

* [OLD] rest of name or [DEPRECATED] rest of name


## Tips Linux

### 1. apt or apt-get for install for automation

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

* apt-get is for Scripts/Octopus. It is the "stable" version. Its output doesn't change much between Linux versions, which prevents scripts from breaking unexpectedly.

* apt is for Humans. It has pretty progress bars, colors, and friendly summaries. It's what you type when you are sitting at the keyboard.

### 2 Run "bulletproof" in a CI/CD environment

To run "bulletproof" in a CI/CD environment like Octopus—especially when jumping between a Windows UI and a Linux shell—you have to assume that everything that can fail, will fail.

The trick is to use Defensive Scripting. Here are the golden rules for making your Runbooks indestructible:

1. The "Explicit Path" Rule

Never trust that Linux knows where journalctl, systemctl, or mysql are.

```bash
# Weak: journalctl --disk-usage

# Bulletproof: Use the full path or a which check.
# Explicitly set the path at the top of every script
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

```
2. The "No-Pager" & "Non-Interactive" Rule

This is the #1 reason Octopus tasks "hang." If a command tries to be "helpful" by opening a scrollable list, the script dies.

```bash
journalctl --no-pager

apt-get install -y (The -y is mandatory)

systemctl --no-ask-password
```

3. The "Exit Code" Guard (|| true)

Octopus marks a task as Failed if the last command returns anything other than 0.

* The Problem: grep returns 1 if it doesn't find a match. If your script ends with a search that finds nothing, the whole runbook fails.

* Bulletproof: Append || true to commands that are "informative" but not "critical."


```bash
# This won't crash the task if no errors are found
journalctl -p err -n 50 --no-pager || echo "No errors to report"
``` 

4. Use "Strict Mode" (The set Command)

At the start of your Bash scripts, use these flags to catch errors early:

* set -e: Exit immediately if a command fails (use this when you want total failure on any error).

* set -u: Exit if you try to use an undefined variable (great for catching typos in Octopus variables).

5. The "Non-Blocking" Redirect

Sometimes a service outputs "standard error" (stderr) that Octopus misinterprets as a script failure.

```bash
# Redirects errors to the standard log stream
my_script.sh 2>&1
```
#### New "Bulletproof" Script Template

```bash
#!/bin/bash
# --- INITIALIZATION ---
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
set -u # Catch undefined variables

echo "🔷 Starting Task: Checking Zabbix Health..."

# --- EXECUTION WITH GUARDS ---
# 1. Check if binary exists
if ! command -v journalctl &> /dev/null; then
    echo "❌ ERROR: journalctl not found. Is this the right OS?"
    exit 1
fi

# 2. Run command with no-pager and fallback
journalctl -u zabbix-server -n 20 --no-pager || echo "⚠️ Could not read Zabbix logs."

# --- CLEAN EXIT ---
echo "✅ Task Completed Successfully."
exit 0
# By ending every script with exit 0, you tell Octopus: "I have handled the errors, the script is finished, and you can mark this as green.
```

### 2 Octopus green with white warning fix

```bash
# 5. Test Apache configuration before restarting
echo "Testing Apache configuration..."

# Redirect stderr (2) to stdout (1) so "Syntax OK" isn't red in Octopus
if sudo apachectl configtest 2>&1; then
    echo "Config confirmed OK. Restarting Apache..."
    # 6. Restart
    sudo systemctl restart apache2
    echo "Apache restarted successfully."
else
    echo "Apache config test FAILED! Check the logs above."
    exit 1
fi

# 7. Force a clean exit
exit 0
```

### 3. Variables for automation

```bash
Turn those commands into a Bash or PowerShell script. Replace hardcoded values with variables for automation.

```bash
# Bad: 
mysql --user=root --password=Password123
# Good: 
mysql --user=#{MySQL.User} --password=#{MySQL.Password}
```


### (Network gateway and port proxy for vm with no public ip)

Since your Windows Server (vmhybrid01) has a public IP and sits in the same network as your private Linux box (docker03getmirrortest), you can use it as a ***Network Gateway***.

NSG outbound for offline vm docker03getmirrortest is internet deny and it has no public IP, so we cannot reach it.

* Just private, 172.64.0.5

![deny_internet](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/deny_internet.png)

1. The "Signpost" Command (Windows)
On your Windows Server 2025, open PowerShell as Administrator and run this command:

v4tov4

* Adds a proxy rule to listen on an IPv4 address and port, forwarding incoming TCP connections to another IPv4 address and port.


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

### Install linux tentacle offline

Sometimes we do not have internet access, lets Make a bundle of what we need for an offline vm.

The Octopus Server can communicate with Linux targets in two ways:

* Using the Linux Tentacle(Recommended)
* Over SSH using an SSH target.

Get architecture for ubuntu vm

```bash
uname -a
Linux vmzabbix03 6.17.0-1008-azure #8~24.04.1-Ubuntu SMP Mon Jan 26 18:35:40 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux

dpkg --print-architecture
amd64

```
* x86_64: This is standard 64-bit Intel/AMD (Download the linux-x64 version).
* aarch64 or arm64: This is ARM (like a Raspberry Pi or Graviton instance).

Go to

https://octopus.com/docs/infrastructure/deployment-targets/tentacle/linux

![download_p](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/download_p.png)

Just press it and select version after

![download_a](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/download_a.png)

Version, drop down

![download_v](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/download_v.png)

Archive

![download_arc](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/download_arc.png)


Note about versions:
```txt
With an Octopus Server v2022.3 (build 10863), you have a specific "compatibility window." 
While Octopus usually supports older Tentacles, for Ubuntu 24.04, 
you want a version that understands modern Linux internals (like systemd and OpenSSL 3.0).

The ideal Linux Tentacle version for your setup is 6.3.x or higher.

Note: If it returns 7.x or 8.x, don't panic! Newer Tentacles are almost always 
backward compatible with a 2022.3 Server. 
The 2022.3 Server just won't be able to use the "newest" features 
(like specific Kubernetes steps), but for MySQL scripts and package transfers, it will work perfectly.

```
Extra Octopus Deploy 2019.10 Tentacle for Linux.? Well where is the tentacle version is seems like 5.0.15, it is not 5.0.2

* https://octopus.com/blog/octopus-release-2019.10

Download tentacle

* tentacle_9.1.3608_amd64.deb

Using the .deb file is better than the .tar.gz because it automatically registers the service with systemd and handles the folder permissions for you.

1. Login in to a server that has internet access.
2. Download the packet

```bash
hostname
vmzabbix03

```

Use the Archive page, just change the version and file
```bash

wget https://download.octopusdeploy.com/linux-tentacle/tentacle_9.1.3608_amd64.deb -O tentacle_9.1.3608_amd64.deb

ls
# tentacle_9.1.3608_amd64.deb
```
3. Transfer the packet to the offline vm docker03getmirrortest


```bash
scp tentacle_9.1.3608_amd64.deb username@172.64.0.5:/tmp/

username@172.64.0.5's password:
# tentacle_9.1.3608_amd64.deb                          100%   40MB  56.3MB/s   00:00
```
4. Now login to offline server

```bash
ssh username@172.64.0.5
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
* Thumbprint that was generated on the target:
1ABXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

https://octopus.com/docs/infrastructure/deployment-targets/tentacle/linux

![hybrid_connection](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/hybrid_connection.png)


# Install and Operations Runbooks

So now we have 2 linux vm's and one windows vm.

![3_targets](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/3_targets.png)

* docker03getmirrotest has no internet access, ref (Network gateway and port proxy for vm with no public ip
* vmchaos09, has internet and public ip
* vmhybrid01 is AD DS server and DNS, it is also used for port proxy for docker03getmirrotest on 10934 since it has its own tentacle running default 10933


Create a project for day 2 operations and easy install of software.

* Linux Day2 Operations

## 1. Diagnostoics Runbook

Make a step for each

Diagnostics steps

```bash
echo "--- 1. SYSTEM IDENTITY & UPTIME ---"
hostnamectl | grep "Operating System\|Architecture"
uptime -p

echo -e "\n--- 2. STORAGE HEALTH ---"
# -x tmpfs excludes those annoying tiny system partitions you don't care about
df -h -x tmpfs -x devtmpfs

echo -e "\n--- 3. TOP 5 MEMORY HOGS ---"
# Shows the top 5 processes eating your RAM
ps -eo pid,ppid,cmd,%mem --sort=-%mem | head -6

echo -e "\n--- 4. SYSTEM ERRORS (Last 50) ---"
# --no-pager is critical so the Octopus task doesn't "hang" waiting for input
journalctl -p err -n 50 --no-pager

echo -e "\n--- 5. NETWORK INTERFACES ---"
ip -brief addr
```

DNS step

```bash
echo "--- DNS CONFIGURATION ---"
grep "nameserver" /etc/resolv.conf

echo -e "\n--- RESOLUTION STATUS ---"
resolvectl status | grep "DNS Servers\|Current DNS Server" || echo "Systemd-resolved not active."

echo -e "\n--- CONNECTIVITY TEST ---"
# Use a timeout so it doesn't hang, and || true to prevent script failure
timeout 2 getent hosts google.com || echo "Cannot resolve external domains."

# DNS is working, The phonebook is open.

# Traffic outbound is blocked or not?, but the phone line is cut?
echo -e "\n--- PING TEST (ba.no) ---"
# The '|| true' at the end tells Octopus: "Even if ping fails, the script is still a success"
ping -c 3 www.ba.no || echo "PING FAILED: This is expected on isolated machines."
# Force a clean exit so Octopus stays Green
exit 0

echo -e "\n--- TIME & SYNC STATUS ---"
timedatectl | grep "Local time\|System clock synchronized\|NTP service"
```

1 Diagnostics Runbook

![diagnostics_runbook](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/diagnostics_runbook.png)

## 2. Upload packet Runbook

The servers are running Ubuntu 24.04

Upload a packet example mysql 8.4

* https://dev.mysql.com/downloads/mysql/8.4.html
* mysql-server_8.4.8-1ubuntu24.04_amd64.deb-bundle.tar

Since you have the .tar bundle specifically for Ubuntu, you have everything you need for a "Side-Loaded" install. This bundle contains the server, the client, and all the mandatory internal libraries (like mysql-community-client, mysql-client, etc.) so they don't have to be downloaded from the internet.

![mysql_tar](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/mysql_tar.png)


On your internet-connected machine (your workstation):

1. Download the MySQL 8.4 LTS DEB Bundle for Ubuntu 24.04.
2. Extract the .tar file. You should see about 10–12 .deb files (server, client, common, etc.).
3. Zip these .deb files into a single file named MySQL-8.4-LTS.1.0.0.zip.
4. Upload this zip file to Projects-> Manage > Packages in your Octopus Server.

![mysql_pack](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/mysql_pack.png)

In Octopus on the runbook add a step, Deploy a Package up, find the mysql packet.

Do not use the version, the packet has a version from the zip file number: MySQL-8.4-LTS.1.0.0.zip

![mysql_pack_step_](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/mysql_pack_step_.png)

Save and run the runbook.

And now we have the packet for both vm in:

```bash
cd /etc/octopus/tentacle-name/Files
```


![mysql_pack_path](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/mysql_pack_path.png)

## 3 Renew SSL cert Runbook


### Install linux tentacle (this vm has internet access), AD DS must be running

```bash
sudo ufw status
Status: inactive
```
Create NSG with inbound 10933

Login and sudo nano install_tentacle.sh

```bash
#!/bin/bash
echo "Tea anyone?"
sudo apt update && sudo apt install --no-install-recommends gnupg curl ca-certificates apt-transport-https && \
sudo install -m 0755 -d /etc/apt/keyrings && \
curl -fsSL https://apt.octopus.com/public.key | sudo gpg --dearmor -o /etc/apt/keyrings/octopus.gpg && \
sudo chmod a+r /etc/apt/keyrings/octopus.gpg && \
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/octopus.gpg] https://apt.octopus.com/ \
  stable main" | \
  sudo tee /etc/apt/sources.list.d/octopus.list > /dev/null && \
sudo apt update && sudo apt install tentacle

```
Run it

```bash
sudo bash install_tentacle.sh
```

Configure it

```bash
/opt/octopus/tentacle/configure-tentacle.sh
```

Log

```log
Name of Tentacle instance (default Tentacle):vmzabbix03
What kind of Tentacle would you like to configure: 1) Listening or 2) Polling (default 1): 1
Where would you like Tentacle to store configuration, logs, and working files? (/etc/octopus):
Where would you like Tentacle to install applications to? (/home/Octopus/Applications):
Enter the port that this Tentacle will listen on (10933):
Should the Tentacle use a proxy to communicate with Octopus? (y/N): n
Enter the thumbprint of the Octopus Server: C6xxxxxxxxxxxxxxxxxxxxxxx
[...]
Saving instance: vmzabbix03
Setting home directory to: /etc/octopus/vmzabbix03
A new certificate has been generated and installed. Thumbprint:
C3xxxxxxxxxxxxxxxxxxxxxxxx
[...}]
Tentacle instance 'vmzabbix03' is now installed
```
In the octopus mananger portal we used, enter manual:

* Name, docker03getmirrortest
* Environment, development, tag docker03getmirrortest
* Tentacle URL https://vmhybrid01-public-ip:10934/
* Thumbprint that was generated on the target: C3xxxxxxxxxxxxxxxxxxxxxxxx

Test connectivity in octopus.

### Make SSL cert Runbook with folder, backup, new cert and key

Make a cert on vmzabbix03 (this vm has internet access) since it is running zabbix apache, then we can check the cert in browser if it has changed later.

Assuming we manually created certs and configured apache.

```bash
mkdir /etc/automation_cert

# and we ran
sudo openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
  -out vmzabbix03.crt -keyout vmzabbix03.key \
  -subj "/C=NO/ST=Hordaland/L=BER/O=Socrates.inc/OU=IT/CN=vmzabbix03"

# And apache is configured to use the certificates.
sudo nano /etc/apache2/sites-available/default-ssl.conf

# SSLCertificateFile    /etc/ssl/certs/vmzabbix03.crt
# SSLCertificateKeyFile /etc/ssl/private/vmzabbix03.key

```
Then we can start octopus the script process.

```bash
# Define the path
TARGET_DIR="/etc/automation_cert"

# 1. Check if the directory exists
if [ -d "$TARGET_DIR" ]; then
    echo "Directory $TARGET_DIR already exists."
else
    echo "Creating directory $TARGET_DIR..."
    # sudo may be required depending on your Octopus Worker/Target permissions
    mkdir -p "$TARGET_DIR"
fi

# 2. Change directory and list files containing 'automation'
cd /etc
echo "Checking for files/folders matching *automation* in /etc:"

# Use a conditional to avoid 'No such file or directory' errors from ls
if ls *automation* 1> /dev/null 2>&1; then
    ls -d *automation*
else
    echo "No files matching 'automation' were found."
fi

```

Then lets make a variable in octopus for the hostname.

1. From the Linux Day2 Operations you created earlier, click Project Variables in the left menu.
2. Click Create Variables.
3. Add Linux.vmzabbix in the Name column,
Add the vmzabbix03 (hostname), in the Value column,
4. Click the Scope column and  and a the same vmtag (no not select the Development/staging/production environment.)

Click Save.


Now add a new step, with making the cert and key using octopus var.

```bash
# 1. Setup Variables
CERT_DIR="/etc/automation_cert"
BACKUP_DIR="${CERT_DIR}/backups"
CERT_NAME="#{Linux.vmzabbix}"
CERT_SUBJ="/C=US/ST=NewYork/L=NYC/O=IT/CN=${CERT_NAME}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# 2. Ensure Directories Exist
sudo mkdir -p "$BACKUP_DIR"

# 3. Backup existing files if they exist
echo "Checking for existing files in $CERT_DIR..."
if [ -f "$CERT_DIR/${CERT_NAME}.crt" ] || [ -f "$CERT_DIR/${CERT_NAME}.key" ]; then
    echo "Existing files found. Moving to $BACKUP_DIR"
    
    # We use 'sudo cp' then 'sudo rm' or just 'sudo mv' 
    # Moving is cleaner as it clears the path for the new files
    [ -f "$CERT_DIR/${CERT_NAME}.crt" ] && sudo mv "$CERT_DIR/${CERT_NAME}.crt" "$BACKUP_DIR/${CERT_NAME}_${TIMESTAMP}.crt"
    [ -f "$CERT_DIR/${CERT_NAME}.key" ] && sudo mv "$CERT_DIR/${CERT_NAME}.key" "$BACKUP_DIR/${CERT_NAME}_${TIMESTAMP}.key"
    
    echo "Backup created: ${CERT_NAME}_${TIMESTAMP}"
else
    echo "No existing files to backup. Proceeding with fresh generation."
fi

# 4. Generate the NEW certificate
# We redirect stderr to stdout (2>&1) to avoid the red "Warning" lines in Octopus
echo "Generating new certificate for: $CERT_NAME"
sudo openssl req -newkey rsa:4096 \
  -x509 \
  -sha256 \
  -days 365 \
  -nodes \
  -out "$CERT_DIR/${CERT_NAME}.crt" \
  -keyout "$CERT_DIR/${CERT_NAME}.key" \
  -subj "$CERT_SUBJ" 2>&1

# 5. Set strict permissions
sudo chmod 644 "$CERT_DIR/${CERT_NAME}.crt"
sudo chmod 600 "$CERT_DIR/${CERT_NAME}.key"

# 6. Final Log
echo "Process complete. Files currently in $CERT_DIR:"
sudo ls -lh "$CERT_DIR" 

# 7. Check the cert (using the full path)
echo "Verifying the new certificate details:"
openssl x509 -noout -subject -startdate -enddate -in "$CERT_DIR/${CERT_NAME}.crt"

# 8 set permission
sudo chmod 755 /etc/ssl/private
echo "Verifying permissions for /etc/ssl/private..."
ls -ld /etc/ssl/private
```

The "red lines" and the warning in Octopus are happening because OpenSSL sends its progress indicators (the dots and plus signs) to stderr (Standard Error) instead of stdout (Standard Output).

The Fix: Redirect stderr to stdout, 2>&1  # red lines
To get a clean green checkmark without warnings, you can tell OpenSSL to merge its output so Octopus treats it as regular information.

And we have backups and the new cert and key.

![Cert created](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/cert_created.png)



## 3.1 Apache add new SSL cert Runbook

Assuming runbook 3 is completed, then we update with a new step.

```bash
pwd
# /etc/automation_cert
ls
backups  vmzabbix03.crt  vmzabbix03.key
```

And assuming /etc/apache2/sites-enabled/default-ssl.conf

```ini
SSLCertificateFile      /etc/ssl/certs/vmzabbix03.crt
SSLCertificateKeyFile   /etc/ssl/private/vmzabbix03.key
```

Swap the cert on vmzabbix01 that is running apache.

```bash
# 1. Setup paths
TARGET_DIR="/etc/automation_cert"
CERT_NAME="#{Linux.vmzabbix}"

# 2. Navigate and verify
cd "$TARGET_DIR" || exit 1
echo "Moving files from $(pwd)..."

# 3. Move/ copy files to official system locations
sudo cp "${CERT_NAME}.crt" "/etc/ssl/certs/${CERT_NAME}.crt"
# Fixed: ensured the extension stays .key
sudo cp "${CERT_NAME}.key" "/etc/ssl/private/${CERT_NAME}.key"

# 4. Set Permissions (Crucial for Apache access)
sudo chown root:www-data "/etc/ssl/private/${CERT_NAME}.key"
sudo chmod 640 "/etc/ssl/private/${CERT_NAME}.key"

# 5. Test Apache configuration before restarting
echo "Testing Apache configuration..."

# Redirect stderr (2) to stdout (1) so "Syntax OK" isn't red in Octopus
if sudo apachectl configtest 2>&1; then
    echo "Config confirmed OK. Restarting Apache..."
    # 6. Restart
    sudo systemctl restart apache2
    echo "Apache restarted successfully."
else
    echo "Apache config test FAILED! Check the logs above."
    exit 1
fi

# 7. Force a clean exit
exit 0
```

![Cert new](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/cert_new.png)

## That completes the basic for now

For install software go to: 

* README_octo_linux_runbook_install_software.md


# 4. Upload packet versions and working with vars (2. Upload packet Runbook extended)

Lets work some more with uploading files and working with vars.
We did earlier, 2. Upload packet Runbook

The servers are running Ubuntu 24.04

Upload a packet example mysql 8.4

* https://dev.mysql.com/downloads/mysql/8.4.html
* mysql-server_8.4.8-1ubuntu24.04_amd64.deb-bundle.tar

Since you have the .tar bundle specifically for Ubuntu, you have everything you need for a "Side-Loaded" install. This bundle contains the server, the client, and all the mandatory internal libraries (like mysql-community-client, mysql-client, etc.) so they don't have to be downloaded from the internet.

![mysql_tar](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/mysql_tar.png)


On your internet-connected machine (your workstation):

1. Download the MySQL 8.4 LTS DEB Bundle for Ubuntu 24.04.
2. Extract the .tar file. You should see about 10–12 .deb files (server, client, common, etc.).
3. Zip these .deb files into a single file named MySQL-8.4-LTS.1.0.0.zip.
4. Upload this zip file to Projects-> Manage > Packages in your Octopus Server.

![mysql_pack](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/mysql_pack.png)

In Octopus on the runbook add a step, Deploy a Package up, find the mysql packet.

Do not use the version, the packet has a version from the zip file number: MySQL-8.4-LTS.1.0.0.zip

![mysql_pack_step_](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/mysql_pack_step_.png)

Save and run the runbook.

And now we have the packet for both vm in:

```bash
cd /etc/octopus/tentacle-name/Files
```


![mysql_pack_path](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/mysql_pack_path.png)

## 4.1 Upload a text file and edit versions

Goal

* Upload a zipped text file to octopus with a version number myfile.txt.1.0.0
* Deploy with step Upload the packet to server

* Grap the packet with octopus variable and cat the content

Inspect the packet version and content.

* Edit the text file, zip it to new version
* Deploy with  a step Upload a zipped text file to octopus with a version number myfile.txt.1.0.1

* Grap the packet with octopus variable and cat the new content

* Edit the text file, zip it to new version
* Deploy with  a step Upload a zipped text file to octopus with a version number myfile.txt.1.0.2

* Grap the packet with octopus variable and cat the new content



