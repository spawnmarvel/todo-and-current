# Todo-and-current :seedling:

Readme with todo-and-current, Ai as helper, Gemini.

* Manage workflow (Slipknot/Trance/Music in general is the cure)
* Optimize your environment
* Adjust your mindset and habits

#### E-lo (parked) :anchor:

https://follow-e-lo.com/

### Scripting (and what's fun*)

Bash.sh, powershell.ps1, sql.sql, python.py, Docker, think automation, idempotent.

---

### Github

How to Fix the "Rejected" Push, hint: Updates were rejected because the tip of your current branch is behind.

This usually happens if you edited a file (like a README or .gitignore) directly on the GitHub website or if you pushed changes from a different machine.

```bash
# Option 2: The Clean Way (Rebase) - Recommended
# This is often preferred because it takes your local changes, "lifts" them up, pulls the remote changes, 
# and then puts your changes back on top. It keeps the history linear and clean.

git pull --rebase origin main
git push origin main

```

## Chaos Engineer bash vmchaos09

"Chaos Engineer" and the "SysAdmin"

https://github.com/spawnmarvel/todo-and-current/tree/main/bash_chaos_engineer

## TODO Maintain knowledge

1. Linux maintenance: Do use chromebook Debian GNU/Linux 12 (bookworm), do not install any GUI, chromebook is for command line only

    ```bash
    # on chromebook
    sudo apt update -y
    sudo apt upgrade -y
    # every now and then
    df -h
    sudo apt autoremove && sudo apt autoclean
    ```
    - :white_check_mark: Do a test for upgrade Azure Database for MySQL flexible server 8-8.4, zabbix 6.0.43 = 100% success saved in linux-and-azure/zabbix_monitoring_vms
    - :white_check_mark: Do install offline zabbix agent from *.deb = 100% success
    - Do the mirror-server = 50%
    - Do the bash tutorial w3s and make a good quick guide = 50%
    - Do make a proxy for the on premises 7.0.22, vmzabbix02proxy push/active vmzabbix02 =  
    - Do proxy readme proxy and architecture saved in linux-and-azure/zabbix_monitoring_vms = 
    - Do send trapper data to proxy =
    - Do proxy with grafana plugin = 
    - Do SNMP with zabbix
    - :white_square_button:Do https = always openssl
    - :white_square_button:Do Chaos Engineer bash vmchaos09

2. MySql maintenace:
    - Do the w3s tutorial in mysql cli
    - Make a quick guide CRUD/DML/DCL and tips together with cmd`s.
    - :white_square_button: Focus on the basic and also Zabbix tips and tricks.
    - :white_square_button: Azure Database for MySQL flexible server
    - Do install mysql localhost
    - Do MySQL replication to Azure Flexible server from local, local is source az is replica

3. Az-104 administrator mainteance:
    - :white_check_mark: Do Azure Ubuntu's update azure-automation-bicep-and-labs
/az-automation-runbook = 100 % success 
    - :white_check_mark: Do Azure Ubuntu's update, set up alert and log also to a storage account = 90%
    - :white_check_mark: Do Azure Ubuntu's update, set Automatic Module Update = 
    - Do Vm tutorials from docs = 


4. Python maintenance:
    - :white_square_button: Code a few lines every now and then.
    - Do py-central-monitor, fix the database logic, send always and store in file also, then update database 
    - Below is parked for now:
    - Do a build then push and pull to Docker hub, parked :anchor:
    - Do Make small changes in python frequently, set container always run, parked :anchor:
 

5. Docker maintenance, parked :anchor::
      - Do follow up on prod-2 stuff.
      - :white_check_mark: Do Portainer = 100% success
      - Do MySQL, Grafana (and plugins) = 70 % success, we wait
      - :white_check_mark: Do the nemesis: Zabbix = 100% success
      - Do send push and pull from vm = 
      - Do https = 
      - Do alter zabbix_server.conf = 
---

## TODO 1 Bash tutorial, repeat, repeat and repeat :rocket: :repeat: :rocket:

* Go over all chapters = 
* Mirros server and apt updates = 50%

https://github.com/spawnmarvel/todo-and-current/blob/main/bash/README_bash.md


--- 

## TODO 2 Docker, Azure :airplane:

* Python as container in docker (the getting started docker) = 

https://github.com/spawnmarvel/learning-docker/blob/main/1.3-containerize-python-application-2/README.md

* Then Implement containerized solutions
* Do tutorials = 
* Do RabbitMQ
* Do Python application
* Do

https://github.com/spawnmarvel/learning-docker/blob/main/1.4-azure-container-instance-2/README.md

---

## TODO 3 Docker :helicopter:

* Portainer = ok
* Grafana and MySQL with http and https = ok
* Zabbix plugin = ok
* Grafana and MySQL, https, Loki and Alloy on remote servers = 
* Zabbix nemisis = https://github.com/spawnmarvel/learning-docker/tree/main/prod-ish-2/zabbix
* RabbitMQ = 
* RabbitMQ shovel http and https = 

https://github.com/spawnmarvel/learning-docker

## TODO (Always) AZ-104 certified professional must know, fill the gaps here (network, monitor, web apps)

* Azure vm tutorials (after that network tutorials, end loop over all areas indepth for az-104 and beyond)

https://github.com/spawnmarvel/azure-automation-bicep-and-labs/tree/main/az-104-vm

* Repeat, repeat and repeat stuff

https://github.com/spawnmarvel/azure-automation-bicep-and-labs/tree/main/az-104-certified-professional

* Azure speed test

https://www.azurespeed.com/Azure/Latency

## TODO MS Learn misc

* Secure Windows Server user accounts

https://learn.microsoft.com/en-us/training/modules/secure-windows-server-user-accounts/?source=recommendations

* Secure group managed service accounts

https://learn.microsoft.com/en-us/entra/architecture/service-accounts-group-managed?source=recommendations

## TODO (for fun) Azure SQL Database

https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-sql/README.md

---

## Network advanced tutorial and checklist

https://follow-e-lo.com/network-and-netsh/

## Linux :hotel:

* UFW, SSH, PS1, Bash quick ref, file system hierarchy, grep, tail, script, env, cron, py

https://github.com/spawnmarvel/linux-and-azure

### Linux quick guide grep it

https://github.com/spawnmarvel/todo-and-current/blob/main/bash/README_bash.md

and the zabbix troubleshoot

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






