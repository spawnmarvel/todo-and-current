# Todo & Current :seedling:

A comprehensive knowledge base combining technical wiki, todo list, and learning progress tracker.

## Philosophy
- Manage workflow (Slipknot/Trance/Music in general is the cure)
- Optimize your environment
- Adjust your mindset and habits

---


# Table of Contents all headers

<details>
<summary>Show / hide Table of Contents</summary>

- [Todo \& Current :seedling:](#todo--current-seedling)
  - [Philosophy](#philosophy)
- [Table of Contents all headers](#table-of-contents-all-headers)
  - [Table of Contents main headers](#table-of-contents-main-headers)
  - [Setup \& Environment](#setup--environment)
    - [Windows 11 Dark Mode](#windows-11-dark-mode)
    - [Screen Background for Eye Strain](#screen-background-for-eye-strain)
    - [Chromebook Linux Maintenance](#chromebook-linux-maintenance)
  - [Elo parked](#elo-parked)
  - [Scripting Stack](#scripting-stack)
  - [GitHub Copilot and Development](#github-copilot-and-development)
    - [Using GitHub Copilot Workflow](#using-github-copilot-workflow)
    - [Asking for Help](#asking-for-help)
    - [Coding mode](#coding-mode)
    - [Git Common Tasks](#git-common-tasks)
      - [Fix "Rejected" Push](#fix-rejected-push)
    - [VS Code Extensions \& Setup](#vs-code-extensions--setup)
      - [Extensions (chromebook)](#extensions-chromebook)
      - [Setting Up Git Bash Terminal in VS Code](#setting-up-git-bash-terminal-in-vs-code)
  - [Infrastructure Essentials hybrid](#infrastructure-essentials-hybrid)
    - [Azure VM Operations](#azure-vm-operations)
    - [AD DS Configuration (vmhybrid01)](#ad-ds-configuration-vmhybrid01)
  - [Fast Linux VM Deployment IAC](#fast-linux-vm-deployment-iac)
  - [Current Priorities: TOP 3](#current-priorities-top-3)
    - [1. Grafana, Loki, and Alloy Agents and Zabbix default ⭐](#1-grafana-loki-and-alloy-agents-and-zabbix-default)
    - [2. Octopus Deploy for Linux (CI/CD) ⭐](#2-octopus-deploy-for-linux-cicd-)
    - [3. Windows Server Hybrid Administrator (vmhybrid01) ⭐](#3-windows-server-hybrid-administrator-vmhybrid01-)
  - [Knowledge Maintenance Checklist](#knowledge-maintenance-checklist)
    - [1. Linux Continous](#1-linux-continous)
    - [2. MySQL Continous](#2-mysql-continous)
    - [3. AZ-802: Windows Server Hybrid Administrator Continous](#3-az-802-windows-server-hybrid-administrator-continous)
    - [4. Octopus Deploy Continous](#4-octopus-deploy-continous)
    - [5. AZ-104: Azure Administrator Continous](#5-az-104-azure-administrator-continous)
  - [Parked Projects or Completed Projects](#parked-projects-or-completed-projects)
    - [1. Docker \& Azure](#1-docker--azure)
    - [2. Docker Stack](#2-docker-stack)
    - [3. Python Maintenance (Parked)](#3-python-maintenance-parked)
    - [4. Azure SQL Database (For Fun)](#4-azure-sql-database-for-fun)
  - [Learning Resources and References](#learning-resources-and-references)
    - [1. AZ-104: Certified Professional Must Know](#1-az-104-certified-professional-must-know)
    - [2. Linux Resources](#2-linux-resources)
    - [3 Linux Quick Guides (Azure, zabbix troubleshoot, mind maps, mirror server, ubuntu docs)](#3-linux-quick-guides-azure-zabbix-troubleshoot-mind-maps-mirror-server-ubuntu-docs)
    - [4. Zabbix Stack :traffic\_light:](#4-zabbix-stack-traffic_light)
      - [4.1 Resources](#41-resources)
      - [4.2 Setup \& Configuration](#42-setup--configuration)
      - [4.3 Upgrades](#43-upgrades)
      - [4.4 APT Sources](#44-apt-sources)
    - [5. Apache Tomcat \& Solr (Windows) - Archived](#5-apache-tomcat--solr-windows---archived)
    - [Archived Stacks](#archived-stacks)
    - [1.  Elastic Stack (Ubuntu) - Archived](#1--elastic-stack-ubuntu---archived)
    - [2. Grafana \& Zabbix (Ubuntu) - Archived](#2-grafana--zabbix-ubuntu---archived)
    - [3. RabbitMQ (Ubuntu) - Archived](#3-rabbitmq-ubuntu---archived)
    - [4. Telegraf](#4-telegraf)
    - [5. Docker RabbitMQ](#5-docker-rabbitmq)
    - [Main Project Repositories](#main-project-repositories)
      - [1 azure-automation-bicep-and-labs :muscle:](#1-azure-automation-bicep-and-labs-muscle)
      - [2 AZ-104 Certified Professional Must Know :sunglasses:](#2-az-104-certified-professional-must-know-sunglasses)
      - [3 Quickguides :fire\_engine:](#3-quickguides-fire_engine)
    - [Release Notes \& Updates](#release-notes--updates)
  - [Additional Resources](#additional-resources)

</details>

---

## Table of Contents main headers

- [🔹 Setup & Environment](#setup--environment)
- [🔹 Elo parked](#elo-parked)
- [🔹 Scripting Stack](#scripting-stack)
- [🔹 GitHub Copilot and Development](#github-copilot-and-development)
- [🔹 Infrastructure Essentials Hybrid](#infrastructure-essentials-hybrid)
- [🔹 Fast Linux VM Deployment IAC](#fast-linux-vm-deployment-iac)
- [🔹 Current Priorities: TOP 3](#current-priorities-top-3)
- [🔹 Knowledge Maintenance Checklist](#knowledge-maintenance-checklist)
- [🔹 Parked Projects or Completed Projects](#parked-projects-or-completed-projects)
- [🔹 Learning Resources and References](#learning-resources-and-references)
- [🔹 Additional Resources](#additional-resources)

---

## Setup & Environment

<details>
<summary>Show / hide Setup & Environment</summary>

### Windows 11 Dark Mode
Enable dark mode for reduced eye strain:
- Settings > Personalization > Colors
- Select "Dark" under "Choose your mode"
- Applies dark gray theme to system backgrounds, apps, taskbar, and Start menu

### Screen Background for Eye Strain
**Recommended colors:**
- **Light environments:** Light green, pale yellow, soft beige
- **Dark environments:** Dark grey or warm brown backgrounds with light text
- **Avoid:** Bright white backgrounds

### Chromebook Linux Maintenance
Use your Chromebook as command-line only (no GUI):
```bash
# Keeps system updated
sudo apt update -y
sudo apt upgrade -y

# Regular maintenance
df -h
sudo apt autoremove
sudo apt autoclean

# Bash Tip: Use Tab for Programmable Completion
# Type: ssh, cd, pwd, ls then press Tab once or twice
```

***Chromebook partial screen shot, take it and press enter***

</details>

---

## Elo parked

<details>
<summary>Show / hide E-lo (parked)</summary>
https://follow-e-lo.com/

</details>

---

## Scripting Stack

<details>
<summary>Show / hide Scripting Stack</summary>

Use technologies for their strengths:

| Platform          | Technologies                                        |
| ----------------- | --------------------------------------------------- |
| **Linux**         | Bash, cron, Python, Zabbix sender, Telegraf         |
| **Windows**       | PowerShell, Schedule tasks, Zabbix sender, Telegraf |
| **Complex Logic** | Python                                              |
| **Databases**     | MySQL, SQLPlus                                      |
| **ETL**           | Telegraf https://github.com/influxdata/telegraf     |

**Best Practice:** Turn commands into Bash or PowerShell scripts. Replace hardcoded values with variables:
```bash
# Bad: 
mysql --user=root --password=Password123

# Good: 
mysql --user=#{MySQL.User} --password=#{MySQL.Password}
```

</details>

---

## GitHub Copilot and Development

<details>
<summary>Show / hide</summary>

### Using GitHub Copilot Workflow
1. Create an issue with title, description, path, and steps
2. Navigate to your repo with VS Code
3. Press `Ctrl+Alt+I` (Windows/Linux) or `Cmd+Option+I` (macOS)
4. Paste the issue URL to the chat
5. Review live edits, keep or modify as needed
6. Commit and push changes

### Asking for Help

1. Ask Copilot to review your files: "Could we make this better and more readable?"
2. If you accept it, name this version 1
3. Ask Copilot to review your files: "Could we make this better and more readable?"
4. If you accept it, name this version 2
5. Make a toc, table of content


### Coding mode

0. This in in VSC
1. Start typing and it will give suggestions, accept with tab
2. To keep it, press Ctrl + Right Arrow key or accept or tab

📖 Learn more: [Copilot README](https://github.com/spawnmarvel/todo-and-current/blob/main/copilot/README.md)

</details>

---

### Git Common Tasks

<details>
<summary>Show / hide</summary>

#### Fix "Rejected" Push
When: "Updates were rejected because the tip of your current branch is behind"

This happens when you edited files directly on GitHub or pushed from a different machine.

**Solution (Rebase - Recommended):**
```bash
git pull --rebase origin main
git push origin main
```
</details>

---

### VS Code Extensions & Setup

<details>
<summary>Show / hide</summary>

#### Extensions (chromebook)

* Pylance ** 
* Python **
* Python Debugger
* Python Environments

* Shell-format
* Better Shell Syntax **
* Bash IDE **
  
- Jump to declaration
- Find references
- Code Outline & Show Symbols
- Highlight occurrences
- Code completion
- Simple diagnostics reporting
- Documentation for flags on hover

#### Setting Up Git Bash Terminal in VS Code

1. Open VS Code
2. Press `Ctrl + `` (backtick) to open terminal
3. Click the `+` dropdown on the right side
4. Select "Select Default Profile"
5. Choose "Git Bash"

Now run scripts directly: `./your_script.sh`

</details>

---

## Infrastructure Essentials hybrid

<details>
<summary>Show / hide</summary>

### Azure VM Operations
**Important:** On all Azure VMs, go to Operations > Run command (ps1 / sh)

### AD DS Configuration (vmhybrid01)
vmhybrid01 is the **DC and DNS server** - it must be running for network operations.

**Set Azure Bridge in Portal:**
- Use domain controller VM as DNS server for VNet
- This makes Domain Joining other VMs effortless
- DC becomes responsible for resolving internet traffic

📖 Reference: [Azure AD DS Install Guide](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-ad-ds-windows-server-hybrid-core-infrastructure/README_cloud-only-hybrid-Lab_2_install-ad.md)

</details>

---

## Fast Linux VM Deployment IAC


**GOTO:** `iac_fast_biceps` https://github.com/spawnmarvel/todo-and-current/tree/main/iac_fast_biceps
- Deploy within 1 min
- Connected to DNS server vmhybrid01
- Remove within 1 min
- Autoshutdown enabled (safety if forgotten)
- Firewall for 10933 is in main.bicep
- Scripts at storage account (or use below bash for Alloy and Tenatcle)
- Firewall (IP Addresses): Check the box that says "Add your client IP address".

- Install Grafana Alloy https://grafana.com/docs/alloy/latest/set-up/install/linux/

```bash
ssh
# run
# 1 Import the GPG key and add the Grafana package repository.
# Run the full script
# 2
sudo apt update
# 3 install
sudo apt install alloy
# 4 Check it
sudo systemctl status alloy.service
# 5 edit conf,  For a full configuration reference, see https://grafana.com/docs/alloy
# copy config https://github.com/spawnmarvel/todo-and-current/blob/main/grafana_loki_alloy/config_remote.alloy
# set the computer = "YOUR-VM-NAME.lab.local",
sudo nano /etc/alloy/config.alloy
# 5.1 By default, the alloy user cannot read /var/log/syslog on Ubuntu
sudo usermod -aG adm alloy
# 6 test config
# If it works: It will print a "clean" version of your config to the terminal.
# If it fails: It will give you a specific line number and error message (e.g., "expected block end, found }").
sudo alloy fmt /etc/alloy/config.alloy
# 7 test it in terminal
sudo alloy run /etc/alloy/config.alloy
# 7.1 stop it ctrl c
# 8 enable as service
sudo systemctl start alloy.service
sudo systemctl enable alloy.service
sudo systemctl status alloy.service

```
- Install Octopus Tenatcle linux

```bash
ssh
# 1 get it
wget https://download.octopusdeploy.com/linux-tentacle/tentacle_9.1.3801_amd64.deb
# 2 install it
sudo dpkg -i tentacle_9.1.3801_amd64.deb
# 3 To set up a Tentacle instance, run the following script:
/opt/octopus/tentacle/configure-tentacle.sh
# YOUR-VM-NAME-tenatcle
# Firewall is open in main.bicep
```
---

## Current Priorities: TOP 3

### 1. Grafana, Loki, and Alloy Agents and Zabbix default ⭐

**Goal:** Set up log monitoring stack loki

**Tasks:**
- Install and configure Grafana
- Configure Loki
- Deploy Alloy agents across infrastructure
- Monitor logs from all services
- Mastering LogQL (The "Query Language")
- Build main 3 dashboards
- Files [Grafana, Loki and Alloy](https://github.com/spawnmarvel/todo-and-current/tree/main/grafana_loki_alloy)

**Goal:** Set up log metric stack zabbix

**Tasks:**
- Use the stack we have and agent 2
- Windows by Zabbix agent active and user param
- Linux by Zabbix agent active and user param
- Linux by SNMP
- Use time on default templates
- Files [Zabbix monitor VM's and SNMP default](https://github.com/spawnmarvel/linux-and-azure/tree/main/azure-extra-linux-vm/zabbix_monitor_vms_snmp_default)

---

### 2. Octopus Deploy for Linux (CI/CD) ⭐

**Setup:**
- Use IAC Linux VM for fast deploy and remove
- Two projects: Windows & Linux
- Focusing on Linux project now

**Current Tasks:**
- Diagnostics using normal Linux commands ✅ 100%
- Upload packages and variables (needs more time)
- Install software (MySQL, etc.)
- All Linux apps and day 2 operations

**Guide:** [Octopus Linux Runbook Operations](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/README_octo_linux_runbook_operations.md)

**Progress:** ![deploy123](https://github.com/spawnmarvel/todo-and-current/blob/main/images/deploy123.png)

---

### 3. Windows Server Hybrid Administrator (vmhybrid01) ⭐

Exam target: **AZ-802** (June 2026)

**Completed:**
- ✅ AD DS is installed (100%)
- ✅ Cloud-Only Hybrid Lab completed (100%)

**In Progress:**
- 📚 MS Learn Active Directory Domain Services
- 📚 MS Learn Azure Arc
- 📚 MS Learn Azure File Sync

**Study Plan:**
- Complete all MS Learn modules
- Study guide: [Azure AD DS & Hybrid Infrastructure](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/tree/main/az-ad-ds-windows-server-hybrid-core-infrastructure)
- Schedule exam for June 2026

---



## Knowledge Maintenance Checklist

### 1. Linux Continous

**Completed:**
- ✅ Bash tutorial W3S + quick guide (100%)
- ✅ Zabbix agent offline install from .deb (100%)
- ✅ Proxy setup for on-premises (100%)
- ✅ Agent proxy data routing (100%)
- ✅ Linux VM updates automation runbook (100%) - Tag: `Patching: Weekly, Mondays 09:00`

**In Progress:**
- 🔄 Bash RPG game expansion (60%)
- 🔄 Mirror server setup (50%)
- 🔄 HTTPS/OpenSSL integration (pending)
- 🔄 Chaos Engineer bash scripts for vmchaos09 (pending)
- 🔄 Octopus (free) for CD deployment (pending)

**SNMP with Zabbix:** [Zabbix Monitoring VMs](https://github.com/spawnmarvel/linux-and-azure/tree/main/azure-extra-linux-vm/zabbix_monitoring_vms)

---

### 2. MySQL Continous

**Completed:**
- ✅ Azure Database for MySQL upgrade 8.0 → 8.4 (100%) - Zabbix 6.0.43
- ✅ Local MySQL installation (100%)

**In Progress:**
- W3S MySQL CLI tutorial
- Quick guide: CRUD/DML/DCL with commands
- Performance tuning
- MySQL replication (local → Azure Flexible Server)

**Resources:** [MySQL & Zabbix Guide](https://github.com/spawnmarvel/linux-and-azure/blob/main/azure-extra-linux-vm/zabbix_monitoring_vms)

---

### 3. AZ-802: Windows Server Hybrid Administrator Continous

**Completed:**
- ✅ AD DS installed (100%)
- ✅ Cloud-Only Hybrid Lab completed (100%)

**Study Plan:**
- 📚 MS Learn Active Directory Domain Services
- 📚 MS Learn Azure Arc
- 📚 MS Learn Azure File Sync
- 🎯 Jump to AZ-802 Study Guide when ready

**Info:** [Azure AD Infrastructure](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/tree/main/az-ad-ds-windows-server-hybrid-core-infrastructure)

---

### 4. Octopus Deploy Continous

**Completed:**
- ✅ Windows first deployment (100%)
- ✅ Linux first deployment (100%)
- ✅ Runbook basics (100%)
- ✅ Linux diagnostics (100%)

**In Progress:**
- Upload packages and variables
- Install software (MySQL, etc.)
- Day 2 operations automation

**Runbook Guide:** [Linux Tips & Operations](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/README_octo_linux_runbook_operations.md)

---

### 5. AZ-104: Azure Administrator Continous

**Completed:**
- ✅ VM updates automation runbook (PS1) (100%)
- ✅ Patching automation with tags (100%) - `Patching: Weekly, Mondays 09:00`
- ✅ MySQL Flexible Server autoshutdown (100%) - Sundays 23:00
- ✅ Azure Automation alerts (100%)
- ✅ Runbook Keyvault (not needed for managed identity) (100%)

**In Progress:**
- Runbook storage account file upload
- VM tutorial series
- Azure automation cost management
- Start/stop vmhybrid01 (DC must always be running for internet)

**Resources:** [Azure Automation Runbooks](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/tree/main/az-automation-runbook-and-choices)

---

---

## Parked Projects or Completed Projects

<details>
<summary>Show / hide</summary>

### 1. Docker & Azure

**Python as Container in Docker:**
- Getting started tutorial
- Containerize Python application (30%)
- Implement containerized solutions (pending)

📖 [Containerize Python Application](https://github.com/spawnmarvel/learning-docker/blob/main/1.3-containerize-python-application-2/README.md)

**Then:**
- Azure Container Instance tutorial
- RabbitMQ
- Python application deployment

📖 [Azure Container Instance](https://github.com/spawnmarvel/learning-docker/blob/main/1.4-azure-container-instance-2/README.md)

---

### 2. Docker Stack

**Completed:**
- ✅ Portainer (100%)
- ✅ Zabbix (100%) - [Docker Zabbix](https://github.com/spawnmarvel/learning-docker/tree/main/prod-ish-2/zabbix)

**In Progress:**
- Grafana and MySQL with HTTP/HTTPS
- Grafana and MySQL with HTTPS, Loki, and Alloy on remote servers
- RabbitMQ setup
- RabbitMQ Shovel HTTP/HTTPS

📖 [Learning Docker](https://github.com/spawnmarvel/learning-docker)

---

### 3. Python Maintenance (Parked)

- 🔄 Code a few lines regularly
- 📦 py-central-monitor: Fix database logic, send always, store in file
- 🚫 Build & push to Docker Hub (parked :anchor:)
- 🚫 Container with continuous run (parked :anchor:)

---

### 4. Azure SQL Database (For Fun)

📖 [Azure SQL Database](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-sql/README.md)

</details>

---

## Learning Resources and References

<details>
<summary>Show / hide</summary>


### 1. AZ-104: Certified Professional Must Know

Fill the gaps in networking, monitoring, web apps:
- **Azure VM Tutorials:** [AZ-104 VM](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/tree/main/az-104-vm)
- **Core Skills:** [AZ-104 Certified Professional](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/tree/main/az-104-administrator-certified-professional)
- **Azure Speed Test:** https://www.azurespeed.com/Azure/Latency
- **Network Advanced Tutorial:** [Network advanced tutorial and checklist](https://github.com/spawnmarvel/todo-and-current/tree/main/sysadmin_and_netsh)

- [Secure Windows Server User Accounts](https://learn.microsoft.com/en-us/training/modules/secure-windows-server-user-accounts/?source=recommendations)
- [Secure Group Managed Service Accounts](https://learn.microsoft.com/en-us/entra/architecture/service-accounts-group-managed?source=recommendations)


---

### 2. Linux Resources

**Topics:** UFW, SSH, PS1, Bash quick ref, file system hierarchy, grep, tail, script, env, cron, Python

📖 [Linux & Azure](https://github.com/spawnmarvel/linux-and-azure)

### 3 Linux Quick Guides (Azure, zabbix troubleshoot, mind maps, mirror server, ubuntu docs)

- **Linux and Azure Reference:** [Linux and Azure](https://github.com/spawnmarvel/linux-and-azure)
- **Zabbix Troubleshoot:** [Linux & Azure Grep It](https://github.com/spawnmarvel/linux-and-azure?tab=readme-ov-file#grep-it)
- **Mind Maps:** [Linux Mind Maps](https://github.com/spawnmarvel/linux-and-azure/tree/main/z-mind-maps)
- **Mirror Server:** [Ubuntu Mirror Server](https://github.com/spawnmarvel/linux-and-azure/tree/main/azure-extra-linux-vm-mirror)
- **Ubuntu Documentation:** https://documentation.ubuntu.com/server/

---

### 4. Zabbix Stack :traffic_light:

#### 4.1 Resources
- **Academy:** https://academy.zabbix.com/courses
- **Blog:** https://blog.zabbix.com/
- **Docs:** https://www.zabbix.com/documentation/7.0/en/manual/config/items/itemtypes/browser

#### 4.2 Setup & Configuration
- **Stack Setup:** [Zabbix Stack](https://github.com/spawnmarvel/linux-and-azure/blob/main/azure-extra-linux-vm/zabbix_monitoring_vms/README_stack.md)
- **Performance Tuning:** [Zabbix Tuning](https://github.com/spawnmarvel/linux-and-azure/blob/main/azure-extra-linux-vm/zabbix_monitoring_vms/README_tuning.md)
- **Templates (Active/Passive):** [Zabbix Templates](https://github.com/spawnmarvel/linux-and-azure/blob/main/azure-extra-linux-vm/zabbix_monitoring_vms/templates/README_templates.md)
- **User Parameter Advanced:** [User Parameters](https://github.com/spawnmarvel/linux-and-azure/blob/main/azure-extra-linux-vm/zabbix_monitoring_vms/README_stack.md#user-parameter-advanced)

#### 4.3 Upgrades
- **Minor Upgrade:** [Zabbix Minor Upgrade](https://github.com/spawnmarvel/linux-and-azure/blob/main/azure-extra-linux-vm/zabbix_monitoring_vms/README_upgrade_zabbix_host_one.md)
- **Major Upgrade:** [Zabbix Major Upgrade](https://github.com/spawnmarvel/linux-and-azure/blob/main/azure-extra-linux-vm/zabbix_monitoring_vms/README_upgrade_zabbix_major.md)
- **SSL/HTTPS:** [Zabbix HTTPS](https://github.com/spawnmarvel/linux-and-azure/blob/main/azure-extra-linux-vm/zabbix_monitoring_vms/README_https_zabbix.md)

#### 4.4 APT Sources
```
Ubuntu, MySQL, PHP:
- archive.ubuntu.com (80, 443)
- security.ubuntu.com (80, 443)

Zabbix:
- repo.zabbix.com → whitelist domain (port 443)
```

---

### 5. Apache Tomcat & Solr (Windows) - Archived
- Install Java, Apache Tomcat, Solr
- Fix log levels and sizes
- Upgrade Apache Tomcat

📖 [Apache Tomcat & Solr](https://github.com/spawnmarvel/quickguides/tree/main/apache_tomcat_and_solr)

### Archived Stacks

### 1.  Elastic Stack (Ubuntu) - Archived
📖 [Kibana, Elasticsearch, Filebeat](https://github.com/spawnmarvel/linux-and-azure/blob/main/azure-extra-linux-vm/kibana-elasticsearch-file-beat/README.md)

### 2. Grafana & Zabbix (Ubuntu) - Archived
- Deploy dashboards and integrations
- Grafana Agent (OpenTelemetry Collector)

📖 [Grafana Zabbix](https://github.com/spawnmarvel/linux-and-azure/tree/main/azure-extra-linux-vm/grafana-zabbix)
📖 [Grafana Agent Docs](https://grafana.com/docs/agent/latest/)

### 3. RabbitMQ (Ubuntu) - Archived
- X.509 Shovel with TLS
- amqp_client alternatives
- Certificate requests and renewal

📖 [RabbitMQ](https://github.com/spawnmarvel/linux-and-azure/tree/main/azure-extra-linux-vm/rabbitmq-server)
📖 [X.509 Shovel Config](https://github.com/spawnmarvel/quickguides/blob/main/amqp/x509/vm1_advanced_11.config)
📖 [Certificate Requests](https://github.com/spawnmarvel/quickguides/blob/main/amqp/RequestRenewExample/README.md)

### 4. Telegraf
Input: file, AMQP, disk, CPU
Output: file, AMQP, Zabbix

📖 [Telegraf Setup](https://github.com/spawnmarvel/linux-and-azure/tree/main/azure-extra-linux-vm/telegraf)
📖 [Telegraf Docs](https://docs.influxdata.com/telegraf/v1/)

### 5. Docker RabbitMQ
📖 [RabbitMQ SSL](https://github.com/spawnmarvel/learning-docker/blob/main/prod-ish/rmq/rmq-ssl/README.md)

</details>

---

### Main Project Repositories

<details>
<summary>Show / hide</summary>

#### 1 azure-automation-bicep-and-labs :muscle:
📖 [Repository](https://github.com/spawnmarvel/azure-automation-bicep-and-labs)

#### 2 AZ-104 Certified Professional Must Know :sunglasses:
📖 [AZ-104 Repository](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/tree/main/az-104-certified-professional)

#### 3 Quickguides :fire_engine:
- Apache Tomcat & Solr
- AMQP (Requests, Certificate Decoder, Erlang 26)
- Azure Administrator AZ-104
- Bash, Cogent, Event Hub, etc.

📖 [Quickguides Repository](https://github.com/spawnmarvel/quickguides)

**Notable:**
- [Prosys OPC UA Sim + Cogent Client + InfluxDB](https://github.com/spawnmarvel/quickguides/blob/main/cogent-opcua-influxdb/README.md)
- [Computer Science](https://github.com/spawnmarvel/quickguides/blob/main/computer-science/README.md)

</details>

---

### Release Notes & Updates

Keep up with the latest updates:

- **AZ-104:** https://learn.microsoft.com/en-us/training/browse/?terms=az-104&source=learn&roles=administrator&products=azure&resource_type=learning%20path
- **Zabbix:** https://www.zabbix.com/release_notes
- **Grafana:** https://grafana.com/docs/grafana/latest/whatsnew/
- **Grafana Alloy:** https://grafana.com/docs/alloy/latest/
- **Grafana Loki:** https://grafana.com/docs/loki/latest/release-notes/
- **MySQL:** https://dev.mysql.com/doc/relnotes/mysql/8.0/en/
- **MySQL APT:** https://dev.mysql.com/downloads/
- **MySQL on Linux Using the MySQL APT Repository** https://dev.mysql.com/doc/refman/8.4/en/linux-installation-apt-repo.html
- **Octopus Deploy:** https://octopus.com/whatsnew
- **Gemini:** https://gemini.google/release-notes/
- **RabbitMQ:** https://www.rabbitmq.com/release-information
- **Telegraf:** https://docs.influxdata.com/telegraf/v1/release-notes/
- **Docker:** https://docs.docker.com/tags/release-notes/
- **AspenTech:** https://esupport.aspentech.com/apex/S_Homepage
- **SQLite:** https://sqlite.org/index.html

---

## Additional Resources

- **Certificate Decoder:** https://certlogik.com/decoder
- **Erlang 26 Guide:** [Erlang 26](https://github.com/spawnmarvel/quickguides/blob/main/amqp/Readme.md#erlang-26)
- **Azure Speed Test:** https://www.azurespeed.com/Azure/Latency

---

*Last updated: April 17, 2026*
*Philosophy: Manage workflow with good music, optimize your environment, adjust your mindset and habits.*
