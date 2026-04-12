# Continue after install Grafana, Loki and Alloy


## Tips for make it production ready (not done for this lab)

🔷 Service Recovery (The "Auto-Restart") for Grafana, Loki and Alloy

🔷 Alerting on "Silent Failures"

🔷 🔷 Pro-tip: Create a simple "Heartbeat" alert in Grafana. If the log volume for vmhybrid01 drops to 0 for more than 5 minutes, have Grafana send you an email or Zabbix trigger.

🔷 Backup: Do you have a backup of loki-config.yaml and your .alloy file stored somewhere off this VM?

🔷 Firewall: Double-check that only your trusted devices can hit port 3100

🔷 Option B: Native Loki TLS (The Standalone Way)

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

🔷 Important: The "Domino Effect"
Once you switch Loki to HTTPS, you have to update every other piece of your stack, or they will stop working:

🔷 Alloy: You must update the url in your .alloy file from http:// to https://. If you are using a self-signed certificate, you will also need to add insecure_skip_verify = true in the Alloy client block so it doesn't reject the connection.

🔷 Grafana: You must update the Loki Datasource URL to https://vmhybrid01.lab.local:3100.

🔷 Firewall: You still use port 3100, but the traffic inside that "pipe" is now encrypted.


## Log from remote server

* Install and configure alloy on server
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

## Log for multiple applications

Sinxe we have zabbix agent running on the windows vm, lets add it to alloy config


* Stop Alloy
* Backup config file

We added this for zabbix, we stil have the system configured in this file.

```hcl
// 🔷 1. Zabbix Agent 2 Log Discovery
local.file_match "zabbix_agent" {
  path_targets = [
    { 
      "__address__" = "localhost", 
      "__path__"    = "C:/Program Files/Zabbix Agent 2/zabbix_agent2.log", 
      "job"         = "zabbix-agent",
      "instance"    = "vmhybrid01",
    },
  ]
}

// 🔷 2. Zabbix Agent 2 File Scraper
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


🔷 Create a Logs Panel that specifically filters for job="zabbix-agent" so you can monitor the agent's connection health.

![logs_zabbix](https://github.com/spawnmarvel/todo-and-current/blob/main/grafana_loki_alloy/images/logs_zabbix.png)


# Search in logs

Now that we have two logs to listen to

🔷 Windows System and Applications and Zabbix agent, lets start to analyse them.

### Lets make grafana avaliable from the outside

* NSG port 3000
* Windows FW port 3000
* https://xxx.xx.xxx.xx:3000/

## Live search in dashboard

Pro-Tip: The "Live" Search
If you are trying to find a specific word in a massive list of logs already on your screen, you can use the standard browser search:

🔷 Press Ctrl + F on your keyboard.

🔷 Type error.

🔷 This will highlight every time that word appears in the log window.

![live search](https://github.com/spawnmarvel/todo-and-current/blob/main/grafana_loki_alloy/images/live_search.png)

Excellent! Now that the "plumbing" is done and the data is flowing, we move into the most rewarding part: LogQL and Visualization.

## Drill down

Pro-Tip:

Since we added filters, we can now drill down the logs.

![drill down](https://github.com/spawnmarvel/todo-and-current/blob/main/grafana_loki_alloy/images/drill_down.png)

## The Easy Way (UI Builder) or the "Pro Way" using the query code

To search for errors specifically, you have two options: the "Easy Way" using the UI buttons, or the "Pro Way" using the query code.

🔷 The Easy Way (UI Builder)
Since you are currently using the Builder, you can add a filter for the log text:

🔷 In your Query Builder, look for the box labeled Line contains.

🔷 Type the word error (case-insensitive) into that box.

🔷 If you want to find multiple things, click the + below it and add another "Line contains" for fail.

🔷 Click Run query.

🔷 The Pro Way (Query Code)
If you click the Code button next to "Builder," you can write a high-performance search string. Loki uses a language called LogQL.

## 🔷 1. Understanding the "Big Three" Panel Types

For a production-ready dashboard, you generally want these three specific views:

🔷 The Status Overview (Stat Panel): A big number showing the count of "Errors" in the last hour. If it's 0, it’s green; if it's > 5, it turns red.

🔷 The Noise Trend (Time Series): A graph showing log volume over time. A sudden "spike" in the graph usually means an app is crashing or a disk is filling up.

🔷 The Deep Dive (Logs Panel): The actual text of the logs, filtered to show only what’s important.


## 🔷 2. Mastering LogQL (The "Query Language")
Since you are analyzing Windows and Zabbix logs, you’ll use LogQL. Here are the "Golden Queries" you should learn first:

![logql](https://github.com/spawnmarvel/todo-and-current/blob/main/grafana_loki_alloy/images/logql.png)

## 🔷 3. Let's Build Your First "Error Counter"

Let's create a panel that tells you how many Application Errors occurred on your VM today.

🔷 Click Add > Visualization in your dashboard.

🔷 Select Stat from the panel list on the right.

🔷 Use this query:
count_over_time({eventlog_name="Application", levelText="Error"}[24h])

🔷 In the Standard Options, set the unit to Short.

🔷 Set a Threshold: Base is Green, and at 1, it turns Red.

## 🔷 4. The "Log Breakdown" (Pie Chart)

It’s very helpful to see which source is the "noisiest."

🔷 Query: sum by (job) (count_over_time({instance="vmhybrid01"}[1h]))

🔷 Panel: Pie Chart.

🔷 Result: You’ll see if Windows System logs are drowning out your Zabbix logs.
