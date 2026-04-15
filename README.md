# Todo-and-current :seedling:

<details>

<summary>Readme with todo-and-current, Ai as helper, Gemini, Dark mode Win 11</summary

* Manage workflow (Slipknot/Trance/Music in general is the cure)
* Optimize your environment
* Adjust your mindset and habits

--- 
To enable Dark Mode in Windows 11, go to Settings > Personalization > Colors and select "Dark" under "Choose your mode". This applies a dark gray theme to system backgrounds, apps, the taskbar, and the Start menu, reducing screen brightness for lower-light environments.


The best computer screen background colors to reduce eye strain are soft, low-intensity, or muted tones. Light green, pale yellow, and soft beige are often recommended for long-term comfort. For darker environments, dark grey or warm brown backgrounds with light text reduce strain, while bright white should be avoided.


</details>

---

<details>

<summary>E-lo (parked) :anchor:</summary>

https://follow-e-lo.com/

</details>

---
### Bash/ps1 for admin, zabbix_sender, telegraf (?), Python for complex

<details>

<summary>Scripting automation, idempotent.</summary>

* Linux bash, cron, python, zabbix_sender,  telegraf
* Windows powershell, schedule task, zabbix_sender, telegraf
* Python for complexity 
* MySql, Sqlplus
* Telegraf, https://github.com/influxdata/telegraf

</details>

---

<details>

<summary>Github tips</summary>

How to Fix the "Rejected" Push, hint: Updates were rejected because the tip of your current branch is behind.

This usually happens if you edited a file (like a README or .gitignore) directly on the GitHub website or if you pushed changes from a different machine.

```bash
# Option 2: The Clean Way (Rebase) - Recommended
# This is often preferred because it takes your local changes, "lifts" them up
# , pulls the remote changes, and then puts your changes back on top.
#  It keeps the history linear and clean.

git pull --rebase origin main
git push origin main

```

</details>

---

<details>

<summary>VSC extension bash, git bash for windows</summary>

🛠️  Bash IDE

* Jump to declaration
* Find references
* Code Outline & Show Symbols
* Highlight occurrences
* Code completion
* Simple diagnostics reporting
* Documentation for flags on hover

🛠️ Option 1: Git Bash (Simplest & Most Common)
If you have Git installed on Windows, you already have "Git Bash." This is the easiest way to get a Linux-like terminal inside VS Code.

🔹 How to set it up:

* Open VS Code.
* Press Ctrl + `  (backtick) to open the terminal.
* On the right side of the terminal window, click the + (plus) icon dropdown.
* Select Select Default Profile.
* Choose Git Bash.

Now, when you open a new terminal, you can just type ./your_script.sh to play your game.

</details>

---

<details>

<summary>AD DS mhybrid01 is DC and DNS server</summary>

Nb: Outbund from vm's ? vmhybrid01 is DC is responsible for (it must be running)

* Step C: The Azure "Bridge" (In the Portal) use domain controller vm as DNS server
* By doing this at the VNet level, every other VM you create in the future will automatically use vmhybrid01 as its DNS server via DHCP. This makes "Domain Joining" other VMs effortless.
* The "Forwarder" Requirement: Now that your VNet is pointing to your DC for DNS, your DC is responsible for resolving the internet.

https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-800-admistering-windows-server-hybrid-core-infrastructure/README_cloud-only-hybrid-Lab_2_install-ad.md

</details>

<summary>Fast linuc vm? GOTO iac_fast_biceps</summary>

Deploy within 1 min and remove within 1 min, autoshutdown is also enabled if we forget to remove.
</details>

---

## TODO Maintain knowledge priority top 3 :seedling:

Well, this never stops, so lets make a priority list of all the topics below.

#### On all Azure vm (NO LOGIN) got to Operations->Run command (ps1 / sh)

### Bash, use it and talk it
   - Play around, the basics are in now.
   - Continue the ***countries game***, expand and expand, use bash commands as normal commands
   - Expand it, do more
   - Make matrix stuff also on the screen/ effects, launch it online

### 1. Octopus Deploy for linux (is 2 in one CI/CD)
   - Use IAC linux vm for fast deploy and remove
   - Two projects (win/lin) and 100's of runbooks, we do linux project for now
   - Do all linux apps and day 2 operations in:
   - Do Diagnostics, normal linux commands
   - Do upload packets and variables ** Use more time here
   - Do install software MySQL, etc
   - Do follow the guide in
   - - https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/README_octo_linux_runbook_operations.md

![deploy123](https://github.com/spawnmarvel/todo-and-current/blob/main/images/deploy123.png)

### 2. Windows Server Hybrid Administrator vmhybrid01
   - Continue with MS learn Active Directory
   - MS learn Arc
   - MS learn file sync
   - - GOTO step 3 below for actual timeline and tasks

### 3. Grafana, loki and configure alloy agents
   - Set it up and start with log monitoring using that stack
   - Saved in TODO repos



--- 

### Maintain knowledge checklist

Do use chromebook Debian GNU/Linux 12 (bookworm), do not install any GUI, chromebook is for command line only

```bash
# on chromebook
sudo apt update -y
sudo apt upgrade -y
# every now and then
df -h
sudo apt autoremove
sudo apt autoclean

# Bash won't show ghost text, but it has Programmable Completion.
# type ssh, cd, pwd, ls, and then hit the Tab key once or twice.

```
1. :bulb: Linux maintenance:
    
    - :white_check_mark:  Do the bash tutorial w3s and make a good quick guide = 100%
    - Do bash rpg game like UIB = 60%
    - :white_check_mark: Do install offline zabbix agent from *.deb = 100%
    - Do the mirror-server = 50%
    - - Saved in azure-extra-linux-vm-mirror
    - Do proxy readme proxy and architecture = 100%
    - :white_check_mark: Do make a proxy for the on premises 7.0.22, vmchaos09 push/active vmzabbix02 = 100% 
    - :white_check_mark: Do send agent proxy data to main = 100%
    - :white_check_mark: Do proxy  = 
    - - Saved in /zabbix_monitoring_vms
    - Do SNMP with zabbix
    - - Saved in /zabbix_monitoring_vms
    - :white_check_mark: Do linux Vm updates are now on autmation runbook, tag Patching: Weekly, Mondays 09:00 = 100%
    - - Saved in az-automation-runbook-and-choices
    - :white_square_button:Do https = always openssl
    - :white_square_button:Do Chaos Engineer bash vmchaos09
    - :white_square_button:Do use Octupus (free) for CD (zabbix, mysql etc)

```bash
# Turn those commands into a Bash or PowerShell script. Replace hardcoded values with variables for automation.
# Bad: 
mysql --user=root --password=Password123
# Good: 
mysql --user=#{MySQL.User} --password=#{MySQL.Password}
```

2. MySql maintenace:
    - Do the w3s tutorial in mysql cli
    - Make a quick guide CRUD/DML/DCL and tips together with cmd`s.
    - Do performance tuning 
    - :white_check_mark: Do upgrade Azure Database for MySQL flexible server 8-8.4, zabbix 6.0.43 = 100%
    - - Saved in /zabbix_monitoring_vms
    - :white_check_mark: Do install mysql localhost = 100%
    - Do MySQL replication to Azure Flexible server from local, local is source az is replica
    - :white_square_button: Focus on the basic and also Zabbix tips and tricks.
    - :white_square_button: Azure Database for MySQL flexible server
    - :white_square_button: MySQL workbench and cli

3. :bulb: AZ-802: Windows Server Hybrid Administrator (june 2026)
   - :white_check_mark: AD DS is installed  = 100%
   - :white_check_mark: Do The "Cloud-Only" Hybrid Lab (to get some hand on) = 100%
   - :bulb: Do the MS learn Active Directory Domain Services = 
   - :bulb: Do the MS Azure Arc = 
   - :bulb: Do the MS Azure File sync = 
   - - vmhybrid01
   - - Then jump to AZ-802 Windows Server Hybrid Administrator Study Guide in june 2026 (maybe)
   - - Saved in https://github.com/spawnmarvel/azure-automation-bicep-and-labs/tree/main/az-ad-ds-windows-server-hybrid-core-infrastructure
  

4. Octopus deploy (free)
   - :white_check_mark: Do first deployment windows, project, relase, step, process and vars, push deploy to target = 100%
   - :white_check_mark: Do first deployment linux, project, relase, step, process and vars, push deploy 2 target = 100%
   - :white_check_mark: Do tutorial first Runbok = 100%
   - Do project Linux Day2 Operations
   - Do Diagnostics, normal linux commands = 100%
   - Do upload packets and variables = 
   - Do install software MySQL, etc = 
   - Do all linux apps and day 2 operations in:
   - - https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/README_runbook_linux_tips.md




--- 

5. Az-104 administrator mainteance:
    - :white_check_mark: Do Vm updates with azure automation runbook ps1 = 100%
    - :white_check_mark: Do update all Vms with tag Patching: Weekly, Mondays 09:00 = 100%
    - :white_check_mark: Do stop Azure Database for MySQL flexible server with autmation runbook Sundays 23:00 = 100%
    - :white_check_mark: Do azure automation set up alert = 
    - :white_check_mark: Do runbook keyvault = not needed for managed identity = 100%
    - Do runbook store account file uplpad
    - - Saved in az-automation-runbook-and-choices
    - Do Vm tutorials from docs = 
    - :white_square_button: Do azure automation for save cost/mainteance and check Automatic Module Update
    - :white_square_button: Do add start/stop vmhybrid01 is DC is responsible for internet (it must be running)

---

# Below is parked, go up.

Misc / wait / parked

6. (Python maintenance:)
    - :white_square_button: Code a few lines every now and then.
    - Do py-central-monitor, fix the database logic, send always and store in file also, then update database 
    - Below is parked for now:
    - Do a build then push and pull to Docker hub, parked :anchor:
    - Do Make small changes in python frequently, set container always run, parked :anchor:
 

7. (Docker maintenance, parked :anchor:)
      - Do follow up on prod-2 stuff.
      - :white_check_mark: Do Portainer = 100% success
      - Do MySQL, Grafana (and plugins) = 70 % success, we wait
      - :white_check_mark: Do the nemesis: Zabbix = 100% success
      - Do send push and pull from vm = 
      - Do https = 
      - Do alter zabbix_server.conf = 

---


## Done 1 Bash tutorial, repeat, repeat and repeat :rocket: :repeat: :rocket:

* Go over all chapters = 100%
* Mirros server and test with zabbix apt = 100%

https://github.com/spawnmarvel/todo-and-current/blob/main/bash/README_bash.md


--- 

## Parked 2 Docker, Azure :airplane:

* Python as container in docker (the getting started docker) = 

https://github.com/spawnmarvel/learning-docker/blob/main/1.3-containerize-python-application-2/README.md

* Then Implement containerized solutions
* Do tutorials = 
* Do RabbitMQ
* Do Python application 
* Do

https://github.com/spawnmarvel/learning-docker/blob/main/1.4-azure-container-instance-2/README.md

---

## TBD 3 Docker :helicopter:

* Portainer = ok
* Grafana and MySQL with http and https = ok
* Zabbix nemisis = is done https://github.com/spawnmarvel/learning-docker/tree/main/prod-ish-2/zabbix
* Zabbix plugin = ok
* Grafana and MySQL, https, Loki and Alloy on remote servers = 
* RabbitMQ = 
* RabbitMQ shovel http and https = 

https://github.com/spawnmarvel/learning-docker

## (Always) AZ-104 certified professional must know, fill the gaps here (network, monitor, web apps)

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

## TBD (for fun) Azure SQL Database

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






