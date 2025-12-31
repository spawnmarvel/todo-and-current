

<details><summary>Commands bash quick guide self, troubleshoot log, ports, cpu and ram</summary>
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
man rsync

# To synchronize a directory to a remote host, use rsync -avz source user@hostname:/path:
rsync -avz trygdekontoret imsdal@172.64.0.5:/home/imsdal
# imsdal@172.64.0.5's password:
# sending incremental file list
# trygdekontoret

# sent 112 bytes  received 2,753 bytes  520.91 bytes/sec
# total size is 316,837  speedup is 110.59


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