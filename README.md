# Todo-and-current :seedling:

- Readme with todo-and-current.
- Ai as helper, Gemini.
- "There is no finish line. You simply change courses and keep running."
- One thing at a time.

## Plan :bell:

* Log monitor Q2 2026 Elastic stack
* Docker Basic to DevOps 2025/2026
* learning-docker dmzdocker0
* * Work with ElasticStack
* * Work with Solr
* Then the AZ-2008, jump to the docker section and do azure container registry and instance.
Then Github actions-> Github self-hosted runners
Misc
* Bash Tutorial REPEAT and REPEAT and simple docker

Misc

* Install Apache Tomcat on dmzwindows07
* * Host it in IIS
* Host Python Flask check and tune logs
* Tomcat Apache logging (fix this 1 out of 3), Solr misc
* * Apache Tomcat and Solr windows fix logging 1 out of 3, optimization after scan
* * https://github.com/spawnmarvel/quickguides/tree/main/apache_tomcat_and_solr
* Upgrade Apache Tomcat 
* Set up OPC UA, and work more with OPC DA CIMIO / datatech Connect test push
* * Prosys OPC UA sim, Cogent OPC UA client, InfluxDB, OPC UA expert, db21
* * https://github.com/spawnmarvel/quickguides/blob/main/cogent-opcua-influxdb/README.md
* More IP21, repos, cache, sort tags in folders, cmh files for guides
* * Quick start and Administration tools
* Zabbix
* * Do more below and check v 7
* SNMP
* * Telegraph SNMP
* * https://github.com/spawnmarvel/linux-and-azure/blob/main/azure-extra-linux-vm/telegraf/README_telegraf_snmp.md
* Do more Oracle Database Express Edition (XE) 21c CRUD and password
* * https://github.com/spawnmarvel/quickguides/blob/main/oracle/README.md
* Azure SQL tutorial (Azure Free sql) BikeStores & AdventureWorks
* * https://github.com/spawnmarvel/t-sql/tree/master/course2_ai


## Always :repeat:

* dmzwindows07 server run windows updates on it
* All linux servers, run updates

## Linux :hotel:

https://github.com/spawnmarvel/linux-and-azure

### Linux quick guide grep it :steam_locomotive:

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

### Linux mind maps :steam_locomotive:

https://github.com/spawnmarvel/linux-and-azure/tree/main/z-mind-maps

### Bash tutorial, repeat, repeat and repeat :rocket: :repeat: :rocket:

<details><summary>Commands bash course quick guide</summary>
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

https://www.w3schools.com/bash/bash_commands.php


### Zabbix stack :traffic_light:


Ubuntu, MySql, PHP:
* etc/apt/sources.list.d$ cat ubuntu.sources
* * archive.ubuntu.com (80, 443)
* * patches for vulnerabilities security.ubuntu.com (80, 443)
Zabbix:
* repo.zabbix.com** → whitelist that domain (port 443)
* * etc/apt/sources.list.d$

https://github.com/spawnmarvel/linux-and-azure/blob/main/azure-extra-linux-vm/zabbix_monitoring_vms/README_stack.md

### Elastic stack :traffic_light:


https://github.com/spawnmarvel/linux-and-azure/blob/main/azure-extra-linux-vm/kibana-elasticsearch-file-beat/README.md

### RabbitMQ :traffic_light:

* RabbitMQ ubuntu shovel test new versions mtls = GOTO TBD, TLS amqp05_server.cloud TODO

https://github.com/spawnmarvel/linux-and-azure/tree/main/azure-extra-linux-vm/rabbitmq-server

## Docker :helicopter:

https://github.com/spawnmarvel/learning-docker

### Docker, Azure and DevOps :airplane:

https://github.com/spawnmarvel/learning-docker/blob/main/README-devops.md


* Course AZ-2008-A: DevOps Foundations: The Core Principles and Practices

https://learn.microsoft.com/en-us/training/courses/az-2008


* Ms Learn 47 results for "devops" and "Azure"

https://learn.microsoft.com/en-us/training/browse/?source=learn&terms=devops&products=azure

### Docker Solr

https://github.com/spawnmarvel/learning-docker/tree/main/prod-ish/solr

### Docker RabbitMQ

https://github.com/spawnmarvel/learning-docker/blob/main/prod-ish/rmq/rmq-ssl/README.md

## Azure-automation-bicep-and-labs :muscle:

https://github.com/spawnmarvel/azure-automation-bicep-and-labs

## AZ-104 certified professional must know :sunglasses: :+1: :+1:

https://github.com/spawnmarvel/azure-automation-bicep-and-labs/tree/main/az-104-certified-professional

## quickguides :fire_engine:

* Apache Tomcat and Solr

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

* https://gemini.google/release-notes/
* https://learn.microsoft.com/en-us/training/browse/?terms=az-104&source=learn&roles=administrator&products=azure&resource_type=learning%20path
* https://www.rabbitmq.com/release-information
* https://www.zabbix.com/release_notes
* https://dev.mysql.com/doc/relnotes/mysql/8.0/en/
* https://docs.influxdata.com/telegraf/v1/release-notes/
* https://docs.docker.com/tags/release-notes/
* https://github.com/spawnmarvel/quickguides/tree/main/cogent-opcua
* Az-104 updates
* * https://learn.microsoft.com/en-us/training/browse/?source=learn&terms=az-104&products=azure



