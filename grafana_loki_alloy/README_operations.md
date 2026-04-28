# Continue after install Grafana, Loki and Alloy

# Table of Contents: Grafana, Loki & Alloy Maintenance

- [Continue after install Grafana, Loki and Alloy](#continue-after-install-grafana-loki-and-alloy)
- [Table of Contents: Grafana, Loki \& Alloy Maintenance](#table-of-contents-grafana-loki--alloy-maintenance)
  - [Tips for make it production ready (not done for this lab)](#tips-for-make-it-production-ready-not-done-for-this-lab)
  - [Log from remote server install on linux](#log-from-remote-server-install-on-linux)
  - [Log for multiple applications](#log-for-multiple-applications)
  - [Explore](#explore)
  - [Create a Logs Panel that specifically filters for job="name-agent" so you can monitor the agent's connection health.](#create-a-logs-panel-that-specifically-filters-for-jobname-agent-so-you-can-monitor-the-agents-connection-health)
  - [Search in logs](#search-in-logs)
  - [Lets make grafana avaliable from the outside](#lets-make-grafana-avaliable-from-the-outside)
  - [Live search in dashboard](#live-search-in-dashboard)
  - [Drill down](#drill-down)
  - [Drill down by computer and job name](#drill-down-by-computer-and-job-name)
  - [The Easy Way (UI Builder) or the "Pro Way" using the query code](#the-easy-way-ui-builder-or-the-pro-way-using-the-query-code)
  - [1. Understanding the "Big Three" Panel Types.](#1-understanding-the-big-three-panel-types)
  - [2. Mastering LogQL (The "Query Language")](#2-mastering-logql-the-query-language)
  - [3. Let's Build Your First "Error Counter"](#3-lets-build-your-first-error-counter)
  - [4. The "Log Breakdown" (Pie Chart)](#4-the-log-breakdown-pie-chart)
  

## Tips for make it production ready (not done for this lab)

* Service Recovery (The "Auto-Restart") for Grafana, Loki and Alloy

* Alerting on "Silent Failures"

* * Pro-tip: Create a simple "Heartbeat" alert in Grafana. If the log volume for vmhybrid01 drops to 0 for more than 5 minutes, have Grafana send you an email or Zabbix trigger.

* Backup: Do you have a backup of loki-config.yaml and your .alloy file stored somewhere off this VM?

* Firewall: Double-check that only your trusted devices can hit port 3100

* Option B: Native Loki TLS (The Standalone Way)

Loki does support TLS directly in the server block. This keeps things "standalone" without needing Nginx.

Yes, you can absolutely use the same certificate for Loki as you do for Grafana, provided the DnsName (vmhybrid.lab.local) matches how you access both services.

```yml
server:
  http_listen_port: 3100
  # Add this section for HTTPS
  http_tls_config:
    cert_file: C:/Loki/certs/loki.crt
    key_file: C:/Loki/certs/loki.key

```

* Important: The "Domino Effect"
Once you switch Loki to HTTPS, you have to update every other piece of your stack, or they will stop working:

* Alloy: You must update the url in your .alloy file from http:// to https://. If you are using a self-signed certificate, you will also need to add insecure_skip_verify = true in the Alloy client block so it doesn't reject the connection.

* Grafana: You must update the Loki Datasource URL to https://vmhybrid01.lab.local:3100.

* Firewall: You still use port 3100, but the traffic inside that "pipe" is now encrypted.


## Log from remote server install on linux

* Install and configure alloy on a linux server server
* For this to work, your Loki VM (vmhybrid) must allow incoming traffic on port 3100.`
* Point to Loki VM in config

```hcl
// 2. Tell Alloy where to send them (Your Loki service)
loki.write "local_loki" {
  endpoint {
    url = "http://vmhybrid.lab.local:3100/loki/api/v1/push"
  }
}

```
Internet access

* https://grafana.com/docs/alloy/latest/set-up/install/linux/

No internet access

* Vm ubuntu-24_04-lts

Download to a vm or a storage account

* https://github.com/grafana/alloy/releases
* alloy-1.15.1-1.amd64.deb

No go to the Vm where you want to install it.

```bash

wget -O alloy-1.15.1-1.amd64.deb "https://staccountname01.blob.core.windows.net/fileslinux/alloy-1.15.1-1.amd64.deb?sp=r&st=2026...."


sudo dpkg -i alloy-1.15.1-1.amd64.deb

# Refresh the service list
sudo systemctl daemon-reload

# Enable and start Alloy in one command
sudo systemctl enable --now alloy

# sudo service alloy status
● alloy.service - Vendor-agnostic OpenTelemetry Collector distribution with programmable pipelines
     Loaded: loaded (/usr/lib/systemd/system/alloy.service; enabled; preset: enabled)

# Edit the config file:

sudo nano /etc/alloy/config.alloy

``` 

config.alloy

```hcl
logging {
  level = "info"
}

// 1. Define the Log Source (Ubuntu Syslog)
local.file_match "linux_logs" {
  path_targets = [
    { 
      "job"      = "ubuntu-syslog",
      "computer" = "vm-uks-temp-001.lab.local",
      "__path__" = "/var/log/syslog", 
    },
  ]
}

// 2. The Unified Processor (Adapted for Linux)
loki.process "linux_processor" {
  
  // A. Ensure the computer label matches the new VM name
  stage.static_labels {
    values = {
      computer = "vm-uks-temp-001.lab.local",
    }
  }

  // B. Extract Level and Message from Syslog
  // Typical syslog: Apr 28 15:00:00 hostname service[pid]: INFO: message
  stage.regex {
    expression = "^(?P<timestamp>\\S+\\s+\\d+\\s+\\S+)\\s+(?P<host>\\S+)\\s+(?P<service>\\S+):\\s+(?P<lvl>[A-Z]+):\\s+(?P<msg>.*)$"
  }

  // C. Map extracted fields to labels
  stage.labels {
    values = {
      level   = "lvl",
      service = "service",
    }
  }

  // D. THE TRANSLATOR: Normalizes Linux levels to match your Windows Dashboard
  stage.replace {
    source     = "level"
    expression = "(?i)^err$|^error$|^emerg$|^crit$"
    replace    = "error"
  }
  stage.replace {
    source     = "level"
    expression = "(?i)^info$|^notice$"
    replace    = "info"
  }
  stage.replace {
    source     = "level"
    expression = "(?i)^warn$|^warning$"
    replace    = "warning"
  }

  // E. CLEANUP: Keep the dashboard looking clean
  // If the regex above doesn't match a line perfectly, it stays as is.
  stage.output {
    source = "msg"
  }

  forward_to = [loki.write.windows_loki.receiver]
}

// 3. Scrape and Forward
loki.source.file "local_scrape" {
  targets    = local.file_match.linux_logs.targets
  forward_to = [loki.process.linux_processor.receiver]
}

// 4. Remote Push to your main Windows Loki
loki.write "windows_loki" {
  endpoint {
    url = "http://192.168.3.7:3100/loki/api/v1/push"
  }
}
```

Why this is "Equal" to your Main Config:
🟦 Global Searchability: By using the same computer and level labels, this VM will automatically appear in your main dashboard's dropdown menus.

🟦 Normalized Levels: Since I added the stage.replace blocks, your Error Counter on the main dashboard will now count Linux errors and Windows errors together.

🟦 Clean Display: The stage.output ensures that the timestamp and hostname (which are already in the Grafana columns) aren't repeated inside the log message, keeping your table view clean.

By default, the alloy user created by the installer might not have permission to read the system logs on Ubuntu 24.04. Run this to grant access:

```bash
sudo usermod -aG adm alloy
sudo systemctl restart alloy
```

How to View the Logs

On Linux, Grafana Alloy doesn't write to a traditional text file (like alloy.log) by default. Instead, it sends its logs to the Systemd Journal.

```bash
sudo journalctl -u alloy -f

sudo journalctl -u alloy -n 50

sudo journalctl -u alloy --priority=err

```

Step 1: Fix the Windows Firewall
On your Windows VM (192.168.3.7):

Open Windows Defender Firewall with Advanced Security.

Click Inbound Rules -> New Rule.

Choose Port -> TCP.

Specific local ports: 3100.

Allow the connection.

Name it "Loki Inbound" and Finish.

```bash
nc -zv 192.168.3.7 3100
Connection to 192.168.3.7 3100 port [tcp/*] succeeded!

```

Now we have two vms.


![two vms](https://github.com/spawnmarvel/todo-and-current/blob/main/grafana_loki_alloy/images/two_vms.png)


## Explore

Go to Explore to see your lables, jobs and get to know what you have collected.

![explorer](https://github.com/spawnmarvel/todo-and-current/blob/main/grafana_loki_alloy/images/explore.png)



## Log for multiple applications

Sinxe we have zabbix agent running on the windows vm, lets add it to alloy config


* Stop Alloy
* Backup config file

We added this for zabbix, we stil have the system configured in this file.

```hcl
//  Zabbix Agent (File Source)
local.file_match "zabbix_agent" {
  path_targets = [{ 
    "__address__" = "localhost", 
    "__path__"    = "C:/Program Files/Zabbix Agent 2/zabbix_agent2.log", 
    "job"         = "zabbix-agent",
    "computer"    = "vmhybrid01.lab.local",
    "service"     = "zabbix-agent",
  }]
}

loki.source.file "zabbix_scrape" {
  targets    = local.file_match.zabbix_agent.targets
  forward_to = [loki.write.local_loki.receiver]
}

```

* Check it and test new config

```ps1
& "C:\Program Files\GrafanaLabs\Alloy\alloy-windows-amd64.exe" run "C:\Program Files\GrafanaLabs\Alloy\config.alloy"

```

* If it is ok, start service, else fix it.


## Create a Logs Panel that specifically filters for job="name-agent" so you can monitor the agent's connection health.

![logs_zabbix](https://github.com/spawnmarvel/todo-and-current/blob/main/grafana_loki_alloy/images/logs_zabbix.png)


## Search in logs

Now that we have two logs to listen to

* Windows System and Applications and Zabbix agent, lets start to analyse them.

## Lets make grafana avaliable from the outside

* NSG port 3000
* Windows FW port 3000
* https://xxx.xx.xxx.xx:3000/

## Live search in dashboard

Pro-Tip: The "Live" Search
If you are trying to find a specific word in a massive list of logs already on your screen, you can use the standard browser search:

*  Press Ctrl + F on your keyboard.

* Type error.

* This will highlight every time that word appears in the log window.

![live search](https://github.com/spawnmarvel/todo-and-current/blob/main/grafana_loki_alloy/images/live_search.png)

Excellent! Now that the "plumbing" is done and the data is flowing, we move into the most rewarding part: LogQL and Visualization.

## Drill down

Pro-Tip:

Since we added filters, we can now drill down the logs.

![drill down](https://github.com/spawnmarvel/todo-and-current/blob/main/grafana_loki_alloy/images/drill_down.png)

## Drill down by computer and job name

![job name](https://github.com/spawnmarvel/todo-and-current/blob/main/grafana_loki_alloy/images/job_name.png)

## The Easy Way (UI Builder) or the "Pro Way" using the query code

To search for errors specifically, you have two options: the "Easy Way" using the UI buttons, or the "Pro Way" using the query code.

* The Easy Way (UI Builder)
Since you are currently using the Builder, you can add a filter for the log text:

* In your Query Builder, look for the box labeled Line contains.

* Type the word error (case-insensitive) into that box.

* If you want to find multiple things, click the + below it and add another "Line contains" for fail.

* Click Run query.

* The Pro Way (Query Code)
If you click the Code button next to "Builder," you can write a high-performance search string. Loki uses a language called LogQL.

## 1. Understanding the "Big Three" Panel Types.

For a production-ready dashboard, you generally want these three specific views:

* The Status Overview (Stat Panel): A big number showing the count of "Errors" in the last hour. If it's 0, it’s green; if it's > 5, it turns red.

* The Noise Trend (Time Series): A graph showing log volume over time. A sudden "spike" in the graph usually means an app is crashing or a disk is filling up.

* The Deep Dive (Logs Panel): The actual text of the logs, filtered to show only what’s important.


## 2. Mastering LogQL (The "Query Language")

Since you are analyzing Windows and Zabbix logs, you’ll use LogQL. Here are the "Golden Queries" you should learn first:

![logql](https://github.com/spawnmarvel/todo-and-current/blob/main/grafana_loki_alloy/images/logql.png)

But more in this in README_operations_logql.md

## 3. Let's Build Your First "Error Counter"

Let's create a panel that tells you how many Application Errors occurred on your VM today.

* Click Add > Visualization in your dashboard.

* Select Stat from the panel list on the right.

* Use this query:

```logql
sum(count_over_time({job="windows-application", computer="vmhybrid01.lab.local"} | json | levelText="Error" [24h]))

# or

sum(count_over_time({job="windows-application", computer="vmhybrid01.lab.local"} | json | levelText="Error" [1h]))
```

* In the Standard Options, set the unit to Short.

* Set a Threshold: Base is Green, and at 1, it turns Red.

* In the Query A block (the Error query), look for the "Legend" field at the bottom.

* windows-application

* Save it and use it

![error_count](https://github.com/spawnmarvel/todo-and-current/blob/main/grafana_loki_alloy/images/error_count.png)

## 4. The "Log Breakdown" (Pie Chart)

It’s very helpful to see which source is the "noisiest."

* Query: sum by (job) (count_over_time({instance="vmhybrid01"}[1h]))

* Panel: Pie Chart.

* Result: You’ll see if Windows System logs are drowning out your Zabbix logs.
