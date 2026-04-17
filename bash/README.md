# Bash Quick Guide

> A comprehensive reference for Linux/Bash fundamentals, commands, and scripting.

---

## Table of Contents

1. [Linux Philosophy](#linux-philosophy)
2. [Man Pages](#man-pages)
3. [Python & PowerShell vs Bash](#python--powershell-vs-bash)
4. [Bash Strict Mode](#bash-strict-mode)
5. [Quick Reference Cards](#quick-reference-cards)
6. [Basic Commands](#basic-commands)
7. [Text Processing](#text-processing)
8. [System Monitoring](#system-monitoring)
9. [Networking](#networking)
10. [File Compression](#file-compression)
11. [File Permissions](#file-permissions)
12. [Bash Scripting](#bash-scripting)
13. [Practical Examples](#practical-examples)
14. [Troubleshooting](#troubleshooting)

---

## Linux Philosophy

In Linux, the **"everything is a file"** philosophy means that nearly all system resources—hardware devices, processes, directories, and network sockets—are represented as data streams within the file system.

| Concept | Description |
|---------|-------------|
| **Unified Interface** | Hardware (e.g., hard drives, mice) is represented as files in `/dev` |
| **File Descriptor Abstraction** | Kernel abstracts resources into file descriptors |
| **Virtual Filesystem** | `/proc` and `/sys` represent kernel data structures as files |

---

## Man Pages

```bash
# View manual for a specific command
man cp
man grep
man awk

# Search man pages by keyword (equivalent to apropos)
man -k copy
man -k security
man -k file
man -k text
man -k network
```

---

## Python & PowerShell vs Bash

### The 3 Core Differences

| Aspect | Python/PowerShell | Bash |
|--------|-------------------|------|
| **Data Model** | Native objects (dictionaries, lists, objects) | Everything is text streams |
| **Execution** | Script stays in memory, manages state | Each command creates a new process |
| **Error Handling** | try...except / Try...Catch | Silent failures by default |

### 1. Everything is a String

- **Python/PowerShell**: Handle complex data structures natively, pass objects between functions
- **Bash**: Everything is text. Process data using `grep`, `sed`, `awk`, or `cut`

> **Analogy**: In Python, you have a `User` object with `.name`. In Bash, you have a line of text you must slice with regex.

### 2. The "Process" Model

- **Python**: Script stays in memory, manages its own state
- **Bash**: Each command creates a new process (sub-shell or fork). Variable scope and file descriptors feel more fragile.

### 3. Error Handling

- **Python**: Uses `try...except` blocks
- **PowerShell**: Uses `Try...Catch` and `ErrorActionPreference`
- **Bash**: By default, continues on failure — the #1 trap for beginners!

![bash_table](https://github.com/spawnmarvel/todo-and-current/blob/main/images/bash_table.png)

---

## Bash Strict Mode

> ⚠️ **Pro-Tip**: Always add this at the top of your scripts!

```bash
#!/bin/bash
set -euo pipefail
# -e: Exit immediately if a command exits with non-zero status
# -u: Treat unset variables as an error
# -o pipefail: Catch errors in piped commands
```

---

## Quick Reference Cards

![Quick 1](https://github.com/spawnmarvel/linux-and-azure/blob/main/images/page1.jpg)

![Quick 2](https://github.com/spawnmarvel/linux-and-azure/blob/main/images/page2.jpg)

> 📄 [Download PDF Reference](https://github.com/spawnmarvel/quickguides/blob/main/bash/bash.quickref.pdf)

---

## Basic Commands

### File & Directory Operations

| Command | Description |
|---------|-------------|
| `ls` | List directory contents |
| `ls -a` | List hidden files |
| `ls *pattern*` | List files matching pattern |
| `cd` | Change directory |
| `pwd` | Print working directory |
| `echo` | Display text |
| `cat` | Concatenate and display files |
| `cp` | Copy files/directories |
| `mv` | Move or rename files |
| `rm` | Delete files |
| `rm -r` | Delete directory recursively |
| `touch` | Create empty file or update timestamp |
| `mkdir` | Create directory |

```bash
# Example
ls -la
ls *apt-main*          # returns apt-maintenance-2026-01-31.log
rm -r zabbix_agent2.d/ # remove folder recursively
```

---

## Text Processing

### grep - Pattern Matching

```bash
# Basic usage
grep '"'"'pattern'"'"' filename
grep -i '"'"'search_term'"'"' file.txt      # Case insensitive
grep -r '"'"'search_term'"'"' /path         # Recursive search
grep -v '"'"'search_term'"'"' file.txt      # Invert match

# Regex patterns
grep -i '"'"'error'"'"' syslog              # Contains "error"
grep -i '"'"'heartbeat.*error'"'"' syslog   # "heartbeat" then anything then "error"
```

### awk - Field Processing

```bash
# -F: Field separator, -v: Variable
awk -F";" '"'"'{print $1}'"'"' data.txt     # Print 1st field (semicolon-delimited)
awk -F";" -v var="Name:" '"'"'{print var, $2}'"'"' data.txt
awk -F";" '"'"'{sum += $3} END {print sum}'"'"' data.txt  # Sum column 3
```

### sed - Stream Editor

```bash
# sed '"'"'s/old/new/'"'"' filename
sed '"'"'s/espen/jim/'"'"' data.txt         # Replace first occurrence
sed -i '"'"'s/espen/jim/g'"'"' data.txt     # Replace all (in-place)
sed '"'"'s/old/new/'"'"' file > newfile     # Redirect output
```

### cut - Extract Fields

```bash
cut -f1 -d'"'"';'"'"' data.txt              # First field
cut -f1-2 -d'"'"';'"'"' data.txt            # Fields 1-2
```

### Other Utilities

```bash
sort file.txt                       # Sort lines
tail -f /var/log/syslog             # Follow log
tail -n 2 /var/log/syslog           # Last 2 lines
head -n 10 /var/log/syslog          # First 10 lines
diff file1.txt file2.txt            # Compare files
```

---

## System Monitoring

### Process Management

```bash
ps -e                               # Show all processes
ps -ef                              # Detailed output
ps -u username                      # Processes for specific user
ps -u zabbix                        # Example: zabbix user processes

top -d 5                            # Update every 5 seconds
top -p 1010                         # Monitor specific PID
top -u zabbix                       # User-specific processes

kill -9 1234                        # Force kill process
kill -l                             # List all signals
```

### Disk & Memory

```bash
df -h                               # Disk usage (human-readable)
df -h /datadrive                    # Specific mount point

du -h                               # File space usage
du -h --max-depth=1                 # Summary per directory

free -h                             # Memory usage
free -h -s 5                        # Update every 5 seconds

uptime                              # System uptime
```

---

## Networking

### Connectivity

```bash
ping hostname                       # Test connectivity
ping 10.70.1.43                     # IP address ping

# Edit /etc/hosts for hostname resolution
sudo nano /etc/hosts
# Add: 10.70.1.43  e1-x-mysql01
```

### File Transfer

```bash
# curl - download files
curl -O https://example.com/file    # Save with original name
curl -L https://example.com         # Follow redirects
curl -I https://example.com         # Fetch headers only

# wget - non-interactive downloader
wget https://example.com/file

# scp - secure copy
scp file.txt user@host:/path/

# rsync - efficient sync (only transfers changes)
rsync -avz source/ destination/
rsync -avz localdir user@host:/path/
```

### Network Info

```bash
ip addr                             # Show interfaces
ip a                                # Short form
hostname -I                         # Get IP address
```

### Firewall (UFW)

> See [UFW Firewall Guide](https://github.com/spawnmarvel/linux-and-azure/tree/main/ufw-firewall)

---

## File Compression

### zip/unzip

```bash
# Install if needed
sudo apt install zip

# Compress
zip test.zip file1.txt file2.txt
zip -r archive.zip directory/

# Extract
unzip test.zip
unzip archive.zip -d /target/dir/
```

### tar

```bash
# Create archive
tar -cvf archive.tar file1.txt file2.txt
tar -cvzf archive.tar.gz directory/    # With gzip compression

# List contents
tar -tvf archive.tar

# Extract
tar -xvf archive.tar
tar -xvzf archive.tar.gz
```

---

## File Permissions

### Permission Codes

| Code | Permission |
|------|-------------|
| `0` | No permission |
| `1` | Execute |
| `2` | Write |
| `3` | Write + Execute |
| `4` | Read |
| `5` | Read + Execute |
| `6` | Read + Write |
| `7` | Read + Write + Execute |

> **Example**: `755` = owner can rwx, group/others can rx

### Commands

```bash
# View permissions
ls -l file.txt
ls -ld directory/
stat -c '"'"'%a'"'"' file.txt               # Numeric format

# Change permissions
chmod 755 script.sh                 # Numeric
chmod +x script.sh                  # Add execute
chmod -R 755 directory/             # Recursive

# Change owner
sudo chown user:group file.txt

# Change group
sudo chgrp groupname file.txt

# Add user to group
sudo usermod -aG groupname username
```

### Permission String Format

```
- rw- r-- r--
| |  |  |
| |  |  +-- Others (read)
| |  +----- Group (read)
| +-------- Owner (read/write)
+---------- File type (- = file, d = directory)
```

---

## Bash Scripting

### 01. Scripting Basics

```bash
#!/bin/bash
# Comment
echo "Hello, World"

# Multiple commands on one line
echo "first"; echo "second"

# Make executable and run
chmod +x script.sh
./script.sh
```

### 02. Variables & Operations

```bash
# Variable assignment
name="John"
number=42

# Command substitution
current_dir=$(pwd)
echo $current_dir

# Environment variables
echo "PATH: $PATH"

# Arithmetic
sum=$((10 + 5))
echo "Sum: $sum"
```

### 03. Data Types & Arrays

```bash
# Strings
greeting="Hello"
name="World"
echo "$greeting, $name"

# Numbers
num1=5
num2=2
echo "Sum: $((num1 + num2))"

# Array (indexed)
fruits=("apple" "banana" "cherry")
echo ${fruits[0]}           # First element
echo ${fruits[@]}           # All elements

# Associative array (requires Bash 4+)
declare -A user
user[name]="John"
user[age]="30"
echo ${user[name]}
```

### 04. Operators

```bash
# Numeric comparison
[ $a -eq $b ]   # Equal
[ $a -ne $b ]   # Not equal
[ $a -lt $b ]   # Less than
[ $a -le $b ]   # Less or equal
[ $a -gt $b ]   # Greater than
[ $a -ge $b ]   # Greater or equal

# String comparison
[ "$a" = "$b" ]         # Equal
[ "$a" != "$b" ]        # Not equal
[ -z "$a" ]             # Empty string

# File tests
[ -e file ]             # Exists
[ -d dir ]              # Is directory
[ -f file ]             # Is regular file
[ -s file ]             # Not empty

# Logical operators
[ $a -gt 5 ] && [ $a -lt 10 ]
[ $a -gt 5 ] || [ $a -eq 0 ]
```

### 05. Control Flow

```bash
# if/elif/else
if [ $a -gt 10 ]; then
    echo "Greater than 10"
elif [ $a -eq 10 ]; then
    echo "Equal to 10"
else
    echo "Less than 10"
fi

# case statement
case $variable in
    value1)
        echo "Case 1"
        ;;
    value2)
        echo "Case 2"
        ;;
    *)
        echo "Default"
        ;;
esac
```

### 06. Loops

```bash
# For loop
for i in {1..5}; do
    echo "Iteration $i"
done

# For loop with array
for item in "${array[@]}"; do
    echo $item
done

# While loop
count=1
while [ $count -le 5 ]; do
    echo "Count: $count"
    ((count++))
done

# Until loop
count=1
until [ $count -gt 5 ]; do
    echo "Count: $count"
    ((count++))
done

# Break and continue
for i in {1..5}; do
    if [ $i -eq 3 ]; then
        continue    # Skip iteration
    fi
    echo $i
    if [ $i -eq 4 ]; then
        break       # Exit loop
    fi
done
```

### 07. Functions

```bash
# Basic function
my_function() {
    echo "Hello from function"
}
my_function

# Function with parameters
greet() {
    local name=$1
    echo "Hello, $name!"
}
greet "World"

# Function with return value
add() {
    local sum=$(($1 + $2))
    echo $sum
}
result=$(add 5 3)
echo "Result: $result"
```

### 08. Arrays

```bash
# Declare array
my_array=("val1" "val2" "val3")

# Access elements
echo ${my_array[0]}      # First element
echo ${my_array[@]}      # All elements
echo ${#my_array[@]}     # Array length

# Modify elements
my_array[1]="new_val"

# Add elements
my_array+=("val4")

# Delete element
unset my_array[1]
```

### 09. Cron Jobs

```bash
# Cron syntax: minute hour day month weekday command
# * * * * * command
# | | | | |
# | | | | +-- Day of week (0-7, 0 and 7 are Sunday)
# | | | +---- Month (1-12)
# | | +------ Day of month (1-31)
# | +-------- Hour (0-23)
# +---------- Minute (0-59)

# Examples
0 * * * * /path/to/script.sh    # Every hour
*/5 * * * * /path/to/script.sh  # Every 5 minutes
0 0 * * * /path/to/script.sh    # Daily at midnight

# View crontab
crontab -l

# Edit crontab
crontab -e
```

---

## Additional Resources

- [W3Schools Bash Tutorial](https://www.w3schools.com/bash/)
- [Bash Reference Manual](https://www.gnu.org/software/bash/manual/)
- [Linux Command Line Basics](https://github.com/spawnmarvel/quickguides)

---

## Practical Examples

### UFW Firewall

```bash
# Check status
sudo ufw status
sudo ufw status verbose

# Enable/Disable
sudo ufw enable
sudo ufw disable

# Allow/Block connections
sudo ufw allow 22          # Allow SSH
sudo ufw allow 80          # Allow HTTP
sudo ufw allow 443         # Allow HTTPS
sudo ufw allow 3306        # Allow MySQL
sudo ufw allow 10050       # Allow Zabbix agent
sudo ufw allow 10051       # Allow Zabbix server

# Allow by service name
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https

# Block connections
sudo ufw deny 8080

# Remove rules
sudo ufw delete allow 22
sudo ufw delete allow http

# Allow from specific IP
sudo ufw allow from 192.168.1.100

# Allow specific port from IP
sudo ufw allow from 192.168.1.100 to any port 22

# Reload rules
sudo ufw reload

# Reset to defaults
sudo ufw reset
```

> See [UFW Firewall Guide](https://github.com/spawnmarvel/linux-and-azure/tree/main/ufw-firewall) for more details

---

### SCP: Windows to Linux (.deb install)

```bash
# x64 (also known as x86_64 or amd64)
# ARM (also known as aarch64 or arm64)

# When you install a deb, try to find the deb that has all other packets
# otherwise you must install dependencies
# https://octopus.com/downloads/tentacle/7.1.31#linux

# PowerShell copy to Linux (SCP uses TCP Port 22)
scp '.\Octopus Linux\tentacle_7.1.31_amd64.deb' username@ubuntu-ip:/tmp/

# SSH to Linux
ssh username@ubuntu-ip
cd /tmp/
ls
cp /tmp/tentacle_7.1.31_amd64.deb tentacle_7.1.31_amd64.deb

sudo dpkg -i tentacle_7.1.31_amd64.deb

# Configure Tentacle
/opt/octopus/tentacle/configure-tentacle.sh

# Verify installation
which Tentacle
dpkg -l | grep tentacle

# Stop service before removal
sudo systemctl stop octopus-tentacle

# Remove
sudo apt remove octopus-tentacle    # Removes binaries, keeps config
sudo apt purge octopus-tentacle     # Removes everything
sudo dpkg -r octopus-tentacle       # Offline way
```

---

### Update & Upgrade / Apt Install & Remove

```bash
sudo apt update -y                  # Update apt/sources
sudo apt list --upgradable          # List possible upgrades
sudo apt upgrade -y                 # Do upgrade

# View apt sources
cd /etc/apt/
ls -lh
cat ubuntu.sources

# Install Zabbix Agent 2
wget https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.0+ubuntu24.04_all.deb
sudo dpkg -i zabbix-release_latest_7.0+ubuntu24.04_all.deb
sudo apt update -y
sudo apt install zabbix-agent2

# Other examples
sudo apt list --installed | grep -i 'influx*'
sudo apt search 'influxdb'
sudo apt install snmp
which snmp
sudo apt remove snmp
history
dpkg
```

---

### Hello World Bash Script with Chmod

```bash
nano demo.sh

#!/bin/bash
echo "Hello World!"

# Check permissions
ls -l demo.sh

# Add execute permission
chmod u+x demo.sh
# or octal
chmod 744 demo.sh

# Run
./demo.sh

# List all users
cat /etc/passwd
```

---

### Sudo Delay Fix (Hostname Resolution)

```bash
hostname
# vmchaos09

sudo nano /etc/hosts
# Change from:
127.0.0.1 localhost
# To:
127.0.0.1 localhost vmchaos09
::1       localhost ip6-localhost ip6-loopback vmchaos09
```

---

### SSH Key Generation

```bash
# Check existing keys
cd ~/.ssh

# Generate new key pair
ssh-keygen -t ed25519
# or with custom name and comment
ssh-keygen -t ed25519 -C "myname" -f ~/.ssh/octopus_key

# View public key
cat ~/.ssh/id_ed25519.pub

# Copy to remote server
ssh-copy-id username@server-ip

# Or manually:
mkdir -p ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
nano ~/.ssh/authorized_keys
# Paste public key
```

---

### OpenSSL: Generate Self-Signed Certificate

```bash
sudo openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
  -out server.crt -keyout server.key \
  -subj "/C=NO/ST=Hordaland/L=BER/O=Socrates.inc/OU=IT/CN=vm01.socrates.inc"

# Verify certificate
openssl x509 -noout -subject -dates -in server.crt
openssl x509 -noout -text -in server.crt
```

---

### Apache SSL Setup (Ubuntu 24.04)

```bash
# Create self-signed certificate (3650 days)
sudo openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
  -keyout /etc/ssl/private/zabbix-selfsigned.key \
  -out /etc/ssl/certs/zabbix-selfsigned.crt

# Enable SSL module and default site
sudo a2enmod ssl
sudo a2ensite default-ssl

# Edit SSL config
sudo nano /etc/apache2/sites-enabled/default-ssl.conf
# Update:
SSLCertificateFile    /etc/ssl/certs/zabbix-selfsigned.crt
SSLCertificateKeyFile /etc/ssl/private/zabbix-selfsigned.key

# Force HTTPS redirect
sudo nano /etc/apache2/sites-available/000-default.conf
# Add inside <VirtualHost *:80>:
RewriteEngine On
RewriteCond %{HTTPS} off
RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]

sudo a2enmod rewrite
sudo systemctl restart apache2
```

---

### Debmirror (Local Package Repository)

```bash
sudo apt update
sudo apt install debmirror
sudo apt install apache2
sudo apt install gnupg
sudo systemctl enable apache2
sudo systemctl status apache2
```

---

### Install MySQL 8.4 Offline (SCP + dpkg)

```bash
# 1. Download on Host (with internet)
wget https://dev.mysql.com/get/Downloads/MySQL-8.4/mysql-server_8.4.0-1ubuntu24.04_amd64.deb-bundle.tar
wget http://archive.ubuntu.com/ubuntu/pool/main/m/mecab/libmecab2_0.996-14build9_amd64.deb

# 2. Transfer via SCP
scp mysql-server_8.4.0-1ubuntu24.04_amd64.deb-bundle.tar username@vm-ip:/tmp/
scp libmecab2_0.996-14build9_amd64.deb username@vm-ip:/tmp/

# 3. Extract and install
cd /tmp
tar -xvf mysql-server_8.4.0-1ubuntu24.04_amd64.deb-bundle.tar
rm -f mysql-community-test*.deb mysql-testsuite*.deb
rm -f mysql-community-server-debug*.deb mysql-community-test-debug*.deb

sudo dpkg -i libmecab2_*.deb
sudo dpkg -i mysql-*.deb

# 4. Set root password
sudo mysql
ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'admin4561';
FLUSH PRIVILEGES;

# Create regular user
CREATE USER 'johnwick'@'%' IDENTIFIED BY 'YourUserPassword123!';
GRANT ALL PRIVILEGES ON *.* TO 'johnwick'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

# 5. Secure installation
sudo mysql_secure_installation

# 6. Allow remote access
sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
# Change: bind-address = 0.0.0.0
sudo systemctl restart mysql
sudo netstat -plnt | grep 3306
```

---

### Mount Data Drive (fdisk) Ubuntu 24.04

```bash
# Find the disk
lsblk -o NAME,HCTL,SIZE,MOUNTPOINT | grep -i "sd"

# Create partition
sudo fdisk /dev/sda
# Commands: g (GPT), n (new), enter, enter, w (write)

# Format partition
sudo mkfs.ext4 /dev/sda1

# Create directory and mount
sudo mkdir -p /datadrive
sudo mount /dev/sda1 /datadrive

# Make permanent (fstab)
sudo blkid /dev/sda1
# Copy UUID
sudo nano /etc/fstab
# Add: UUID=your-uuid-here /datadrive ext4 defaults,nofail 0 2

# Set ownership
sudo chown $USER:$USER /datadrive

# Verify
lsblk -o NAME,SIZE,MOUNTPOINT | grep "sd"
```

---

### Move MySQL Data Directory

```bash
# Check current path
mysql -u root -p -e "SELECT @@datadir"

# Stop MySQL
sudo systemctl stop mysql

# Create new directory
sudo mkdir -p /datadrive/mysql
sudo chown mysql:mysql /datadrive/mysql
sudo chmod 750 /datadrive/mysql

# Backup and copy
sudo mv /var/lib/mysql /var/lib/mysql_old
sudo rsync -av /var/lib/mysql/ /datadrive/mysql/

# Update config
sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
# Change: datadir = /datadrive/mysql

# Fix AppArmor
sudo nano /etc/apparmor.d/tunables/alias
# Add: alias /var/lib/mysql/ -> /datadrive/mysql/,
sudo systemctl restart apparmor

# Allow MySQL to access parent
sudo chmod +x /datadrive

# Start MySQL
sudo systemctl start mysql

# Verify
mysql -u root -p -e "SELECT @@datadir"
```

---

## Troubleshooting

### Disk, Big Files, and Journalctl

```bash
# Check disk
df -h /

# Find large directories
sudo du -ah / 2>/dev/null | sort -rh | head -n 20

# Find large files
find / -type f -size +1G

# Check log directory
ls -lh /var/log

# Journal disk usage
journalctl --disk-usage

# Tail journal
journalctl -f

# Grep journal
journalctl -g zabbix

# Truncate large file
truncate -s 100M filename
```

---

### Production Server Down

```bash
# 1. Load
uptime
top

# 2. Memory
free -m

# 3. Disk
df -h
df -i

# 4. Heavy resource
ps aux --sort=-%cpu | head
ps aux --sort=-%mem | head

# 5. Service and logs
journalctl -f
journalctl -g zabbix
journalctl -p err -n 50 --no-pager
tail -n 100 /var/log/syslog

# 6. List ports
ss -ltn
ss -ant 'sport = :10050'
```

---

### Zabbix Troubleshooting

```bash
# Versions
zabbix_server --version
zabbix_agentd --version

# Logs
sudo tail -f /var/log/zabbix/zabbix_server.log
sudo grep 'failed' /var/log/zabbix/zabbix_server.log

# MySQL connection
cd /etc/zabbix
sudo grep 'DBPort' zabbix_server.conf
sudo grep 'DBPassword' zabbix_server.conf
sudo grep 'DBUser' zabbix_server.conf
sudo grep 'DBHost' zabbix_server.conf

mysql -h servername --port=3306 -u zabbix --password=the-password

# Reset Admin password
mysql -u root -p
USE zabbix;
UPDATE users SET passwd=MD5('zabbix') WHERE username='Admin';
FLUSH PRIVILEGES;

# Check tables
mysqlcheck -h servername --port=3306 -u zabbix --password=the-password --databases zabbix
```

---

### /dev/null

```bash
# /dev/null is a "black hole" - discards all data written to it
# Use to suppress output

# Example: quiet install
sudo apt install vlc > /dev/null
```

---

### SSH Error: Max Authentication Attempts

```bash
# Add to /etc/ssh/sshd_config
sudo nano /etc/ssh/sshd_config
AllowUsers username
```
