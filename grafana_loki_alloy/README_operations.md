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
// Scans the specific log file for Zabbix Agent 2
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
// This reads the file discovered above and forwards it
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

# Search in logs

Now that we have two logs to listen to

🔷 Windows System and Applications and Zabbix agent, lets start to analyse them.

## Live search in dashboard

Pro-Tip: The "Live" Search
If you are trying to find a specific word in a massive list of logs already on your screen, you can use the standard browser search:

🔷 Press Ctrl + F on your keyboard.

🔷 Type error.

🔷 This will highlight every time that word appears in the log window.

![live search](https://github.com/spawnmarvel/todo-and-current/blob/main/grafana_loki_alloy/images/live_search.png)

## More search 

To search for errors specifically, you have two options: the "Easy Way" using the UI buttons, or the "Pro Way" using the query code.

🔷 The Easy Way (UI Builder)
Since you are currently using the Builder, you can add a filter for the log text:

🔷 In your Query Builder, look for the box labeled Line contains.

🔷 Type the word error (case-insensitive) into that box.

🔷 If you want to find multiple things, click the + below it and add another "Line contains" for fail.

🔷 Click Run query.

🔷 The Pro Way (Query Code)
If you click the Code button next to "Builder," you can write a high-performance search string. Loki uses a language called LogQL.

To find any log line that contains the word "error," your query should look like this:

```code
{channel="Application"} |= "error"
```

Common Search Symbols:

🔷 |= "text" : Line contains this string.

🔷 != "text" : Line does not contain this string.

🔷 |~ "error|fail|critical" : Line contains any of these words (this uses Regex).

🔷 Filtering by "Level"
Because you used the logfmt parser earlier, Windows has already told Loki which logs are "Errors" and which are "Information." You can filter by the specific field:

🔷 Click the + next to your label filters (where channel is).

🔷 Select levelText (or level).

🔷 Select = and then choose Error or 3 (depending on how the log was parsed).

Pro-Tip: If you see a lot of "noise" (logs you don't care about), use the negative filter. For example: {channel="Application"} != "Alloy" will show you everything except the logs generated by the Alloy agent itself.

🔷 How to See "Errors" over time
If you want to see a Graph of how many errors are happening:

🔷 Change your visualization (top right) back to Time Series.

🔷 Switch to Code mode.

🔷 Use this query to count errors per minute:
count_over_time({channel="Application"} |= "error" [1m])