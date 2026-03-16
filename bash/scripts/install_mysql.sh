#!/bin/bash

# sudo chmod +x secure_mysql.sh
# sudo ./secure_mysql.sh
# tested on ubuntu 24.04

# Ensure we are running as root
if [ "$EUID" -ne 0 ]; then 
  echo "Please run as sudo"
  exit
fi

export DEBIAN_FRONTEND=noninteractive

echo "1. Updating repositories..."
apt-get update -y > /dev/null

echo "2. Installing MySQL Server..."
apt-get install -y mysql-server > /dev/null

echo "3. Starting MySQL service..."
systemctl start mysql
systemctl enable mysql

echo "4. Running Security Hardening..."
mysql <<EOF
-- Remove anonymous users
DELETE FROM mysql.user WHERE User='';
-- Disallow root login remotely
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
-- Remove test database and access to it
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
-- Reload privilege tables
FLUSH PRIVILEGES;
EOF

echo "-----------------------------------------------"
echo "SUCCESS: MySQL is installed and secured."
mysql --version
systemctl status mysql | grep "Active:"
echo "-----------------------------------------------"

# ==============================================================================
# HOW TO USE THIS INSTALLATION
# ==============================================================================
# 
# 1. LOCAL LOGIN (Root):
#    Ubuntu uses the 'auth_socket' plugin by default for root. 
#    You do not need a password; you just need sudo:
#    $ sudo mysql
#
# 2. CREATE A DATABASE USER (Recommended for Apps):
#    $ sudo mysql
#    mysql> CREATE USER 'myuser'@'localhost' IDENTIFIED BY 'password123';
#    mysql> GRANT ALL PRIVILEGES ON *.* TO 'myuser'@'localhost' WITH GRANT OPTION;
#
# 3. CHECK LISTENING PORT (Default 3306):
#    $ sudo ss -tulpn | grep mysql
#
# ==============================================================================
# HOW TO UNINSTALL (THE "CLEAN SLATE" METHOD)
# ==============================================================================
#
# If you want to completely remove MySQL and all its data/configs:
#
# 1. Stop the service:
#    $ sudo systemctl stop mysql
#
# 2. Remove packages and configs:
#    $ sudo apt-get purge -y mysql-server mysql-client mysql-common mysql-server-core-* mysql-client-core-*
#
# 3. Remove leftover directories (CAUTION: This deletes all databases!):
#    $ sudo rm -rf /etc/mysql /var/lib/mysql /var/log/mysql
#
# 4. Clean up unused dependencies:
#    $ sudo apt-get autoremove -y
#    $ sudo apt-get autoclean
# ==============================================================================
