# Todo-and-current :seedling:

Readme with todo-and-current, Ai as helper, Gemini.

### Shuhari model and 2,3,5,7 revision method

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

### Manage workflow (Slipknot is the cure)

* Prioritize tasks: Create a to-do list and tackle the most important or difficult tasks first to avoid procrastination and clear your mind.
* Focus on one task at a time: Multitasking can decrease efficiency. Concentrate on a single task until it's complete before moving to the next.
* Use time-blocking and Break large tasks into smaller chunk

### Optimize your environment

* Minimize distractions
* Declutter your workspace:
* Listen to focus-enhancing music


### Adjust your mindset and habits

* Embrace "done is better than perfect":
* Take regular breaks
* Automate repetitive tasks

## Parked e-lo

https://follow-e-lo.com/

## Scripting (and what's fun*)

* SQL*, Powershell*,  Bash*,
* Python, Docker
* Think automation, idempotent, .sql .ps1, .sh

---

## TODO: Bash tutorial, repeat, repeat and repeat :rocket: :repeat: :rocket:

* Go over all chapters

https://github.com/spawnmarvel/todo-and-current/blob/main/bash/README_bash.md


--- 

## TODO Docker :helicopter:

* Grafana and MySQL with http and https
* Zabbix plugin
* Grafana and MySQL, https, Loki and Alloy on remote servers
* Zabbix nemisis
* RabbitMQ
* RabbitMQ shovel http and https

https://github.com/spawnmarvel/learning-docker

## TODO Docker, Azure and Github :airplane:

* Azure and GitHub integration

https://github.com/spawnmarvel/learning-docker/tree/main/az-github-actions-for-azure

* Self-hosted runners github

https://github.com/spawnmarvel/learning-docker/tree/main/az-github-self-hosted-runners


* Run Docker containers on-demand in a managed, serverless Azure environment.
* https://learn.microsoft.com/en-us/azure/container-instances/

* Build, store, and manage container images and artifacts in a private registry for all types of container deployments
* https://learn.microsoft.com/en-us/azure/container-registry/

---

## TODO AZ-104 certified professional must know, fill the gaps here (network, monitor, web apps)

* Repeat, repeat and repeat stuff

https://github.com/spawnmarvel/azure-automation-bicep-and-labs/tree/main/az-104-certified-professional

* Introduction to Azure Functions

https://learn.microsoft.com/en-us/training/paths/create-serverless-applications/

---

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

### Linux ubuntu mirror server

https://github.com/spawnmarvel/linux-and-azure/tree/main/azure-extra-linux-vm-mirror

### Ubuntu server documentation

https://documentation.ubuntu.com/server/

## Apache Tomcat (Solr) (Deleted server, is archive)

Windows.

Install java, apache tomcat, learn logs, install solr, upgrade apache.

<details><summary>Overview of plan</summary>
<p>

#### We can hide anything, even code!

* Install Apache Tomcat on dmzwindows07
* Fix log levels and log size of apache

* (fix this 1 out of 3)
* Install solr
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


Zabbix 7 Browser items

* https://www.zabbix.com/documentation/7.0/en/manual/config/items/itemtypes/browser

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

### Elastic stack :traffic_light: (Deleted server, is archive)

Ubuntu.

https://github.com/spawnmarvel/linux-and-azure/blob/main/azure-extra-linux-vm/kibana-elasticsearch-file-beat/README.md

### Grafana Zabbix (Deleted server, is archive)

Ubuntu.

* Play with dasboards and more.

https://github.com/spawnmarvel/linux-and-azure/tree/main/azure-extra-linux-vm/grafana-zabbix

* Grafana Agent is an OpenTelemetry Collector

https://grafana.com/docs/agent/latest/

### RabbitMQ (Deleted server, is archive)

Ubuntu.

* RabbitMQ ubuntu shovel test new versions mtls = GOTO TBD, TLS amqp05_server.cloud TODO

https://github.com/spawnmarvel/linux-and-azure/tree/main/azure-extra-linux-vm/rabbitmq-server


* X.509 Shovel, then amqp_client is not needed.

https://github.com/spawnmarvel/quickguides/blob/main/amqp/x509/vm1_advanced_11.config


* Requests and renew

https://github.com/spawnmarvel/quickguides/blob/main/amqp/RequestRenewExample/README.md

### Telegraf

Ubuntu/Windows

* input: file, amqp, disk, cpu
* output: file, amqp, zabbix

https://github.com/spawnmarvel/linux-and-azure/tree/main/azure-extra-linux-vm/telegraf

* Docs

https://docs.influxdata.com/telegraf/v1/


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
* Sqlite
* * https://sqlite.org/index.html






