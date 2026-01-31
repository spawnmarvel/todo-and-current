# Bash quick guide

In Linux, the "everything is a file" philosophy means that nearly all system resources—hardware devices, processes, directories, and network sockets—are represented as data streams within the file system. 

This allows applications to read, write, and manipulate resources using standard tools like open, read, write, and close

* Unified Interface: Because hardware (e.g., hard drives, mice) is represented as files (typically in /dev), programs can interact with devices using the same methods as regular files.
* File Descriptor Abstraction: Rather than using different API calls for different resources, the Linux kernel abstracts these into file descriptors.
* Virtual Filesystem: Special directories like /proc and /sys represent kernel data structures as files, allowing users to view or change system configurations by reading/writing to them.

<details><summary>Man is the cheat guide</summary>
<p>

#### We can hide anything, even code!
```bash
man man
# man - an interface to the system reference manuals

man -k
# Search  the  short descriptions and manual page names for the keyword printf as regular expression.
# Printout any matches.  Equivalent to apropos printf
apropos what?

man -k security
man -k file
man -k text
man -k network

```
</p>
</details>

### W3schools repeat and and add :cyclone:

<details><summary>Basic Commands, ls, ls -a,  cd, pwd, echo, cat, cp, mv, rm, touch, mkdir</summary>
<p>

#### We can hide anything, even code!
```bash

#!/bin/bash
echo "Hello, Bash!"
#
hello.sh

ls    #  - List directory contents
ls -a #  - List hidden directory contents
cd    #  - Change the current directory
pwd   #  - Print the current working directory
echo  #  - Display a line of text
cat   #  - Concatenate and display files
cp    #  - Copy files and directories
mv    #  - Move or rename files
rm    #  - Delete files or folders
touch #  - Create an empty file or update its time
mkdir #  - Create a new folder

```
</p>
</details>

<details><summary>Text Processing, grep, awk, sed, cut, sort, tail, head, diff</summary>
<p>

#### We can hide anything, even code!
```bash

man grep
#  grep, egrep, fgrep, rgrep - print lines that match patterns

grep   # 'pattern' filename
grep -i 'search_term' file.txt                # Search ignoring case differences (uppercase or lowercase)
grep -r 'search_term' /home/user/my_directory # Search through all files in a directory and its subdirectories
grep -v 'search_term' file.txt                # Find lines that do not match the pattern

# Dot (.): Matches any single character (except a newline).
# Asterisk (*): Matches zero or more occurrences of the preceding character or regular expression.
# To match any sequence of characters (similar to the shell's * wildcard), you combine . and *

grep -i 'error' syslog                         # Match contains error
grep -i 'heartbeat.*error' syslog              # Match contains heartbeat followed by any char, then error

cd /etc/zabbix/                     # Find the log file
cat cat zabbix_agent2.conf

cd /var/log/zabbix

grep 'fail' zabbix_agent2.log       # Find all with fail
grep 'version' zabbix_agent2.log    # Find the version  

man awk
# gawk - pattern scanning and processing language

# -F - Set what separates the data fields
# -v - Set a variable to be used in the script
# -f - Use a file as the source of the awk program

cat data.txt
1;espen;45
2;silje;44

awk -F";" '{print $1}' data.txt                      # Field Separator
1
2

awk -F";" -v var="Name:" '{print var, $2}' data.txt # Assign Variable
Name: espen
Name: silje

awk -F";" '{sum += $3} END {print sum}' data.txt    # Data Manipulation
89


# sed 's/old/new/' filename
man sed
# sed - stream editor for filtering and transforming text

# -i - Edit files directly without needing to save separately
# -e - Add the script to the commands to be executed
# -n - Don't automatically print lines
# -r - Use extended regular expressions
# -f - Add script from a file
# -l - Specify line length for l command
# -g - The optional g flag stands for global (substitute all occurrences on a line, not just the first one).

cat data.txt
1;espen;45
2;silje;44

sed 's/espen/jim/' data.txt
1;jim;45
2;silje;44

sed -i 's/espen/jim/' data.txt

cat data.txt
1;jim;45
2;silje;44

cat example.json
{
  "firstName": "espen",
  "lastName": "withman",
  "location": "earth",
  "online": true,
  "followers": 987
}

sed -i 's/espen/roger/g' example.json

cat example.json
{
  "firstName": "roger",
  "lastName": "withman",
  "location": "earth",
  "online": true,
  "followers": 987
}

# Redirect Output to a File
sed 's/roger/tim/' example.json > new_example.json

#  cut - remove sections from each line of files
man cut

# -d - Choose what separates the fields
# -f - Select specific fields to display
# --complement - Show all fields except the selected ones

cat data.txt
1;jim;45
2;silje;44

cut -f1 -d';' data.txt
1
2

# The -f option allows you to select specific fields to display.
cut -f1-2 -d';' data.txt
1;jim
2;silje

#  sort - sort lines of text files
man sort

#  tail - output the last part of files
man tail

# -n [number]: Display the last [number] lines of the file.
# -f: Follow the file as it grows, useful for monitoring log files.

tail -f /var/log/syslog

tail -n 2 /var/log/syslog

# head - output the first part of files
man head

# -n [number]: Display the last [number] lines of the file.

# Display First 10 Lines
head /var/log/syslog

head -n 2 /var/log/syslog


man diff
# diff - compare files line by line
diff test1.txt test2.txt
# 1c1
# < id=12
# ---
# > id=3

sudo diff zabbix_server.conf zabbix_server.conf.bck


```
</p>
</details>

<details><summary>System Monitoring, ps, top, df, du, free, uptime</summary>
<p>

#### We can hide anything, even code!
```bash

#  ps - report a snapshot of the current processes.
man ps

# -e - Show all processes
# -f - Show detailed information
# -u - Show processes for a specific user
# -a - Show all processes with a terminal
# -x - Show processes without a terminal

ps -e

# display all with details like conf and bin
ps -ef

   zabbix       801       1  0 14:53 ?        00:00:00 /usr/sbin/zabbix_agent2 -c /etc/zabbix/zabbix_agent2.conf

# Show Processes for a Specific User
ps -u zabbix

   PID TTY          TIME CMD
   801 ?        00:00:00 zabbix_agent2

ps -u imsdal
   PID TTY          TIME CMD
   1181 ?        00:00:00 systemd
   1182 ?        00:00:00 (sd-pam)
   1310 ?        00:00:00 sshd
   1313 pts/0    00:00:00 bash
   1366 pts/0    00:00:00 ps

# top - display Linux processes
man top

# -d - Set the time between updates
# -p - Monitor specific PIDs
# -u - Show tasks for a specific user
# -n - Set the number of iterations
# -b - Batch mode operation

# Set Update Interval, each 5 sec
top -d 5

# monitor specific PIDs.
top -p 1010

# Show Tasks for a Specific User
top -u zabbix

# df - report file system space usage
man df

# To display disk space usage, use df:
df

# -h - Show sizes in human-readable format (e.g., KB, MB)
# -a - Show all file systems, even empty ones
# -T - Show the type of file system
# -i - Show inode usage
# -P - Use POSIX output format

# how sizes in human-readable format (e.g., KB, MB)
df -h

df -h /datadrive

# du du - estimate file space usage
man du

# The -h option allows you to show sizes in human-readable format
du -h

# free - Display amount of free and used memory in the system
man free

# -h - Show memory in human-readable format (e.g., KB, MB, GB)
#  -b - Show memory in bytes
# -k - Show memory in kilobytes (KB)
# -m - Show memory in megabytes (MB)
# -g - Show memory in gigabytes (GB)
# -s [interval] - Continuously display memory usage at specified intervals
# -t - Display total memory

# -h - Show memory in human-readable format (e.g., KB, MB, GB)
free -h

# [interval] - Continuously display memory usage at specified intervals
free -h -s 5

# kill - send a signal to a process
man kill

# -9: Forcefully terminate a process.
# -l: List all signal names.
# -s [signal]: Specify a signal to send.
# -p: Print the process ID.

# Forcefully Kill a Process
kill -9 1234

# List All Signal Names
kill -l

#  uptime - Tell how long the system has been running.
man uptime


```
</p>
</details>

<details><summary>Networking, ping, /etc/hosts, curl, wget, ssh, scp, rsync, ip addr, hostname -I and UFW </summary>
<p>

#### We can hide anything, even code!
```bash
# ping - send ICMP ECHO_REQUEST to network hosts
man ping

ping e1-x-mysql01
# does not work
ping 10.70.1.43
# works
# if there is now fw betwen servers and no ufw enabled edit host file, example
sudo nano /etc/hosts
# IP Address       Hostname
10.70.1.43          e1-x-mysql01
# then ping e1-x-mysql01 should work

# curl - transfer a URL
man curl

# view web page
curl www.ba.no

# -O - Save the file with the same name as the remote file
# -L - Follow redirects
# -I - Fetch the HTTP headers only
# -d - Send data with POST request
# -u - Specify user and password for server authentication

curl -O https://radio.nrk.no/podkast/trygdekontoret
ls
# trygdekontoret

#  Wget - The non-interactive network downloader.
man wget

# ssh — OpenSSH remote login client
man ssh

# scp — OpenSSH secure file copy
man scp

# scp file user@hostname:/path
scp trygdekontoret imsdal@172.64.0.5:/home/imsdal
# imsdal@172.64.0.5's password:
# trygdekontoret                                                       100%  309KB  21.3MB/s   00:00

# rsync - a fast, versatile, remote (and local) file-copying tool, checking the timestamp and size of files
# One solution: Don't copy what's already there.
# The rsync algorithm splits files into chunks, computes rolling checksums, and transfers only the differences. 
# A 1GB file with 1KB of changes? Transfer 1KB.
man rsync

# One command:
rsync -avz source/ destination/

# To synchronize a directory to a remote host, use rsync -avz source user@hostname:/path:
rsync -avz trygdekontoret imsdal@172.64.0.5:/home/imsdal
# imsdal@172.64.0.5's password:
# sending incremental file list
# trygdekontoret

# sent 112 bytes  received 2,753 bytes  520.91 bytes/sec
# total size is 316,837  speedup is 110.59

rsync -azv zabbix_offline_24_04/ imsdal@192.168.3.4:/home/imsdal/zabbix_offline_24_04

man ip addr
# ip - show / manipulate routing, network devices, interfaces and tunnels

ip addr
#  inet 192.168.3.5/24 metric 100 brd 192.168.3.255 scope global eth0

ip a
# inet 192.168.3.5/24 metric 100 brd 192.168.3.255 scope global eth0

hostname -I
# 192.168.3.5



```
* UFW, or Uncomplicated Firewal

https://github.com/spawnmarvel/linux-and-azure/tree/main/ufw-firewall

</p>
</details>

<details><summary>File Compression, zip, unzip, tar</summary>
<p>

#### We can hide anything, even code!
```bash

man zip
# not default ubuntu 24.4

man -k zip
# there are some options

# -r - Recursively zip directories
# -u - Update files in the archive if they are newer
# -d - Delete files from the archive
# -e - Encrypt the contents of the ZIP archive
# -x - Exclude specific files from being zipped

sudo apt install zip

# zip
zip test.zip file1.txt file2.txt
  adding: test1.txt (stored 0%)
  adding: test2.txt (stored 0%)

# unzip
unzip test.zip
Archive:  test.zip
 extracting: test1.txt               
 extracting: test2.txt  

# tar - an archiving utility
man tar

# The tar command is used to create, maintain, modify, and extract files from an archive file.

# -c - Create a new archive
# -x - Extract files from an archive
# -t - List the contents of an archive
# -z - Filter the archive through gzip
# -v - Verbosely list files processed
# -f - Specify the filename of the archive

# Create a new archive
tar -cvf archive.tar test1.txt test2.txt
test1.txt
test2.txt

# Option: -t (List)
tar -tvf archive.tar
-rw-rw-r-- imsdal/imsdal     0 2026-01-19 19:06 test1.txt
-rw-rw-r-- imsdal/imsdal     0 2026-01-19 19:06 test2.txt

# Option: -x (Extract)
tar xvf archive.tar
test1.txt
test2.txt

# check the files
ls

```
</p>
</details>

<details><summary>File Permissions, ls -l (list), chmod (permission), chown (owner), chgrp (group owner)</summary>

<p>

#### We can hide anything, even code!
```bash

# Numeric Representation of Permissions
# File permissions can also be represented numerically, which is often used in scripts and command-line operations:

# 0: No permission
# 1: Execute permission
# 2: Write permission
# 3: Write and execute permissions
# 4: Read permission
# 5: Read and execute permissions
# 6: Read and write permissions
# 7: Read, write, and execute permissions

# For example, the numeric permission 755 means the owner can read, write, and execute (7), 
# and the group and others can read and execute (5).

man chmod
# chmod - change file mode bits

# -R: Change files and directories recursively.
# -v: Output a diagnostic for every file processed.

# The -R option allows you to change permissions for files and directories recursively.
# This is useful when you want to apply the same permissions to all files and subdirectories within a directory.

# all
ls -l

# one file
ls -l test1.txt
-rw-rw-r-- 1 imsdal imsdal 0 Jan 19 19:06 test1.txt


# dir
ls -ld zabbix_offline_24_04/
drwxrwxr-x 2 imsdal imsdal 4096 Jan 11 20:13 zabbix_offline_24_04/

# -rw-rw-r--
# directory = d, regular file = -, symbolic link = I
# -rv- = user
#  rw- = group
#  r-- = others
# readable = r, writable = w, excecutable = x, denied = -


# one file example
ls -l test1.txt
-rw-rw-r-- 1 imsdal imsdal 0 Jan 19 19:06 test1.txt

# list numeric
stat -c '%a' test1.txt
664
# user, 6: Read and write permissions
# group, 6: Read and write permissions
# other, 4: Read permission

# set chmod
# The -v option provides verbose output, showing a diagnostic message for each file processed by the command.
chmod -v 760 test1.txt
mode of 'test1.txt' changed from 0660 (rw-rw----) to 0760 (rwxrw----)
# owner r, w and x
# group r and w
# others no permission

#  
# check it
stat -c '%a' test1.txt
760

man chown
# chown - change file owner and group




```

</p>
</details>

<details><summary>Scripting</summary>
<p>

#### We can hide anything, even code!
```bash


```
</p>
</details>

<details><summary>Exercises and Quiz</summary>
<p>

#### We can hide anything, even code!
```bash


```
</p>
</details>

https://www.w3schools.com/bash/bash_commands.php

## Hands on with

<details><summary>/dev/null</summary>
<p>

#### We can hide anything, even code!

```bash

# In the Linux world, /dev/null is essentially a "black hole." 
# Anything you send there disappears instantly, and the system doesn't have to spend any effort saving or displaying it.

# The simplest way to think of /dev/null is as a mute button for commands that talk too much.
# When you install software, the terminal usually spits out dozens of lines of text. 
# If you just want it to do its job quietly, you can throw that output away:
sudo apt install vlc > /dev/null
```
</p>
</details>

<details><summary>ssh-keygen</summary>
<p>

#### We can hide anything, even code!

```bash

ssh-keygen -t rsa -b 4096
#Private: Your identification has been saved in C:\Users\username/.ssh/id_rsa
#Copy this:Your public key has been saved in C:\Users\username/.ssh/id_rsa.pub

ssh-rsa#################################################

# ssh to ubuntu
mkdir -p ~/.ssh
chmod 700 ~/.ssh

touch ~/.ssh/authorized_keys
sudo nano ~/.ssh/authorized_keys
# paste the full ssh-rsa

exit
ssh imsdal@192.168.3.7
no pass

```
</p>
</details>

<details><summary>debmirror</summary>
<p>

#### We can hide anything, even code!

```bash

ssh
# Update package lists
sudo apt update

# Install debmirror for synchronization
sudo apt install debmirror

# Install Apache to serve the files via HTTP
sudo apt install apache2

# Install gnupg (gpg) required for GPG key conversion on the client
sudo apt install gnupg

# Ensure Apache starts automatically on boot
sudo systemctl enable apache2

# log it
sudo systemctl status apache2
● apache2.service - The Apache HTTP Server
     Loaded: loaded (/usr/lib/systemd/system/apache2.service; enabled; prese>
     Active: active (running) since Thu 2025-11-13 17:28:16 UTC; 1min 15s ago

```
</p>

https://github.com/spawnmarvel/linux-and-azure/tree/main/azure-extra-linux-vm-mirror

</details>

<details><summary>Mount a data drive with fdisk ubuntu 24.04 for mysql</summary>
<p>

#### We can hide anything, even code!

```bash

man fdisk
#  fdisk - manipulate disk partition table

# 0. Find the disk

lsblk -o NAME,HCTL,SIZE,MOUNTPOINT | grep -i "sd"
sda                       2:0:0:0      60G
sdb                       2:0:1:0      65G
├─sdb1                                  1G /boot/efi
├─sdb2                                  2G /boot
└─sdb3                               61.9G

# Empty Mount Point: There is nothing listed under the "MOUNTPOINT" column for sda
# Raw State: It has no child partitions (no sda1, sda2, etc.). It is just a raw 60GB block of storage waiting to be used.

# 1. Create the Partition

sudo fdisk /dev/sda

# type g, n, first sector press enter, last sector press enter and on command press w
# Created a new partition 1 of type 'Linux filesystem' and of size 60 GiB.

# check it
lsblk -o NAME,SIZE,MOUNTPOINT | grep "sd"
sda                         60G
└─sda1                      60G
sdb                         65G
├─sdb1                       1G /boot/efi
├─sdb2                       2G /boot
└─sdb3                    61.9G

# 2. Format the new Partition (sda1)

sudo mkfs.ext4 /dev/sda1

# 3. Create the Directory and Moun

# Create the folder
sudo mkdir -p /datadrive
# Mount the partition to that folder
sudo mount /dev/sda1 /datadrive

# 4. Make it Permanent (fstab) on restart
# Get the unique ID: 
sudo blkid /dev/sda1
/dev/sda1: UUID="0b620824-cbfc-45fe-ae87-a21f7fdbf7cf" BLOCK_SIZE="4096" TYPE="ext4" PARTUUID="85488b3c-be39-4992-b045-81b060a8884d"

# (Copy the UUID).

# Open the config: 
sudo nano /etc/fstab

# Add this line at the very bottom:
UUID=0b620824-cbfc-45fe-ae87-a21f7fdbf7cf  /datadrive  ext4  defaults,nofail  0  2

# Verification
lsblk -o NAME,SIZE,MOUNTPOINT | grep "sd"
sda                         60G
└─sda1                      60G /datadrive
sdb                         65G
├─sdb1                       1G /boot/efi
├─sdb2                       2G /boot
└─sdb3                    61.9G

# sda1 → mounted at /datadrive
# sdb → still mounted at /, /boot, etc

# By default, the root of a newly formatted disk is owned by the root user. 
# To ensure you can create files and folders there without typing sudo every time, run this command:

sudo chown $USER:$USER /datadrive

# make a txt file and add some text
sudo nano /datadrive/test.txt

cat /datadrive/test.txt


# reboot server and run
sudo shutdown -r now

# Verification
lsblk -o NAME,SIZE,MOUNTPOINT | grep "sd"


# Verification
cat /datadrive/test.txt


```
</p>
</details>

<details><summary>Moving the MySQL data directory on Ubuntu 24.04</summary>
<p>

#### We can hide anything, even code!
```bash

# Moving the MySQL data directory on Ubuntu
lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda                         8:0    0   60G  0 disk
└─sda1                      8:1    0   60G  0 part /datadrive
sdb                         8:16   0   65G  0 disk
├─sdb1                      8:17   0    1G  0 part /boot/efi
├─sdb2                      8:18   0    2G  0 part /boot
└─sdb3                      8:19   0 61.9G  0 part
  └─ubuntu--vg-ubuntu--lv 252:0    0 61.9G  0 lvm  /
sr0                        11:0    1 1024M  0 rom

# we want to move it to sda datadrive

# check current path
mysql -u root -p -e "SELECT @@datadir"

# or
mysql -u root -p

# enter the sql and exit

sudo systemctl stop mysql

# Create the new directory and use rsync to copy the files, preserving permissions and ownership:
# Since you own /datadrive, we will create a specific sub-folder for MySQL and hand ownership of only that folder over to the database system:
sudo mkdir -p /datadrive/mysql
sudo chown mysql:mysql /datadrive/mysql
sudo chmod 750 /datadrive/mysql

# (Optional) Back up the old directory:
sudo mv /var/lib/mysql /var/lib/mysql_old

# Copy the Data (Preserving Permissions)
sudo rsync -av /var/lib/mysql/ /datadrive/mysql/

# Update the Configuration
sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
# Change the datadir line to: 
datadir = /datadrive/mysql

# Fix AppArmor (Required for Ubuntu 24.04)
# Ubuntu's security will block MySQL from looking at /datadrive unless we add an alias.
sudo nano /etc/apparmor.d/tunables/alias

# Add this line to the very bottom: alias /var/lib/mysql/ -> /datadrive/mysql/,
alias /var/lib/mysql/ -> /datadrive/mysql/,

# Reload AppArmor:
sudo systemctl restart apparmor

# Because you previously ran chown $USER:$USER /datadrive, we need to make sure the MySQL service has "search" (execute) permissions 
# to walk through the /datadrive folder to get to its /datadrive/mysql folder.

# This grants everyone 'execute' permissions on the parent folder only, 
# allowing MySQL to 'pass through' to its data.
sudo chmod +x /datadrive

# Start the service
sudo systemctl start mysql

# Verify the change

sudo systemctl status mysql
mysql -u root -p -e "SELECT @@datadir"


```

</p>
</details>


<details><summary>Zabbix version, mysql -h, reset Admin(zabbix) password, and health check tables</summary>
<p>

#### We can hide anything, even code!
```bash
zabbix_server --version

zabbix_agentd --version

# log it 
sudo tail -f /var/log/zabbix/zabbix_server.log

mysql --version

cd/etc/zabbix
sudo grep ’DBPort*’ zabbix_server.conf 
sudo grep ’DBPassword*’ zabbix_server.conf 

sudo grep ’DBUser*’ zabbix_server.conf 
sudo grep ’DBHost*’ zabbix_server.conf 

# mysql -h servername --port=3306 -u zabbix --password=the-password

```
More mysql in the mysql folder.


MySQL side note

```sql
-- if you ever forget the Admin password, this resets it to zabbix
SELECT username, passwd FROM users WHERE username='Admin';
USE zabbix;

UPDATE users 
SET passwd=MD5('zabbix') 
WHERE username='Admin';

FLUSH PRIVILEGES;
```
If you are upgrading the mysql database
```bash

# check this
Cd /etc/zabbix
sudo grep 'AllowUns*' zabbix_server.conf

Cd /etc/zabbix/web
sudo grep 'AllowUns*' zabbix.conf.php

# Run a quick check on the Zabbix schema to ensure no tables are crashed

mysqlcheck -h servername --port=3306 -u zabbix --password=the-password --databases zabbix
# all should be ok

```
</p>
</details>

<details><summary>Ubuntu 24.04, Apache comes with a built-in script to handle the basic SSL setup</summary>
<p>

#### We can hide anything, even code!
```bash
# create a certificate that is valid for 3650 days.
sudo openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
-keyout /etc/ssl/private/zabbix-selfsigned.key \
-out /etc/ssl/certs/zabbix-selfsigned.crt

# Common Name (e.g. server FQDN): Enter v12-x-zabbix01 or your server's IP.
# You can leave the other fields (Country, State, etc.) blank or put . in them.

# First, enable the SSL module and the default SSL site configuration:
sudo a2enmod ssl
sudo a2ensite default-ssl

# Now, edit the SSL configuration to point to your new certificate:
sudo nano /etc/apache2/sites-enabled/default-ssl.conf

# Find these two lines and update them to match your new files:
SSLCertificateFile    /etc/ssl/certs/zabbix-selfsigned.crt
SSLCertificateKeyFile /etc/ssl/private/zabbix-selfsigned.key

# To ensure no one uses the insecure port 80, tell Apache to move everyone to port 443
sudo nano /etc/apache2/sites-available/000-default.conf

# Add these lines inside the <VirtualHost *:80> block
RewriteEngine On
RewriteCond %{HTTPS} off
RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]

# Note: You may need to enable the rewrite module first:
sudo a2enmod rewrite

# Restart Apache to load the new modules and certificate:
sudo systemctl restart apache2

# https://v12-x-zabbix01/zabbix
```

</p>
</details>

<details><summary>Update and upgrade / apt install and apt remove </summary>
<p>

#### We can hide anything, even code!
```bash

sudo apt update -y         # - Update apt/sources
sudo apt list --upgradable # - List possible upgrades
sudo apt upgrade -y        # - Do upgrade

cd /etc/apt/               # - View apt sources list*
ls -lh
ubuntu.sources 

# lets install zabix agent2
# https://www.zabbix.com/download?zabbix=7.0&os_distribution=ubuntu&os_version=24.04&components=agent_2&db=&ws=

wget https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.0+ubuntu24.04_all.deb # Get pack

sudo dpkg -i zabbix-release_latest_7.0+ubuntu24.04_all.deb # -i install

sudo apt update -y

cd /etc/apt/sources.list.d
ls -lh
ubuntu.sources  zabbix-tools.list  zabbix.list

sudo apt install zabbix-agent2      # Install agent

# lets run some more examples
sudo apt update -y
sudo apt list –upgradable
sudo apt upgrade -y
sudo apt list --installed | grep -i 'influx*'
sudo apt search 'influxdb'

sudo apt update -y
sudo apt install snmp
which snmp
sudo apt remove install snmp
history

dpkg # is the underlying package manager for these ubuntu.

```
</p>
</details>


<details><summary>Hello world bash script with chmod</summary>
<p>

#### We can hide anything, even code!
```bash

nano demo.sh # https://kodekloud.com/blog/make-bash-script-file-executable-linux/

#!/bin/bash
echo "Hello World!"

# r = read, w = write, x = execute, - = is not granted
ls -l demo.sh

# u = user (owner), + = add, x = execute
chmod u+x demo.sh
# or octal, 744. user (u) has read (4), write (2), and execute (1) permissions (adding up to 7)
# and the group (g) and others (o) have only read permissions (4).
chmod 744 demo.sh

# run
./demo.sh 

# List all users
cat /etc/passwd
```

</p>
</details>

<details><summary>Simple troubleshoot Zabbix with tail, grep, htop and port check</summary>
<p>

#### We can hide anything, even code!
```bash

tail -f zabbix_server.logs

sudo grep '*failed*' /var/log/zabbix/zabbix_server.log
sudo tail -f /var/log/zabbix/zabbix_server.log >> tmp_logs
sudo find /var/log -name "*log"

ss -ltn
ss -ant 'sport = :10050'
htop
top
df -lh
ls -lhS

```

</p>
</details>

## Misc

<details><summary>Troubleshooting guide disk, big files and journalctl tail</summary>
<p>

#### We can hide anything, even code!
```bash

# check disk
df -h /
# Filesystem      Size  Used Avail Use% Mounted on
# /dev/root        29G  4.8G   25G  17% /

# find large directories
sudo du -ah / 2>/dev/null | sort -rh | head -n 20
# 6.1G    /
# 2.5G    /var
# 2.1G    /usr
# [...]

# identify large files
find / -type f -size +1G

# This command lists the files in your system log directory, 
# which is where Linux keeps a history of everything that 
# happens on your machine (errors, logins, system updates, etc.).
ls -lh /var/log

# In the Linux world, the Journal (specifically the systemd-journald service) is a centralized, "smart" storage system for all log messages.

# view 
journalctl --disk-usage
# Archived and active journals take up 471.4M in the file system.

# tail journal
journalctl -f

# grep journal
journalctl -g zabbix

# grep item in zabbxx 
sudo grep 'item*' /var/log/zabbix/zabbix_server.log

# tail zabbix, last 10 lines
sudo tail -f /var/log/zabbix/zabbix_server.log

# If the file is BIGGER than 100MB: The command chops off everything after the 100MB mark. The data is permanently deleted and cannot be recovered.
truncate -s 100M filename


```
</p>
</details>


## Todo

* openldap


## Linux

### Loadable Kernel Module

Loadable Kernel Modules (LKMs). These are pieces of code that can be loaded into or unloaded from the kernel on demand without needing to reboot the entire system. They act like "plug-ins" for your operating system.

* usb-storage: Allows the system to talk to USB flash drives and external hard disks
* ext4: The standard file system for most Linux distributions.
* ​iptable_filter / nftables: The backbone of the Linux firewall (Netfilter). They decide which data packets are allowed in or out.
* ​bridge: Allows the kernel to make the computer act like a network switch, which is vital for running Virtual Machines (VMs) or Docker containers.

### File system, permission and access control

```bash
# example
chmod 744 demo.sh
# user has full group and others has read
```
![file all](https://github.com/spawnmarvel/todo-and-current/blob/main/bash/images__and_pdf/file_all.png)

### Top explained

```bash
top -d 60

# No, htop is usually not installed by default on a fresh Ubuntu installation, but it is available in the official Ubuntu repositories.
sudo apt update
sudo apt install htop
htop
```

top

![top](https://github.com/spawnmarvel/todo-and-current/blob/main/bash/images__and_pdf/top.png)

htop

![htop](https://github.com/spawnmarvel/todo-and-current/blob/main/bash/images__and_pdf/htop.png)



