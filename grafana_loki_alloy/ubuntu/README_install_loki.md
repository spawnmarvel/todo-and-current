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

## Https://localhost:3100/loki/

```bash

# Create certificates directory inside Loki configuration path
sudo mkdir -p /etc/loki/certs

# Generate a 365-day self-signed certificate and private key
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/loki/certs/loki.key \
  -out /etc/loki/certs/loki.crt \
  -subj "/CN=vmgrafanaloki03"


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

sudo service loki start
sudo server loki status

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


## Install and configure Alloy agent

Since Loki is part of the Grafana ecosystem, it is hosted in the same official Grafana APT repository. You only need to add the repository once to install both grafana and loki.

Grafana Alloy is part of the same official Grafana APT repository.


## Use Logql to query data


