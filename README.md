# Todo-and-current :seedling:

- Readme with todo-and-current, Ai as helper, Gemini.


<details><summary>Shuhari model: for bash in this case</summary>
<p>

#### We can hide anything, even code!

| Stage | Kanji/meaning  | Phrase                                      |
| ------| -------------- |-------------------------------------------- |
| Shu   | Obey           | Follow examples exactly and repeat x 3      | 
| Ha    | Break          | Adapt scripts and explore alternatives.     |
| Ri    | Separate       | Create your own unique, efficient solutions |

Applying Shu-Ha-Ri for Accelerated Learning :dragon:

* Strictly follow ***one proven method (e.g., one tutorial, one recipe, one set of rules)*** without deviation or questioning. Focus on imitation and repetition to build unconscious competence (muscle memory/system familiarity).
* Actively experiment by testing the boundaries of the rules and integrating knowledge from other sources. ***Ask "Why?" to understand the underlying principles and trade-offs.***
* Create your own unique methods and solutions, acting on instinct and deep, ***internalized knowledge.*** Teach the skill to others to solidify your mastery.

</p>
</details>

<details><summary>The 2,3,5,7 revision method</summary>
<p>

#### We can hide anything, even code!

Day 2 and day 3 are revision days of the learning achieved on Day 1. Day 4 is a rest day, while Day 5 you re-visit the work. Day 6 is another rest day, and finally Day 7 is your last re-visit opportunity before you write your exam.

</p>
</details>


## Parked e-lo

https://follow-e-lo.com/

## Scripting

* SQL*, Python, Bash*, Powershell
* Think automation, idempotent .ps1, .sh

## Plan! :bell: :bell:

<details><summary>Main plan overview</summary>
<p>

#### We can hide anything, even code!

* Bash tutorial :arrow_down:
* apt offline/ mysql
* Docker repeat, not install more on linux use docker, you can but not make gitpages of it :arrow_down:
* Course AZ-2008-A: DevOps Foundations: The Core Principles and Practices

https://learn.microsoft.com/en-us/training/courses/az-2008

* AZ-104 certified professional must know, fill the gaps here (network, monitor, web apps)
* Think automation and custom script extensions for Azure pipelines, docker etc

https://github.com/spawnmarvel/azure-automation-bicep-and-labs/tree/main/az-104-certified-professional

</p>
</details>


## Plan misc :bell:


<details><summary>Plan misc overview</summary>
<p>


Plan Misc!

* Bash Tutorial REPEAT and REPEAT and simple docker
* Update the quick guide with chapters

--- 

* Log monitor Q2 2026 Elastic stack

---

* Zabbix
* * Do more Zabix on Ubuntu below and check v 7
* Zabbix offline, first simple software offline, NSG only vnet outbund.
* Go to linux repos\zabbix\readme offline

---

* Docker Basic to DevOps 2025/2026
* learning-docker dmzdocker0
* * Work with ElasticStack on Ubuntu and Docker
* * Work with Solr in Docker

---

* Then the AZ-2008, jump to the docker section and do azure container registry and instance.
Then Github actions-> Github self-hosted runners

---

Misc

* Apache Tomcat, python (solr) windows
* Play with tomcat10w.exe GUI, logging tab, java tab etc
* * https://github.com/spawnmarvel/quickguides/tree/main/apache_tomcat_and_solr#tomcat10wexe-gui-stderrlog--stdoutlog--captures-system-errors-and-console-outputs

* Upgrade Apache Tomcat 

---

* Set up OPC UA, and work more with OPC DA CIMIO / datatech Connect test push
* * Prosys OPC UA sim, Cogent OPC UA client, InfluxDB, OPC UA expert, db21
* * https://github.com/spawnmarvel/quickguides/blob/main/cogent-opcua-influxdb/README.md

---

* More IP21, repos, cache, sort tags in folders, cmh files for guides
* * Quick start and Administration tools

---

* SNMP
* * Telegraph SNMP
* * https://github.com/spawnmarvel/linux-and-azure/blob/main/azure-extra-linux-vm/telegraf/README_telegraf_snmp.md

---

* Do more Oracle Database Express Edition (XE) 21c CRUD and password
* * https://github.com/spawnmarvel/quickguides/blob/main/oracle/README.md

----

* Azure SQL tutorial (Azure Free sql) BikeStores & AdventureWorks
* * https://github.com/spawnmarvel/t-sql/tree/master/course2_ai

</p>
</details>

## Always :repeat:

* dmzwindows07 server run windows updates on it
* All linux servers, run updates

## Network advanced tutorial and checklist

https://follow-e-lo.com/network-and-netsh/

## Linux :hotel:

* UFW, SSH, PS1, Bash quick ref, file system hierarchy, grep, tail, script, env, cron, py

https://github.com/spawnmarvel/linux-and-azure

### Linux quick guide grep it

<details><summary>Commands bash quick guide self</summary>
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

https://github.com/spawnmarvel/linux-and-azure?tab=readme-ov-file#grep-it

### Linux mind maps

https://github.com/spawnmarvel/linux-and-azure/tree/main/z-mind-maps

### Bash tutorial, repeat, repeat and repeat :rocket: :repeat: :rocket:

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


```
</p>
</details>

<details><summary>Networking / UFW</summary>
<p>

#### We can hide anything, even code!
```bash


```
* UFW, or Uncomplicated Firewal

https://github.com/spawnmarvel/linux-and-azure/tree/main/ufw-firewall

</p>
</details>

<details><summary>File Compression</summary>
<p>

#### We can hide anything, even code!
```bash


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


## Apache Tomcat (Solr) 

Windows.

Install java, apache tomcat, flask app, learn logs, install solr, upgrade apache.

<details><summary>Overview of plan</summary>
<p>

#### We can hide anything, even code!

* Install Apache Tomcat on dmzwindows07
* Host Python Flask check and tune logs
* Tomcat Apache logging, python log to stdout in apache
* Fix log levels and log size of apache

* (fix this 1 out of 3)
* Install solr, and try to applie same fix, use python to send to updatehandler for solr.
* * Apache Tomcat and Solr windows fix logging 1 out of 3, optimization after scan
* Upgrade Apache Tomcat 

</p>
</details>

https://github.com/spawnmarvel/quickguides/tree/main/apache_tomcat_and_solr

### Zabbix stack :traffic_light:

Ubuntu.

<details><summary>Academy, stack, templates active passive, tuning, minor, major, etc </summary>
<p>

#### We can hide anything, even code!

Zabbix Academy

* https://academy.zabbix.com/courses


* Zabbix blog

https://blog.zabbix.com/

* Zabbix Stack

https://github.com/spawnmarvel/linux-and-azure/blob/main/azure-extra-linux-vm/zabbix_monitoring_vms/README_stack.md

* Zabbix Tuning

https://github.com/spawnmarvel/linux-and-azure/blob/main/azure-extra-linux-vm/zabbix_monitoring_vms/README_tuning.md

* Zabbix Templates, active passiv

https://github.com/spawnmarvel/linux-and-azure/blob/main/azure-extra-linux-vm/zabbix_monitoring_vms/templates/README_templates.md

* Zabbix User parameter advanced

https://github.com/spawnmarvel/linux-and-azure/blob/main/azure-extra-linux-vm/zabbix_monitoring_vms/README_stack.md#user-parameter-advanced

* Zabbix minor upgrade

https://github.com/spawnmarvel/linux-and-azure/blob/main/azure-extra-linux-vm/zabbix_monitoring_vms/README_upgrade_zabbix_host_one.md

* Zabbix major upgrade

https://github.com/spawnmarvel/linux-and-azure/blob/main/azure-extra-linux-vm/zabbix_monitoring_vms/README_upgrade_zabbix_major.md

* Zabbix SSL

https://github.com/spawnmarvel/linux-and-azure/blob/main/azure-extra-linux-vm/zabbix_monitoring_vms/README_https_zabbix.md

APT sources out

Ubuntu, MySql, PHP:
* etc/apt/sources.list.d$ cat ubuntu.sources
* * archive.ubuntu.com (80, 443)
* * patches for vulnerabilities security.ubuntu.com (80, 443)
Zabbix:
* repo.zabbix.com** → whitelist that domain (port 443)
* * etc/apt/sources.list.d$

</p>
</details>

https://github.com/spawnmarvel/linux-and-azure/blob/main/azure-extra-linux-vm/zabbix_monitoring_vms/README_stack.md

### Elastic stack :traffic_light:

Ubuntu.

https://github.com/spawnmarvel/linux-and-azure/blob/main/azure-extra-linux-vm/kibana-elasticsearch-file-beat/README.md

### Grafana Zabbix

Ubuntu.

Play with dasboards and more.

https://github.com/spawnmarvel/linux-and-azure/tree/main/azure-extra-linux-vm/grafana-zabbix

### RabbitMQ

Ubuntu.

* RabbitMQ ubuntu shovel test new versions mtls = GOTO TBD, TLS amqp05_server.cloud TODO

https://github.com/spawnmarvel/linux-and-azure/tree/main/azure-extra-linux-vm/rabbitmq-server

### Telegraf

Ubuntu/Windows

* input: file, amqp, disk, cpu
* output: file, amqp, zabbix

https://github.com/spawnmarvel/linux-and-azure/tree/main/azure-extra-linux-vm/telegraf

* Docs

https://docs.influxdata.com/telegraf/v1/

## Docker :helicopter:

Ubuntu.

* 1 Learning-docker

https://github.com/spawnmarvel/learning-docker

### Docker, Azure and DevOps :airplane:

* Course AZ-2008-A: DevOps Foundations: The Core Principles and Practices

https://learn.microsoft.com/en-us/training/courses/az-2008

* 2 Azure Devops

https://github.com/spawnmarvel/learning-docker/blob/main/README-devops.md


* Run Docker containers on-demand in a managed, serverless Azure environment.

https://learn.microsoft.com/en-us/azure/container-instances/

* Build, store, and manage container images and artifacts in a private registry for all types of container deployments

https://learn.microsoft.com/en-us/azure/container-registry/


* Ms Learn 47 results for "devops" and "Azure"

https://learn.microsoft.com/en-us/training/browse/?source=learn&terms=devops&products=azure

### Docker Solr

https://github.com/spawnmarvel/learning-docker/tree/main/prod-ish/solr

### Docker Elastic stack

* Elasticsearch and Kibana in docker
* Filebeat on remote vm's

### Docker RabbitMQ

https://github.com/spawnmarvel/learning-docker/blob/main/prod-ish/rmq/rmq-ssl/README.md

## Azure-automation-bicep-and-labs :muscle:

https://github.com/spawnmarvel/azure-automation-bicep-and-labs

## AZ-104 certified professional must know :sunglasses: :+1: :+1:

https://github.com/spawnmarvel/azure-automation-bicep-and-labs/tree/main/az-104-certified-professional

## quickguides :fire_engine:

* Apache Tomcat and Solr

Ubuntu.

```code
Optimization after
Fix stdout
```

https://github.com/spawnmarvel/quickguides/blob/main/apache_tomcat_and_solr/README.md

* amqp
* * Requests and renew certificate

https://github.com/spawnmarvel/quickguides/blob/main/amqp/RequestRenewExample/README.md

* * CSR and Certificate Decoder

https://certlogik.com/decoder

* * Erlang 26

https://github.com/spawnmarvel/quickguides/blob/main/amqp/Readme.md#erlang-26

* Azure Administrator AZ-104 quick guide for repeat
* bash
* cogent
* event hub
* etc

https://github.com/spawnmarvel/quickguides

* Prosys OPC UA sim, Cogent OPC UA client, InfluxDB, OPC UA expert, db21

https://github.com/spawnmarvel/quickguides/blob/main/cogent-opcua-influxdb/README.md

* Computer Science

https://github.com/spawnmarvel/quickguides/blob/main/computer-science/README.md

## Releases :newspaper: :exclamation:

* Releases/Notes/Updates Gemini
* * https://gemini.google/release-notes/
* Releases/Notes/Updates Az-104
* * https://learn.microsoft.com/en-us/training/browse/?terms=az-104&source=learn&roles=administrator&products=azure&resource_type=learning%20path
* Release/Notes/Updates Zabbix
* * https://www.zabbix.com/release_notes 
* Release/Notes/Updates MySql
* * https://dev.mysql.com/doc/relnotes/mysql/8.0/en/
* Release/Notes/Updates RabbitMQ
* * https://www.rabbitmq.com/release-information
* Release/Notes/Updates Telegraf
* * https://docs.influxdata.com/telegraf/v1/release-notes/
* Release/Notes/Updates Docker
* * https://docs.docker.com/tags/release-notes/
* Releases/Notes/Updates Aspentech
* * https://esupport.aspentech.com/apex/S_Homepage





