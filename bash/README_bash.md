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


## Python & Powershell vs Bash tips

The 3 Core Differences
1. Everything is a String (Text Streams)

* Python/PowerShell: These languages handle complex data structures (dictionaries, lists, objects) natively. They pass objects between functions.
* Bash: Everything is a string. When you pipe data between commands, you are passing raw text. If you want to "process" data, you have to use external text-processing tools like grep, sed, awk, or cut.

Analogy: In Python, you have a "User" object with a .name attribute. In Bash, you have a line of text that you must slice and dice using regex to find the name.

2. The "Process" Model

* Python: You run a script that stays in memory and manages its own state.
* Bash: Every command you run in a script usually creates a new process (a sub-shell or a fork). This is why variable scope and file descriptors can feel more fragile in Bash compared to the robust memory management of Python or the module-loading system of PowerShell.

3. Error Handling and "Strict Mode"

* Python: Uses try...except blocks.
* PowerShell: Uses Try...Catch and ErrorActionPreference.

Bash: By default, if a command fails, Bash continues to the next line. This is the #1 trap for beginners. You must explicitly configure Bash to stop on errors using "Strict Mode."

![bash_table](https://github.com/spawnmarvel/todo-and-current/blob/main/images/bash_table.png)

## Pro-Tip: "Bash Strict Mode"

If you are coming from Python or PowerShell, you will find Bash very frustrating because it ignores errors by default. Always put this at the top of your scripts to make them behave more predictably:

```bash
#!/bin/bash
set -euo pipefail
# -e: Exit immediately if a command exits with a non-zero status
# -u: Treat unset variables as an error
# -o pipefail: Catch errors in piped commands
```

## W3schools :cyclone:vmchaos09

<details><summary>Basic Commands, ls, ls -a, ls *name*, cd, pwd, echo, cat, cp, mv, rm, touch, mkdir</summary>
<p>

#### We can hide anything, even code!
```bash

#!/bin/bash
echo "Hello, Bash!"
#
hello.sh

ls                     #  - List directory contents
ls -a                  #  - List hidden directory contents
ls *apt-main*          # returns apt-maintenance-2026-01-31.log
cd                     #  - Change the current directory
pwd                    #  - Print the current working directory
echo                   #  - Display a line of text
cat                    #  - Concatenate and display files
cp                     #  - Copy files and directories
mv                     #  - Move or rename files
rm                     #  - Delete files or folders
rm zabbix_agent2.conf  # remove zabbix agent conf
rm -r zabbix_agent2.d/ # remove folder and recursivley
touch                  #  - Create an empty file or update its time
mkdir                  #  - Create a new folder

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

# lets create a user
sudo adduser olden
# [...]
# info: Creating home directory `/home/olden' ...
[...]

# lets create a new file with imsdal
touch carrot_list.txt

# check permissions
stat -c '%a' carrot_list.txt
# 644

# check owner
ls -l carrot_list.txt
# -rw-rw-r-- 1 imsdal imsdal 0 Feb  9 21:05 carrot_list.txt
# group is imsdal and owner is imsdal

# change owner to olden
sudo chown -v olden carrot_list.txt
# changed ownership of 'carrot_list.txt' from imsdal to olden


ls -l carrot_list.txt 
# -rw-rw-r-- 1 olden imsdal 0 Feb  9 21:05 carrot_list.txt
# owner is olden and group is imsdal

man chgrp
# chgrp - change group ownership

# first lets show groups and view
cat /etc/group
root:x:0:
daemon:x:1:
bin:x:2:
sys:x:3:
adm:x:4:syslog,imsdal # in admin
# [...] there are many more
mysql:x:115:
olden:x:1001:

# Each line follows a specific format:
# group_name : password_placeholder : GID : member_list

# lets add olden to the admin group
# Warning: Always include the -a flag. If you run usermod -G groupname username without it, Linux will remove the user from all other groups they belong to except the one you just listed!

sudo usermod -aG adm olden

# and list them again
cat /etc/group
root:x:0:
daemon:x:1:
bin:x:2:
sys:x:3:
adm:x:4:syslog,imsdal,olden

# lets change the group for the file
sudo chgrp -v admin carrot_list.txt
changed group of 'carrot_list.txt' from imsdal to admin

# list the owner and group
s -l carrot_list.txt 
-rw-rw-r-- 1 olden admin 0 Feb  9 21:05 carrot_list.txt



```

</p>
</details>

## W3 scripting


<details>
<summary><b>01.Scripting Basics</b></summary>
<p>

Syntax Fundamentals
```bash
# comment
echo "first command, top down"
echo "second command"

echo "use ; for multiple lines"; echo "like this"
```

Creating a Script (e.g., test_script.sh)
```bash
#!/bin/bash
# Usage:
# sudo chmod +x test_script.sh
sudo ./test_script.sh
```
</p>
</details>

<details>
<summary><b>02. Variables & Operations</b></summary>
<p>
Assignments

```bash
current_dir=$(pwd)
echo $current_dir

number=42
echo $number

# Environment Variables
echo "Your PATH is $PATH"
```
Common Operations

```Bash
# Concatenation
player="John"
game="RPG"
echo "$player$game"

# Arithmetic
health=80
candybar=22
sum=$((health + candybar))
echo "Total Health: $sum"
```

</p>
</details>

<details>
<summary><b>03. Datatypes & Arrays</b></summary>
<p>

Strings

```Bash
# strings
greeting="Allo, allo"
name="Steve"
welcome="$greeting, $name"
echo "$welcome"

# Numbers
num1=5
num2=2
echo "sum $((num1 + num2)), diff $((num1 - num2)), mult $((num1 * num2)), div $((num1 / num2))"
```
Arrays (Indexed & Associative)

```Bash
# Standard Array
enemy=("ogre" "demon" "troll")
for e in "${enemy[@]}"; do
 echo "Enemy: $e"
done

# Key-Value (Associative) Array
declare -A enemys
enemys[ogre]="100kg"
enemys[demon]="150kg"
enemys[troll]="200kg"
enemys[god]="50kg"

unset enemys[god]
# ater this, echo $nemys[god] will produce no output, and the variable will be "unbound".

echo "Demon weight: ${enemys[demon]}"
```
</p>
</details>

<details>
<summary><b>04. Operators</b></summary>
<p>

Comparison (Numeric)
* -eq : equal
* -ne : not equal
* -lt : less than
* -le : less than or equal
* -gt : greater than
* -ge : greater than or equal

```bash
# number
num3=22
if [ $num3 -gt 20 ]; then
 echo "Greater than 20"
fi
```

String & Logic

* = / != : string equality
* && / || / ! : AND, OR, NOT


```bash
# strings
name="john"
if [ $name = "Jim" ]; then
 echo "Name is equal $name"
else
  echo "Name is not equal $name"
fi

```

File Tests

* -e : exists
* -d : is directory
* -f : is regular file
* -s : is not empty


```bash
# asuming the folder is in the dir where we run the script
check_dir="folder/"
if [ -d "$check_dir" ]; then
  echo "Dir exists $check_dir"
else
  echo "Dir not exists $check_dir"
fi
```

</p>
</details>

<details>
<summary><b>05. Control Flow (If/Else)</b></summary>
<p>

```Bash
num3=20
if [ $num3 -gt 20 ]; then
 echo "Greater than 20"
elif [ $num3 -eq 20 ]; then
 echo "Equal to 20"
else
 echo "Less than 20"
fi
```
</p>
</details>


<details><summary><b>06. Loops</b></summary>
<p>


```bash
#!/bin/bash
# for loop

for i in {1..5}; do
  echo "Iteration $i"
done

# while loop

count=1
while [ $count -le 5 ]; do
  echo "Count is $count"
  ((count++))
done

# until loop

count=1
until [ $count -gt 5 ]; do
  echo "Count is $count"
  ((count++))
done

# break and continue

for i in  {1..5}; do
  if [ $i -eq 3 ]; then
    continue
  fi
  echo "Number $i"
  if [ $i -eq 4 ]; then
    break
  fi
done

# nested loops

for i in {1..3}; do
  for j in {1..2}; do
    echo "Outer $i, Inner $j"
  done
done

```
</p>
</details>

<details><summary><b>07. Functions</b></summary>
<p>


```bash
#!/bin/bash

my_function() {
  echo "Hello world"
}

my_function


# parameter 1
input_fun() {
  local param=$1
  echo "The parameter is $param"
}

input_fun "Acer"

# parameter 1 and 2
input_fun() {
  local param1=$1
  local param2=$2
  echo "The parameter is $param1 and $param2"
}

input_fun "Acer" "ludo"

return_fun() {
  local sum=$(($1 + $2))
  echo $sum
  echo "Calculated"
}

result=$(return_fun 10 3)
echo $result

```
</p>
</details>

<details><summary><b>08. Arrays</b></summary>
<p>


```bash
#!/bin/bash
my_array=("val1" "val2" "val3")
# get 0
echo $my_array[0]
# get all

echo "${my_array[@]}"

# mod
my_array[1]="val22"

echo "${my_array[@]}"

```
</p>
</details>

<details><summary><b>09. Schedule cron</b></summary>
<p>


```bash
#!/bin/bash

# get the date time
dt=$(date)
echo $dt

# append it to a file
echo $dt >> script_log.txt

```

Options
```bash
crontab [options]
# -e: Edit the crontab file for the current user.
# -l: List the crontab entries for the current user.
# -r: Remove the crontab file for the current user.

```
Run it every minute.

```bash
# get path to script
pwd
/home/imsdal

# or 
realpath log_script.sh 
/home/imsdal/log_script.sh

crontab -e
# 1. /bin/nano

# every min 
 * * * * * /home/imsdal/log_script.sh >>/home/imsdal/logs/cron_log.log 2>&1
# save it
# >> Appends the standard output.
# 2>&1 Ensures errors (Standard Error) are also sent to the log file.

# every 5 min
# */5 * * * * /path/to/your/script.sh

# Bash scripts won't run unless they have the "x" permission bit set.
chmod +x /home/imsdal/log_script.sh

```

verify that cron is running (optional)
```bash
# check that cron are running
sudo systemctl status cron

```

Log script it with tail or cat

```bash
sudo tail -f script_log.txt

cat script_log.txt 
Wed Apr 1 16:45:01 UTC 2026
Wed Apr 1 16:46:01 UTC 2026

``` 

Log cron it with tail or cat

```bash
sudo tail -f script_log.txt

cat cron_log.log 
Wed Apr 1 16:45:01 UTC 2026
Wed Apr 1 16:46:01 UTC 2026
``` 


Remove a script

```bash
# check what w ehave
crontab -l
# open it
crontab -e
# find the line containing your script and remove it


```

</p>
</details>

<details><summary>Exercises and Quiz TODO</summary>
<p>

#### We can hide anything, even code!
```bash
# when done make bash text game

# Get started
# ls
# cd
# pwd
```
</p>
</details>

https://www.w3schools.com/bash/bash_commands.php

<details><summary>The bash game RPG (like UIB)</summary>
<p>

#### We can hide anything, even code!
```bash
# when done make bash text game
# player
# monster
# damage
# check life etc
# save game to file

```
</p>
</details>

## Hands on with

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
sudo apt remove snmp

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
<details><summary>sudo (is slow) nano tst.txt</summary>
<p>

#### We can hide anything, even code!

```bash
hostname
vmchaos09

# edit
127.0.0.1 localhost

# The following lines are desirable for IPv6 capable hosts

# to
127.0.0.1 localhost vmchaos09
::1       localhost ip6-localhost ip6-loopback vmchaos09

# The following lines are desirable for IPv6 capable hosts
```
Since the delay is gone, your system is now resolving its identity locally in microseconds instead of waiting for a network timeout. To keep things running smoothly, here is a quick summary of what you just accomplished:

The Fix Summary
*  Root Cause: sudo was performing a canonical hostname lookup. Without your hostname in /etc/hosts, it spent several seconds asking external DNS servers for an address it should have found internally.
*  The Solution: Mapping your hostname to the loopback address ($127.0.0.1$) allowed the system to verify its identity instantly.
*  The Result: Zero-latency execution for all sudo authenticated commands.


</p>
</details>

<details><summary>shd[14883]: error: maximum authentication attempts exceeded for invalid user</summary>
<p>

#### We can hide anything, even code!

```bash

# Add this line to the end of your /etc/ssh/sshd_config:
sudo nano /etc/ssh/sshd_config
# AllowUsers username

```
(Replace username with your actual username. This blocks every other name on the system from even trying to log in via SSH.)
</p>
</details>

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

# Generate a key pair if you do not already have it?
 Either use the key you all ready have
# check it
cd ~/.ssh

# linux
sudo cat ~/.ssh/id_ed25519.pub
# windows
Get-Content $HOME\.ssh\id_ed25519.pub

# Generate a key pair
ssh-keygen -t ed25519 
# (recommended for modern security).

# to force a name for a role for example?
# ssh-keygen -t ed25519 -C "myname" -f ~/.ssh/octopus_key

# -t ed25519: Selects the modern encryption algorithm.
# -C "myname": Adds your chosen comment inside the public key.
# -f ~/.ssh/octopus_key: Forces the output to be named octopus_key (private) and octopus_key.pub (public) inside your .ssh folder.

# Private: id_ed25519 
# Publisc Copy this:Your public key: id_ed25519.pub 

cat ~/.ssh/id_ed25519.pub

# ssh-ed25519 AAxxxxxxxx

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

<details><summary>Generate ssl (no prompts) and check it</summary>
<p>

#### We can hide anything, even code!

```bash

sudo openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out server.crt -keyout server.key -subj "/C=NO/ST=Hordaland/L=BER/O=Socrates.inc/OU=IT/CN=vm01.socrates.inc"

ls
#  server.crt  server.key

openssl x509 -noout -subject -startdate -enddate -in server.crt
# subject=C = NO, ST = Hordaland, L = BER, O = Socrates.inc, OU = IT, CN = vm01.socrates.inc
# notBefore=Mar 29 18:03:20 2026 GMT
# notAfter=Mar 29 18:03:20 2027 GMT

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
Read more at https://github.com/spawnmarvel/linux-and-azure/tree/main/azure-extra-linux-vm-mirror

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


## Troubleshoot

<details><summary>Troubleshooting guide: disk, big files and journalctl tail</summary>
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

<details><summary>Production server down ???</summary>
<p>

#### We can hide anything, even code!
```bash

# 1 load
uptime
top

# 2 memory
free -m

# 3 disk
dh -h
dh -i

# 4 heavy resource
ps aux --sort--%cpu | head
ps aux --sort--%mem | head

# 5 service and logs
# tail journal
journalctl -f

# grep journal
journalctl -g zabbix

# get 50 last errors
journalctl -p err -n 50 --no-pager

# get 100 last syslog
tail -n 100 /var/log/syslog

# 6 lists ports
# List Listening TCP Sockets
ss -ltn

# Filters the results so you only see traffic where the Source Port is 10050.
ss -ant 'sport = :10050'

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



