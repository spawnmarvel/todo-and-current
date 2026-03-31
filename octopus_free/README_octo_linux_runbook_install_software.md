# Insstall software with Octopus runbooks

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

## 4.1 Install MySql Runbook (do manual first) todo

```bash
#!/bin/bash
# 1. Setup Variables
PACKAGE_NAME="MySQL-8@S4-LTS.1.0.0@2e61ae8.zip"
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

Then move it to octopus

## 5 (Upgrade MySql Runbook) or go direct to 8.4?

Here we use apt-get, variables and we have a downloaded MySql 8.4 packet

## 6 Zabbix stack (MySql is in a different runbook) Runbook 

Install the zabbix stack on a vm where mysql is already installed.