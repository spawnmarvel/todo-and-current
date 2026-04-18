# Todo & Current :seedling:

A comprehensive knowledge base combining technical wiki, todo list, and learning progress tracker.

## Philosophy
- Manage workflow (Slipknot/Trance/Music in general is the cure)
- Optimize your environment
- Adjust your mindset and habits

---

## Table of Contents

1. [Setup & Environment](#setup--environment)
2. [Old website parked](#old-website-parked)
3. [Scripting Stack](#scripting-stack)
4. [GitHub Copilot and Development](#github-copilot-and-development)
5. [Infrastructure Essentials](#infrastructure-essentials)
6. [Current Priorities: TOP 3](#current-priorities-top-3)
7. [Knowledge Maintenance Checklist](#knowledge-maintenance-checklist)
8. [Parked Projects or completed projects](#parked-projects-or-completed-projects)
9. [Learning Resources & References](#learning-resources-references)
10. [Release Notes & Updates](#release-notes--updates)

---

## Setup & Environment

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

---

## Old website parked

### E-lo (parked) :anchor:
https://follow-e-lo.com/

---

## Scripting Stack

Use technologies for their strengths:

| Platform | Technologies |
|----------|--------------|
| **Linux** | Bash, cron, Python, Zabbix sender, Telegraf |
| **Windows** | PowerShell, Schedule tasks, Zabbix sender, Telegraf |
| **Complex Logic** | Python |
| **Databases** | MySQL, SQLPlus |
| **ETL** | Telegraf https://github.com/influxdata/telegraf |

**Best Practice:** Turn commands into Bash or PowerShell scripts. Replace hardcoded values with variables:
```bash
# Bad: 
mysql --user=root --password=Password123

# Good: 
mysql --user=#{MySQL.User} --password=#{MySQL.Password}
```

---

## GitHub Copilot and Development

### Using GitHub Copilot Workflow
1. Create an issue with title, description, path, and steps
2. Navigate to your repo with VS Code
3. Press `Ctrl+Alt+I` (Windows/Linux) or `Cmd+Option+I` (macOS)
4. Paste the issue URL to the chat
5. Review live edits, keep or modify as needed
6. Commit and push changes

### Asking for Help
Ask Copilot to review your files: "Could we make this better and more readable?"

### Coding mode

1. Start typing and it will give suggestions
2. To keep it, press Ctrl + Right Arrow key or accept

📖 Learn more: [Copilot README](https://github.com/spawnmarvel/todo-and-current/blob/main/copilot/README.md)

---

### Git Common Tasks

#### Fix "Rejected" Push
When: "Updates were rejected because the tip of your current branch is behind"

This happens when you edited files directly on GitHub or pushed from a different machine.

**Solution (Rebase - Recommended):**
```bash
git pull --rebase origin main
git push origin main
```

---

### VS Code Extensions & Setup

#### Bash IDE Features
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

---

## Infrastructure Essentials

### Azure VM Operations
**Important:** On all Azure VMs, go to Operations > Run command (ps1 / sh)

### AD DS Configuration (vmhybrid01)
vmhybrid01 is the **DC and DNS server** - it must be running for network operations.

**Set Azure Bridge in Portal:**
- Use domain controller VM as DNS server for VNet
- This makes Domain Joining other VMs effortless
- DC becomes responsible for resolving internet traffic

📖 Reference: [Azure AD DS Install Guide](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-ad-ds-windows-server-hybrid-core-infrastructure/README_cloud-only-hybrid-Lab_2_install-ad.md)

### Fast Linux VM Deployment
**GOTO:** `iac_fast_biceps`
- Deploy within 1 min
- Remove within 1 min
- Autoshutdown enabled (safety if forgotten)

---

## Current Priorities: TOP 3

### 1. Octopus Deploy for Linux (CI/CD) ⭐

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

### 2. Windows Server Hybrid Administrator (vmhybrid01) ⭐

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

### 3. Grafana, Loki, and Alloy Agents ⭐

**Goal:** Set up log monitoring stack

**Tasks:**
- Install and configure Grafana
- Configure Loki
- Deploy Alloy agents across infrastructure
- Monitor logs from all services
- Files [Grafana, Loki and Alloy](https://github.com/spawnmarvel/todo-and-current/tree/main/grafana_loki_alloy)

---

## Knowledge Maintenance Checklist

### 1. :bulb: Linux Maintenance

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

### 2. MySQL Maintenance

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

### 3. AZ-802: Windows Server Hybrid Administrator (june 2026)

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

### 4. Octopus Deploy (Free)

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

### 5. AZ-104: Azure Administrator Maintenance

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

## Parked Projects or completed projects

### 1. Docker & Azure :airplane:

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

### 2. Docker Stack :helicopter:

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

---

### 5. AZ-104: Certified Professional Must Know
Fill the gaps in networking, monitoring, and web apps:
- **Azure VM Tutorials:** [AZ-104 VM](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/tree/main/az-104-vm)
- **Core Skills:** [AZ-104 Certified Professional](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/tree/main/az-104-administrator-certified-professional)
- **Azure Speed Test:** https://www.azurespeed.com/Azure/Latency
- **Network Advanced Tutorial:** [Network advanced tutorial and checklist](https://github.com/spawnmarvel/todo-and-current/tree/main/sysadmin_and_netsh)

MS Learn Recommendations

- [Secure Windows Server User Accounts](https://learn.microsoft.com/en-us/training/modules/secure-windows-server-user-accounts/?source=recommendations)
- [Secure Group Managed Service Accounts](https://learn.microsoft.com/en-us/entra/architecture/service-accounts-group-managed?source=recommendations)


---

### 6. Linux Resources :hotel:

**Topics:** UFW, SSH, PS1, Bash quick ref, file system hierarchy, grep, tail, script, env, cron, Python

📖 [Linux & Azure](https://github.com/spawnmarvel/linux-and-azure)

#### 6.1 Linux Quick Guides
- **Linux and Azure Reference:** [Linux and Azure](https://github.com/spawnmarvel/linux-and-azure)
- **Zabbix Troubleshoot:** [Linux & Azure Grep It](https://github.com/spawnmarvel/linux-and-azure?tab=readme-ov-file#grep-it)
- **Mind Maps:** [Linux Mind Maps](https://github.com/spawnmarvel/linux-and-azure/tree/main/z-mind-maps)
- **Mirror Server:** [Ubuntu Mirror Server](https://github.com/spawnmarvel/linux-and-azure/tree/main/azure-extra-linux-vm-mirror)
- **Ubuntu Documentation:** https://documentation.ubuntu.com/server/

---

### 7. Zabbix Stack :traffic_light:

#### 7.1 Resources
- **Academy:** https://academy.zabbix.com/courses
- **Blog:** https://blog.zabbix.com/
- **Docs:** https://www.zabbix.com/documentation/7.0/en/manual/config/items/itemtypes/browser

#### 7.2 Setup & Configuration
- **Stack Setup:** [Zabbix Stack](https://github.com/spawnmarvel/linux-and-azure/blob/main/azure-extra-linux-vm/zabbix_monitoring_vms/README_stack.md)
- **Performance Tuning:** [Zabbix Tuning](https://github.com/spawnmarvel/linux-and-azure/blob/main/azure-extra-linux-vm/zabbix_monitoring_vms/README_tuning.md)
- **Templates (Active/Passive):** [Zabbix Templates](https://github.com/spawnmarvel/linux-and-azure/blob/main/azure-extra-linux-vm/zabbix_monitoring_vms/templates/README_templates.md)
- **User Parameter Advanced:** [User Parameters](https://github.com/spawnmarvel/linux-and-azure/blob/main/azure-extra-linux-vm/zabbix_monitoring_vms/README_stack.md#user-parameter-advanced)

#### 7.3 Upgrades
- **Minor Upgrade:** [Zabbix Minor Upgrade](https://github.com/spawnmarvel/linux-and-azure/blob/main/azure-extra-linux-vm/zabbix_monitoring_vms/README_upgrade_zabbix_host_one.md)
- **Major Upgrade:** [Zabbix Major Upgrade](https://github.com/spawnmarvel/linux-and-azure/blob/main/azure-extra-linux-vm/zabbix_monitoring_vms/README_upgrade_zabbix_major.md)
- **SSL/HTTPS:** [Zabbix HTTPS](https://github.com/spawnmarvel/linux-and-azure/blob/main/azure-extra-linux-vm/zabbix_monitoring_vms/README_https_zabbix.md)

#### 7.4 APT Sources
```
Ubuntu, MySQL, PHP:
- archive.ubuntu.com (80, 443)
- security.ubuntu.com (80, 443)

Zabbix:
- repo.zabbix.com → whitelist domain (port 443)
```

---

### 8. Apache Tomcat & Solr (Windows) - Archived
- Install Java, Apache Tomcat, Solr
- Fix log levels and sizes
- Upgrade Apache Tomcat

📖 [Apache Tomcat & Solr](https://github.com/spawnmarvel/quickguides/tree/main/apache_tomcat_and_solr)

### 9.  Elastic Stack (Ubuntu) - Archived
📖 [Kibana, Elasticsearch, Filebeat](https://github.com/spawnmarvel/linux-and-azure/blob/main/azure-extra-linux-vm/kibana-elasticsearch-file-beat/README.md)

### 10. Grafana & Zabbix (Ubuntu) - Archived
- Deploy dashboards and integrations
- Grafana Agent (OpenTelemetry Collector)

📖 [Grafana Zabbix](https://github.com/spawnmarvel/linux-and-azure/tree/main/azure-extra-linux-vm/grafana-zabbix)
📖 [Grafana Agent Docs](https://grafana.com/docs/agent/latest/)

### 11. RabbitMQ (Ubuntu) - Archived
- X.509 Shovel with TLS
- amqp_client alternatives
- Certificate requests and renewal

📖 [RabbitMQ](https://github.com/spawnmarvel/linux-and-azure/tree/main/azure-extra-linux-vm/rabbitmq-server)
📖 [X.509 Shovel Config](https://github.com/spawnmarvel/quickguides/blob/main/amqp/x509/vm1_advanced_11.config)
📖 [Certificate Requests](https://github.com/spawnmarvel/quickguides/blob/main/amqp/RequestRenewExample/README.md)

### 12. Telegraf
Input: file, AMQP, disk, CPU
Output: file, AMQP, Zabbix

📖 [Telegraf Setup](https://github.com/spawnmarvel/linux-and-azure/tree/main/azure-extra-linux-vm/telegraf)
📖 [Telegraf Docs](https://docs.influxdata.com/telegraf/v1/)

### 13. Docker RabbitMQ
📖 [RabbitMQ SSL](https://github.com/spawnmarvel/learning-docker/blob/main/prod-ish/rmq/rmq-ssl/README.md)

---

### Main Project Repositories

#### azure-automation-bicep-and-labs :muscle:
📖 [Repository](https://github.com/spawnmarvel/azure-automation-bicep-and-labs)

#### AZ-104 Certified Professional Must Know :sunglasses:
📖 [AZ-104 Repository](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/tree/main/az-104-certified-professional)

#### Quickguides :fire_engine:
- Apache Tomcat & Solr
- AMQP (Requests, Certificate Decoder, Erlang 26)
- Azure Administrator AZ-104
- Bash, Cogent, Event Hub, etc.

📖 [Quickguides Repository](https://github.com/spawnmarvel/quickguides)

**Notable:**
- [Prosys OPC UA Sim + Cogent Client + InfluxDB](https://github.com/spawnmarvel/quickguides/blob/main/cogent-opcua-influxdb/README.md)
- [Computer Science](https://github.com/spawnmarvel/quickguides/blob/main/computer-science/README.md)

---

### Release Notes & Updates

Keep up with the latest updates:

- **Gemini:** https://gemini.google/release-notes/
- **AZ-104:** https://learn.microsoft.com/en-us/training/browse/?terms=az-104&source=learn&roles=administrator&products=azure&resource_type=learning%20path
- **Zabbix:** https://www.zabbix.com/release_notes
- **MySQL:** https://dev.mysql.com/doc/relnotes/mysql/8.0/en/
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
