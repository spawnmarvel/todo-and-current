# Install Loki on Ubuntu

Installing Loki on Ubuntu using the .deb package is straightforward, but there are a few "extra" steps needed to make it run properly as a system service.

## Install Loki

🔷 Step get the grafana repos

Since Loki is part of the Grafana ecosystem, it is hosted in the same official Grafana APT repository. You only need to add the repository once to install both grafana and loki.

Grafana Alloy is part of the same official Grafana APT repository

How to Grafana with apt

Grafana OSS	grafana	https://apt.grafana.com stable main

```bash
# 1. Install the prerequisite packages:
sudo apt-get install -y apt-transport-https wget gnupg

# 2 Import the GPG key:
sudo mkdir -p /etc/apt/keyrings
sudo wget -O /etc/apt/keyrings/grafana.asc https://apt.grafana.com/gpg-full.key
sudo chmod 644 /etc/apt/keyrings/grafana.asc

# 3 To add a repository for stable releases, run the following command:
echo "deb [signed-by=/etc/apt/keyrings/grafana.asc] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

# 4 Run the following command to update the list of available packages
# Updates the list of available packages
sudo apt-get update

# 5 To install Grafana OSS, run the following command:
# Installs the latest OSS release, only if you are running Grafana
# sudo apt-get install grafana
```
- https://grafana.com/docs/grafana/latest/setup-grafana/installation/debian/


🔷 Step How to loki with apt 

- https://grafana.com/docs/loki/latest/setup/install/local/

Add the Grafana Advanced Package Tool (APT) or RPM Package Manager (RPM) package repository following the linked instructions.
We already did that in the Grafana apt step 1, 2 and 3

```bash
sudo apt update

sudo apt install loki

```
🔷 Step How to dpkg: Download and Install the .deb

On your Ubuntu VM, download the Loki package. I recommend version 3.0.0 or higher to ensure you have the latest TSDB features you were using on Windows.

```bash
# Download the package
wget https://github.com/grafana/loki/releases/download/v3.0.0/loki_3.0.0_amd64.deb

# Install using apt (this handles dependencies better than dpkg)
sudo apt install ./loki_3.0.0_amd64.deb

# Note: If dpkg reports "missing dependencies," run sudo apt-get install -f immediately after. 
# This tells Ubuntu to go find any small libraries Loki needs to finish the installation.

sudo dpkg -i loki_3.0.0_amd64.deb
```

## Configure Loki


```bash
whereis loki

loki: /usr/bin/loki /etc/lok

cd /etc/loki
ls
config.yml

sudo cp config.yml config.yml_bck

# use the config in the folder
# loki.config.yml

```

Now test loki

```bash

# Generate a nanosecond timestamp for Loki's API requirement
TIMESTAMP=$(date +%s%N)

# Push a test log entry with an escaped exclamation mark
TIMESTAMP=$(date +%s%N)
curl -H "Content-Type: application/json" \
     -XPOST "http://localhost:3100/loki/api/v1/push" \
     -d "{\"streams\": [{\"stream\": {\"job\": \"ubuntu-test\"}, \"values\": [[\"$TIMESTAMP\", \"Loki testing on Ubuntu looks good\"]]}]}"

# You can then verify this stream was created by running:
# Calculate the nanosecond timestamp for 6 hours ago
START_TIME=$(date -d "6 hours ago" +%s%N)

# Query Loki using the absolute timestamp
curl -G -s "http://localhost:3100/loki/api/v1/query_range" \
  --data-urlencode 'query={job="ubuntu-test"}' \
  --data-urlencode "start=$START_TIME"
```

Output

```txt
{"status":"success","data":{"resultType":"streams","result":[{"stream":{"detected_level":"unknown","job":"ubuntu-test","service_name":"ubuntu-test"},"values":[["1781076573586704353","Loki testing on Ubuntu looks good"]]}],"stats":{"summary":{"bytesProcessedPerSecond":2189

[...]
```

## Enable loki and paths



```bash
# Reload systemd to pick up any recent configuration changes
sudo systemctl daemon-reload

# Enable Loki to start at boot and start it right now
sudo systemctl enable loki --now

# Verify it is active and running cleanly
sudo systemctl status loki

● loki.service - Loki service
     Loaded: loaded (/etc/systemd/system/loki.service; enabled; preset: enabled)
     Active: active (running) since Wed 2026-06-10 07:15:45 UTC; 17min ago
```

## https

```bash

# Create certificates directory inside Loki configuration path
sudo mkdir -p /etc/loki/certs

# Generate a 365-day self-signed certificate and private key
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/loki/certs/loki.key \
  -out /etc/loki/certs/loki.crt \
  -subj "/CN=vmgrafanaloki03" \
  -addext "subjectAltName = DNS:vmgrafanaloki03, DNS:localhost, IP:192.168.3.4"


sudo systemctl stop loki

cd /etc/loki
sudo cp config.yml config.yml_bck_no_ssl

# Update the Loki Configuration File
sudo nano /etc/loki/config.yml

# paste the new config with ssl commented out

# Check the User and Group directives inside the Loki service file
systemctl cat loki | grep -E "User=|Group="
User=loki

# Run the following command to create the base storage directory along with all the internal folders defined in your config.yml (chunks, rules, wal, and compactor):
sudo mkdir -p /var/lib/loki/chunks /var/lib/loki/rules /var/lib/loki/wal /var/lib/loki/compactor

# Set proper user and group ownership for the data volume paths
sudo chown -R loki:nogroup /var/lib/loki

# Double-check that your configuration path ownership is also set correctly
sudo chown -R loki:nogroup /etc/loki
sudo chmod 600 /etc/loki/certs/loki.key

# Verify that the owner mappings are correct
ls -la /etc/loki/certs

sudo service loki start
sudo service loki status

```


Test API:

```bash
# 1. Generate a current nanosecond timestamp
TIMESTAMP=$(date +%s%N)

# 2. Push a log line to the HTTPS endpoint on port 3100
curl -k -H "Content-Type: application/json" \
     -XPOST "https://localhost:3100/loki/api/v1/push" \
     -d "{\"streams\": [{\"stream\": {\"job\": \"secure-native-test\"}, \"values\": [[\"$TIMESTAMP\", \"Confirmed: Loki native HTTPS is fully operational\"]]}]}"


# Querying Logs Back Over Native HTTPS
curl -k -G -s "https://localhost:3100/loki/api/v1/query_range" \
  --data-urlencode 'query={job="secure-native-test"}' \
  --data-urlencode 'since=30m'


```

Ok


```txt
{"status":"success","data":{"resultType":"streams","result":[{"stream":{"detected_level":"unknown","job":"secure-native-test","service_name":"secure-native-test"},"values":[["1781078145373911944","Confirmed: Loki native HTTPS is fully operational"]]}],"stats"
```


https://xx.xx.xx.xx:3100/ready

Seeing Ingester not ready: waiting for 15s after being ready on your browser screen means your new Loki server is actually booting up exactly as designed.


![ubuntu success](https://github.com/spawnmarvel/todo-and-current/blob/main/grafana_loki_alloy/ubuntu/images/ubuntu_loki.png)


## Files and dirs


/etc/loki/config.yml

* The main configuration file for Loki (Version 1.0.5

/etc/loki/certs/loki.crt

/etc/loki/certs/loki.key

/var/lib/loki

* These directories andle your 15 GB disk allocation budget. The automated compactor sweeps these folders every 10 minutes to clear data blocks older than 30 days.

/var/lib/loki/chunks/

* Holds your actual compressed log lines


/var/lib/loki/wal/

* Incoming logs are written here instantly before hitting memory caches. If your server loses power abruptly, Loki replays this directory on startup to ensure zero log data loss.

/var/lib/loki/compactor/

* The automated janitor's work yard. The compactor uses this folder as an active sandbox scratchpad to merge index tables, calculate retention deadlines, and delete files that have exceeded your 30-day storage target window.

/var/lib/loki/rules/

* Stores localized alerting and recording rules schemas. If you tell Loki to monitor logs for explicit patterns (like searching for specific error strings) and trigger actions, those processing routines stay indexed here.


## Verify https

Loki does not have a full graphical user interface (GUI) web dashboard of its own—that is what Grafana is for. Instead, Loki will return raw data structured in JSON format.

https://localhost:3100/loki/api/v1/status/buildinfo


Result

```txt
{"version":"3.7.2","revision":"7486c4a7","branch":"release-3.7.x","buildUser":"user@6245646549632","buildDate":"2026-05-13T08:54:45Z","goVersion":""}

```

## Install and configure Alloy agent on windows

Since Loki is part of the Grafana ecosystem, it is hosted in the same official Grafana APT repository. You only need to add the repository once to install both grafana and loki.

Grafana Alloy is part of the same official Grafana APT repository.

https://grafana.com/docs/alloy/latest/set-up/install/


Silent install

* Navigate to the releases page on GitHub.

* Scroll down to the Assets section.

* Download alloy-installer-windows-amd64.zip and unzip it

* CD to where .exe is

```cmd
cd c:\Users\imsdal\Desktop\alloy-installer-windows-amd64.exe>
dir

06/08/2026  01:54 PM       101,898,440 alloy-installer-windows-amd64.exe

alloy-installer-windows-amd64.exe /S /DISABLEREPORTING=yes

sc qc "Alloy"
[SC] QueryServiceConfig SUCCESS

SERVICE_NAME: Alloy
        TYPE               : 10  WIN32_OWN_PROCESS
        START_TYPE         : 2   AUTO_START  (DELAYED)
        ERROR_CONTROL      : 1   NORMAL
        BINARY_PATH_NAME   : "C:\Program Files\GrafanaLabs\Alloy\alloy-service-windows-amd64.exe"
        LOAD_ORDER_GROUP   :
        TAG                : 0
        DISPLAY_NAME       : Alloy
        DEPENDENCIES       :
        SERVICE_START_NAME : LocalSystem


sc config "Alloy" binPath= "\"C:\Program Files\GrafanaLabs\Alloy\alloy-service-windows-amd64.exe\" --disable-reporting"
[SC] ChangeServiceConfig SUCCESS

sc qc "Alloy"
[SC] QueryServiceConfig SUCCESS

SERVICE_NAME: Alloy
        TYPE               : 10  WIN32_OWN_PROCESS
        START_TYPE         : 2   AUTO_START  (DELAYED)
        ERROR_CONTROL      : 1   NORMAL
        BINARY_PATH_NAME   : "C:\Program Files\GrafanaLabs\Alloy\alloy-service-windows-amd64.exe" --disable-reporting
        LOAD_ORDER_GROUP   :
        TAG                : 0
        DISPLAY_NAME       : Alloy
        DEPENDENCIES       :
        SERVICE_START_NAME : LocalSystem



REM not sure if we need this

sc config "Alloy" binPath= "\"C:\Program Files\GrafanaLabs\Alloy\alloy-service-windows-amd64.exe\" --disable-reporting --config=\"C:\Program Files\GrafanaLabs\Alloy\config.alloy\""
```

* C:\Program Files\GrafanaLabs\Alloy cp old config and make a new config.alloy

* Restart service

* If you need to uninstall, it is no longer in control panel, but a uninstall.exe in folder.

![windows install](https://github.com/spawnmarvel/todo-and-current/blob/main/grafana_loki_alloy/ubuntu/images/windows_install.png)

* When done, visit

http://localhost:12345


Seeing your dashboard look exactly like this means your Grafana Alloy configuration is completely valid. If there were any syntax errors, misspelled component targets, or broken blocks, the Alloy daemon would fail to parse the script entirely. Instead of showing this clean flowchart layout, the UI would throw a bright red compilation error block at the top of the page.

The visual chain confirms that Alloy has mapped out your processing pipeline exactly as intended:

![alloy success](https://github.com/spawnmarvel/todo-and-current/blob/main/grafana_loki_alloy/ubuntu/images/windows_alloy.png)

Verifying via LogCLI to Close the Loop


The absolute final check to ensure Alloy is successfully punching through your native HTTPS engine and committing data chunks to your /datadrive storage partition is to look up the data from your Ubuntu command line.




## Use Logql to query data

```bash
# Download the latest LogCLI zip archive (Version 3.0.0 matching your build)
wget https://github.com/grafana/loki/releases/download/v3.0.0/logcli-linux-amd64.zip

# Unzip the archive (install unzip first via 'sudo apt install unzip' if needed)
unzip logcli-linux-amd64.zip

# Move the executable binary to your local bin folder
sudo mv logcli-linux-amd64 /usr/local/bin/logcli

# Verify the installation was successful
logcli --version

sudo nano /etc/hosts
# 192.168.3.4    vmgrafanaloki03

# 1. Copy your certificate asset to the system's anchor directory
sudo cp /etc/loki/certs/loki.crt /usr/local/share/ca-certificates/loki.crt

# 2. Force the operating system to rebuild its trusted certificate registry
sudo update-ca-certificates


# env vars
export LOKI_ADDR="https://vmgrafanaloki03:3100"

# 2. Rerun your Zabbix historical query
logcli query '{job="zabbix", computer="vmap22db"}' --since=1h

logcli query '{job="zabbix", computer="vmap22db"}' --since=1m

```


Result

```log
2026/06/11 13:09:53 https://vmgrafanaloki03:3100/loki/api/v1/query_range?direction=BACKWARD&end=1781183393648662938&limit=30&query=%7Bjob%3D%22zabbix%22%2C+computer%3D%22vmap22db%22%7D&start=1781179793648662938
2026/06/11 13:09:53 Common labels: {computer="vmap22db", detected_level="unknown", filename="C:\\Program Files\\Zabbix Agent 2\\zabbix_agent2.log", job="zabbix", service_name="zabbix"}
2026-06-11T12:52:37Z {} 2026/06/11 12:43:21.006918 [101] active check configuration update from host [vmap22db] started to fail
2026-06-11T12:52:37Z {} 2026/06/11 12:43:15.896963 using plugin 'Uptime' (built-in) providing following interfaces: exporter, maximum capacity: 1000, active checks on start enabled: false
2026-06-11T12:52:37Z {} 2026/06/11 12:43:15.897503 using plugin 'WindowsPerfInstance' (built-in) providing following interfaces: exporter, maximum capacity: 1, active checks on start enabled: false
2026-06-11T12:52:37Z {} 2026/06/11 12:43:24.007195 [101] sending of heartbeat message for [vmap22db] started to fail
2026-06-11T12:52:37Z {} 2026/06/11 12:43:15.896963 using plugin 'VFSDir' (built-in) providing following interfaces: exporter, maximum capacity: 1000, active checks on start enabled: false
2026-06-11T12:52:37Z {} 2026/06/11 12:43:15.896963 using plugin 'VfsFs' (built-in) providing following interfaces: exporter, maximum capacity: 1000, active checks on start enabled: false
2026-06-11T12:52:37Z {} 2026/06/11 12:43:16.188652 Zabbix Agent2 hostname: [vmap22db]
2026-06-11T12:52:37Z {} 2026/06/11 12:43:15.897503 using plugin 'ZabbixAsync' (built-in) providing following interfaces: exporter, maximum capacity: 1000, active checks on start enabled: false
2026-06-11T12:52:37Z {} 2026/06/11 12:43:15.897503 using plugin 'Wmi' (built-in) providing following interfaces: exporter, maximum capacity: 1000, active checks on start enabled: false
2026-06-11T12:52:37Z {} 2026/06/11 12:43:21.006918 [101] cannot connect to [172.16.0.4:10051]: dial tcp :0->172.16.0.4:10051: i/o timeout

```


## Test with log ql


```bash
# since logcli is installed, always run
export LOKI_ADDR="https://vmgrafanaloki03:3100"
```

Standard query

```bash
logcli query '{job="zabbix", computer="vmap22db"}' --since=1h

logcli query '{job="zabbix", computer="vmap22db"}' --since=5m
```


## Check disk usage

```bash
# To see the exact amount of disk space your Loki instance is currently consuming within its /var/lib/loki path-prefix, execute the summary disk usage command:
sudo du -sh /var/lib/loki
216K    /var/lib/loki

# Check the Overall Partition Disk Space
df -h /var/lib/loki
Filesystem      Size  Used Avail Use% Mounted on
/dev/root        29G  2.3G   26G   8% /

```
## Install Grafana and connect


We all ready have a ll pre requistes from loki, they are from the same keyrings

```bash
# Updates the list of available packages
sudo apt-get update

# To install Grafana OSS, run the following command:
sudo apt install grafana

sudo systemctl status grafana-server.service

# We will use the same cert as we have for loki and copy them
# Let's create a dedicated, secure directory path to host these shared monitoring certificates:
sudo mkdir -p /etc/ssl/certs/monitoring

sudo mv /etc/loki/certs/loki.crt /etc/ssl/certs/monitoring/monitoring.crt
sudo mv /etc/loki/certs/loki.key /etc/ssl/certs/monitoring/monitoring.key

# Add new group
sudo groupadd --system monitoring-certs

# Add Grafana system user to the group
sudo usermod -aG monitoring-certs grafana

# Add Loki system user to the group
sudo usermod -aG monitoring-certs loki

# 1. Set user ownership to root and group ownership to our new group
sudo chown -R root:monitoring-certs /etc/ssl/certs/monitoring

# 2. Secure the directory (Read/Execute for the group, hidden from everyone else)
sudo chmod 750 /etc/ssl/certs/monitoring

# 3. Secure the certificate files (Read-only for the group, completely locked down)
sudo chmod 640 /etc/ssl/certs/monitoring/monitoring.crt
sudo chmod 640 /etc/ssl/certs/monitoring/monitoring.key


```

The Custom.ini Verification
Yes, absolutely. By default, Grafana stores its factory settings inside /etc/grafana/grafana.ini. You should never edit that file directly because package updates can overwrite it and wipe out your changes.

Instead of modifying complex systemd service scripts to force Grafana to read a new file, the easiest and most reliable solution on Ubuntu is to put your custom parameters directly into the file it is already reading: /etc/grafana/grafana.ini

```bash
sudo nano /etc/grafana/grafana.ini

```

custom.ini

```ini
#################################### Server ####################################
[server]
# Protocol (http, https, h2, socket)
protocol = https

# The http port to use
http_port = 3000

# listen on all interfaces
http_addr = 0.0.0.0

# https certs & key file paths
cert_file = /etc/ssl/certs/monitoring/monitoring.crt
cert_key = /etc/ssl/certs/monitoring/monitoring.key

```

Enable and restart

```bash

# 1. Reload systemd to recognize configuration changes
sudo systemctl daemon-reload

# 2. Enable the service to boot automatically on restart
sudo systemctl enable grafana-server.service

# 3. Restart the service to apply group updates and SSL
sudo systemctl restart grafana-server.service

# 4. verify
sudo systemctl status grafana-server.service

# 5. Check port in use
ss -tulpn | grep 3000

# If you see 0.0.0.0:3000 in a LISTEN state, your configuration is completely active.


# check error for cert
sudo journalctl -u grafana-server.service --no-pager -n 20

```

Open port 3000 and visit, https://xx.xx.xxx.xx:3000

https://grafana.com/docs/grafana/latest/setup-grafana/installation/debian/

## Add Loki ad datasource


Locate the server or http_tls_config blocks where the certificate paths are defined, and make sure they point exactly to the new moved paths:

```bash

cat /etc/loki/config.yml

```

Path

```yml
server:
  http_listen_port: 3100
  # Ensure these point to the new location:
  http_tls_config:
    cert_file: /etc/ssl/certs/monitoring/monitoring.crt
    key_file: /etc/ssl/certs/monitoring/monitoring.key
```

```bash
sudo systemctl restart loki.service
```

![loki connect](https://github.com/spawnmarvel/todo-and-current/blob/main/grafana_loki_alloy/ubuntu/images/loki_connect.png)

Go to explorer and run query

```logql
{job="zabbix", computer="vmap22db"}
```

![loki explorer](https://github.com/spawnmarvel/todo-and-current/blob/main/grafana_loki_alloy/ubuntu/images/loki_explorer.png)


Go to Drilldown and do the same

![drilldown](https://github.com/spawnmarvel/todo-and-current/blob/main/grafana_loki_alloy/ubuntu/images/drilldown.png)

And give it some time, you will see event logs also

![event_log](https://github.com/spawnmarvel/todo-and-current/blob/main/grafana_loki_alloy/ubuntu/images/event_log.png)


## Grafana fundamentals

https://grafana.com/tutorials/grafana-fundamentals/

## Learn log ql


A Loki log consists of:

* a timestamp
* labels/selectors
* content of the log line.

Loki indexes the timestamp and labels, but not the rest of the log line.

LogQL queries are in the following format:

```bash
# The log stream selector is mandatory while the log pipeline is optional.
{ log stream selector } | log pipeline

# The log stream selector, also called label selector, is a string containing key-value pairs like this:
{job="zabbix", computer="vmap22db"}

``` 

Note!
```txt
service_name is a default label that Loki creates and tries to populate with 
something in the log line that looks like a service name. 

The service name label is used to find and explore logs in Logs Drilldown. 
However, the default can be changed in Loki configuration.

Yes, the updated configuration is significantly better and more robust for 
a production or lab environment. 
By explicitly declaring your labels instead of relying on Loki's default behavior, 
you gain predictable indexing and faster query performance.
```

Why This Configuration is Better

Prevents High Cardinality Issues

* Loki relies on labels to index log streams, 
* Hardcoding it to zabbix-agent or windows-application keeps your index clean.

Consistency Across Platforms

* Windows Event Logs and flat Linux/Zabbix text files format their data completely differently.
* The new config standardizes both streams perfectly.

### Zabbix and Windows event logs

We are curently collecting:

* job="zabbix"
* job="windows-eventlog"

```bash
# since logcli is installed, always run
export LOKI_ADDR="https://vmgrafanaloki03:3100"
```

Standard query

```bash
logcli query '{job="zabbix", computer="vmap22db"}' --since=1h

logcli query '{job="zabbix", computer="vmap22db"}' --since=1m

logcli query '{job="windows-eventlog", computer="vmap22db"}' --since=1h

logcli query '{job="windows-eventlog", computer="vmap22db"}' --since=10m

# By default, the logcli tool appends a hard maximum of --limit=30 entries to queries unless you explicitly override it.

logcli query '{job="zabbix", computer="vmap22db"}' --since=1h --limit=1000

logcli query '{job="windows-eventlog", computer="vmap22db"}' --since=1h --limit=1000
```

Filter logs

Filtering Logs Using LogQL Line Filters

```bash
# LogQL uses pipeline operators (|=) to scan the text inside log lines.
# To catch both [Cpu] and any other instance of cpu or CPU, 
# use the case-insensitive line filter operator |~ combined with a regex modifier (?i)
logcli query '{job="zabbix", computer="vmap22db"} |~ "(?i)cpu"' --since=10m --limit=500

```

Result from the query

```log
026-06-16T18:36:38Z {} 2026/06/16 18:36:38.063335 [Cpu] collected CPU performance data
2026-06-16T18:36:38Z {} 2026/06/16 18:36:38.062772 [Cpu] starting to collect CPU performance data
2026-06-16T18:36:37Z {} 2026/06/16 18:36:37.063402 [Cpu] collected CPU performance data
2026-06-16T18:36:37Z {} 2026/06/16 18:36:37.061061 [Cpu] starting to collect CPU performance data
2026-06-16T18:36:36Z {} 2026/06/16 18:36:36.062479 [Cpu] collected CPU performance data
2026-06-16T18:36:36Z {} 2026/06/16 18:36:36.060894 [Cpu] starting to collect CPU performance data
2026-06-16T18:36:35Z {} 2026/06/16 18:36:35.063380 [Cpu] collected CPU performance data
2026-06-16T18:36:35Z {} 2026/06/16 18:36:35.061615 [Cpu] starting to collect CPU performance data
2026-06-16T18:36:34Z {} 2026/06/16 18:36:34.062345 [Cpu] collected CPU performance data
2026-06-16T18:36:34Z {} 2026/06/16 18:36:34.060691 [Cpu] starting to collect CPU performance data
```

Windows events

```bash
# first run to check what you want to filter on
logcli query '{job="windows-eventlog", computer="vmap22db"}' --since=10h --limit=1000

# then get all error's
logcli query '{job="windows-eventlog", computer="vmap22db"} |~ "(?i)error"' --since=10h --limit=500

# count them
logcli instant-query 'count_over_time({job="windows-eventlog", computer="vmap22db"} |~ "(?i)error" [10h])'

logcli instant-query 'count_over_time({job="windows-eventlog", computer="vmap22db"} |~ "(?i)error" [1h])'

```

Result for count is:


```json
// 10h
[
  {
    "metric": {
      "channel": "Application",
      "computer": "vmap22db",
      "detected_level": "error",
      "job": "windows-eventlog",
      "service_name": "windows-eventlog"
    },
    "value": [
      1781635785.589,
      "45"

// 1h

  {
    "metric": {
      "channel": "Application",
      "computer": "vmap22db",
      "detected_level": "error",
      "job": "windows-eventlog",
      "service_name": "windows-eventlog"
    },
    "value": [
      1781635802.685,
      "33"
    ]
```


Now that you have mastered basic text filtering and metric counting, you can explore more advanced LogQL query patterns. These formulas help you investigate spikes, parse unstructured data, and isolate system issues across Windows and Zabbix logs.


https://grafana.com/docs/loki/latest/query/

### Make Grafana dasboards