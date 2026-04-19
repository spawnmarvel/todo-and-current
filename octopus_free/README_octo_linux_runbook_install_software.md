# Install software with Octopus runbooks

## Table of Contents

- [Install software with Octopus runbooks](#install-software-with-octopus-runbooks)
  - [Table of Contents](#table-of-contents)
  - [4.1 Check MySQL and zabbix installed](#41-check-mysql-and-zabbix-installed)
  - [4.1 Install MySql Runbook](#41-install-mysql-runbook)
    - [Step 1 upload the packet](#step-1-upload-the-packet)
    - [Step 2 Upload unzip and install if needed](#step-2-upload-unzip-and-install-if-needed)
    - [Step 3 Install zip and MySql 8.4](#step-3-install-zip-and-mysql-84)
  - [4.2 Uinstall MySql Runbook](#42-uinstall-mysql-runbook)
  - [5 Zabbix stack (MySql is in a different runbook) Runbook](#5-zabbix-stack-mysql-is-in-a-different-runbook-runbook)

## 4.1 Check MySQL and zabbix installed

We will only install it at one vm, the offline vm first.

* docker03getmirrortest
* 172.64.0.5


Lets make a short runbook for checking what is installed, so we don't break anything.

```bash

echo "=== SYSTEM AUDIT: $(hostname) ==="

# 1. Check OS Version (Confirming Ubuntu 24.04 Noble)
echo "--- OS VERSION ---"
lsb_release -a | grep Description

# 2. Check for existing MySQL/MariaDB (The "Conflict" Check)
echo "--- DATABASE CHECK ---"
if dpkg -l | grep -E "mysql|mariadb|percona" > /dev/null; then
    echo "[!] WARNING: Existing Database packages found:"
    dpkg -l | grep -E "mysql|mariadb|percona" | awk '{print $2, $3}'
else
    echo "[OK] No Database engines detected."
fi

# 3. Check for Zabbix (The "Safety" Check)
echo "--- MONITORING CHECK ---"
if dpkg -l | grep "zabbix" > /dev/null; then
    echo "[!] WARNING: Zabbix components detected!"
    dpkg -l | grep "zabbix" | awk '{print $2, $3}'
else
    echo "[OK] No Zabbix software found."
fi

# 4. Check for Required Tools (Unzip is needed for your Octopus Bundle)
echo "--- TOOLING CHECK ---"
for tool in unzip wget curl tar; do
    if command -v $tool >/dev/null 2>&1; then
        echo "[OK] $tool is installed."
    else
        echo "[MISSING] $tool is NOT installed."
    fi
done

echo "=== AUDIT COMPLETE ==="
```

Log after running the runbook

```log
=== SYSTEM AUDIT: docker03getmirrortest === 
--- OS VERSION --- 
Description:	Ubuntu 24.04.3 LTS 
--- DATABASE CHECK --- 
[OK] No Database engines detected. 
--- MONITORING CHECK --- 
[!] WARNING: Zabbix components detected! 
zabbix-agent2 1:7.0.22-1+ubuntu24.04 
zabbix-release 1:7.0-2+ubuntu24.04 
--- TOOLING CHECK --- 
[MISSING] unzip is NOT installed. 
[OK] wget is installed. 
[OK] curl is installed. 
[OK] tar is installed. 
=== AUDIT COMPLETE === 
```
## 4.1 Install MySql Runbook

The log from check software runbook:

[MISSING] unzip is NOT installed. 

We will only install it at one vm, the offline vm first as test

Since the VM is offline (no internet access), you are performing what is called an "Air-gapped" installation.

* docker03getmirrortest
* 172.64.0.5


### Step 1 upload the packet

We created a step 1.Deploy a Package Mysql 8.4 the packet was uploaded in the operations tutorial.

Log

```
Deploying package:    /etc/octopus/docker03getmirrortest/Files/MySQL-8@S4-LTS.1.0.0@3dce64d.zip
```

We also need a extra packet, the unzip

* Go to packages.ubuntu.com.
* https://launchpad.net/ubuntu/noble/+source/unzip
* Download the unzip .deb for amd64.

On the page you are looking at right now:

Look for the header "Binary packages".

Click the word unzip next to (amd64).

On the next page, look at the top right corner under "Downloadable files".

There it is! The file will be named: unzip_6.0-28ubuntu4.1_amd64.deb.

Zip the file:

* unzip_6.0-28ubuntu4.1_amd64.deb
* zip the file to unzip_6.0-28.zip
* Upload that .deb to your Octopus package or directly to /etc/octopus/docker03getmirrortest/Files/

### Step 2 Upload unzip and install if needed

Deploy a Package

1.Deploy a Package Mysql 8.4

Deploy a Package

2.Deploy a Package Unzip

Run a Script

3.Run a Script Install unzip if needed


```bash
#!/bin/bash
# 1. Setup paths
SOURCE_DIR="/etc/octopus/$(hostname)/Files"
EXTRACT_DIR="/tmp/unzip_bootstrap"

echo "--- 1. CHECKING FOR UNZIP ---"
if command -v unzip >/dev/null; then
    echo "[OK] Unzip already exists."
else
    echo "[!] Unzip missing. Extracting using Python..."
    mkdir -p "$EXTRACT_DIR"
    
    # Find the unzip zip regardless of the long Octopus string
    UNZIP_ZIP=$(find "$SOURCE_DIR" -name "unzip_6*.zip" | head -n 1)
    
    if [ -n "$UNZIP_ZIP" ]; then
        sudo python3 -m zipfile -e "$UNZIP_ZIP" "$EXTRACT_DIR"
        # Find the .deb inside and install
        DEB_FILE=$(find "$EXTRACT_DIR" -name "*.deb" | head -n 1)
        sudo dpkg -i "$DEB_FILE"
        sudo rm -rf "$EXTRACT_DIR"
    else
        echo "ERROR: unzip zip not found in $SOURCE_DIR"
        exit 1
    fi
fi
```

Log

```log
--- 1. CHECKING FOR UNZIP --- 
[!] Unzip missing. Extracting using Python... 
Selecting previously unselected package unzip. 
(Reading database ... 97411 files and directories currently installed.) 
Preparing to unpack .../unzip_6.0-28ubuntu4.1_amd64.deb ... 
Unpacking unzip (6.0-28ubuntu4.1) ... 
Setting up unzip (6.0-28ubuntu4.1) ... 
Processing triggers for man-db (2.12.0-4build2) ... 
```
unzip is now officially a live command on your server.

### Step 3 Install zip and MySql 8.4

```bash
#!/bin/bash
# 1. Setup Variables
PACKAGE_NAME=(MySql-8*.zip)
VM_NAME=$(hostname)
SOURCE_DIR="/etc/octopus/$VM_NAME/Files"
WORK_DIR="/tmp/mysql_install"

# 2. Prevent Interactive Prompts (The "Silent" Secret)
export DEBIAN_FRONTEND=noninteractive

echo "--- PRE-CONFIGURING PASSWORDS ---"
# Pre-set the root password so the installer doesn't hang waiting for input
echo "mysql-community-server mysql-community-server/root-pass password YourStrongPassword123!" | sudo debconf-set-selections
echo "mysql-community-server mysql-community-server/re-root-pass password YourStrongPassword123!" | sudo debconf-set-selections

echo "--- UNPACKING BUNDLE ---"
# 3. Create work dir and unzip
sudo mkdir -p $WORK_DIR
sudo cp "$SOURCE_DIR/$PACKAGE_NAME" $WORK_DIR/
cd $WORK_DIR
sudo unzip -o $PACKAGE_NAME

echo "--- INSTALLING DEBS ---"
# 4. Install all .deb files found in the zip
# We use *.deb so it catches the server, client, and common libs in the right order
sudo dpkg -i *.deb

# 5. Fix any dependency gaps using the internet connection
# This will grab things like libaio1 or libmecab2 automatically
sudo apt-get install -f -y

echo "--- CLEANING UP ---"
sudo systemctl enable mysql
sudo systemctl start mysql
cd /
sudo rm -rf $WORK_DIR

echo "--- VERIFICATION ---"
mysql --version
systemctl is-active mysql
```

Test it first on server

```bash
sudo nano install_mysql_8_4.sh
bash install_mysql_8_4.sh
```

## 4.2 Uinstall MySql Runbook


## 5 Zabbix stack (MySql is in a different runbook) Runbook 

Install the zabbix stack.

We will create a new ubuntu vm for this.

* The vm will be offline, no internet access.
* VM will use the AD DS server with port proxy for inbound.
* First we install MySql 8.4
* Then we install Zabbix stack with apache
