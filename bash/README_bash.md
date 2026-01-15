# Bash quick guide

Man is the cheat guide
```bash
man -k
apropos what?

man -k security
```
W3schools

<details><summary>Basic Commands</summary>
<p>

#### We can hide anything, even code!
```bash

#!/bin/bash
echo "Hello, Bash!"
#
hello.sh

ls    #  - List directory contents
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

<details><summary>Text Processing</summary>
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

```
</p>
</details>

<details><summary>System Monitoring</summary>
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

# how sizes in human-readable format (e.g., KB, MB) with file path
dh -hT

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

<details><summary>Networking / UFW</summary>
<p>

#### We can hide anything, even code!
```bash
# ping - send ICMP ECHO_REQUEST to network hosts
man ping

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


```
* UFW, or Uncomplicated Firewal

https://github.com/spawnmarvel/linux-and-azure/tree/main/ufw-firewall

</p>
</details>

<details><summary>File Compression</summary>
<p>

#### We can hide anything, even code!
```bash

man zip

```
</p>
</details>

<details><summary>File Permissions</summary>
<p>

#### We can hide anything, even code!
```bash


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
<details><summary>fdisk mount data drive example ubuntu 24.04</summary>
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

## Misc, must clean below mysql will be moved also





<details><summary>Quick guide self, troubleshoot log, ports, cpu and ram, apt installremove</summary>
<p>

#### We can hide anything, even code!
```bash

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

<details><summary>Update and upgrade / apt install </summary>
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

```
</p>
</details>

