# Raspberry Pi IoT Chilli Monitoring


The goal of this setup is to build a local, reliable monitoring pipeline for indoor plant environments. 

Capsicum (chili and paprika) plants require strict climate control—specifically target humidity levels ($45\% - 65\%$) and ambient temperatures ($21C - 28C)—to ensure healthy transpiration, avoid fungal growth, and optimize flower pollination. 

Manual checks or basic standalone sensor displays lack historical tracking, visual thresholds, and alert capabilities, making an automated end-to-end monitoring solution necessary

## Table of Contents

- [Operating System & Core Runtimes](#operating-system--core-runtimes)
- [MQTT Broker & Gateway](#mqtt-broker--gateway)
- [Monitoring, Metrics & Visualization](#monitoring-metrics--visualization)
- [Client & Desktop Tools](#client--desktop-tools)
- [Hardware](#hardware)
- [Raspberry Pi 4 Network Specifications](#raspberry-pi-4-network-specifications)
- [IoT](#iot)
- [Documentation](#documentation)
- [How to Install Raspberry Pi OS Step by Step](#how-to-install-raspberry-pi-os-step-by-step)
- [Connect](#connect)
- [Grafana](#grafana)
- [Grafana SSL (HTTPS)](#grafana-ssl-https)
- [Monitor localhost with Prometheus Node Exporter](#monitor-localhost-with-prometheus-node-exporter)
- [Shut Down Raspberry Pi](#shut-down-raspberry-pi)
- [Zigbee Sensors and MQTT](#zigbee-sensors-and-mqtt)
- [Preparing mira1 for Zigbee2MQTT](#preparing-mira1-for-zigbee2mqtt)
- [Verify Incoming Temperature Data](#verify-incoming-temperature-data)
- [Assign a Friendly Name in Zigbee2MQTT](#assign-a-friendly-name-in-zigbee2mqtt)
- [Get and View Data](#get-and-view-data)
- [Force Telemetry Request via MQTT from Sonoff SNZB-02P](#force-telemetry-request-via-mqtt-from-sonoff-snzb-02p)
- [Sensor Data to Grafana](#sensor-data-to-grafana)
- [Extended with Python and MQTT](#extended-with-python-and-mqtt)



![chilli](https://github.com/spawnmarvel/todo-and-current/blob/main/raspberrypi/images/chilli.png)

# Raspberry Pi IoT

## Operating System & Core Runtimes

* Raspberry Pi OS (64-bit) – Base Linux operating system (Debian-based kernel 6.18.34+rpt-rpi-v8).

* Raspberry Pi Imager – Flashing utility used on Windows to image the microSD card and pre-configure SSH/Wi-Fi settings.

* Node.js (v22.23.2 LTS) – JavaScript runtime environment required to build and execute Zigbee2MQTT.

* npm (v10.8.2) – Node Package Manager used for installing Node dependencies and managing the Zigbee2MQTT service.

* Git, Make, GCC, G++ – Linux development and compilation build tools (build-essential).

## MQTT Broker & Gateway

* Zigbee2MQTT (v2.13.0+) – Bridges Zigbee communication from the Sonoff Dongle Plus MG24 into structured MQTT payloads.

* Mosquitto (mosquitto & mosquitto-clients) – Open-source MQTT broker running on port 1883 with local CLI publishing/subscribing utilities (mosquitto_sub, mosquitto_pub).

## Monitoring, Metrics & Visualization

* Grafana (Open Source Edition) – Dashboard visualization interface running on port 3000 (configured with custom self-signed SSL certificates over HTTPS).

* Prometheus Server – Time-series database running on port 9090 to scrape and store system and sensor telemetry.

* Prometheus Node Exporter (prometheus-node-exporter) – System metrics collector running on port 9100 exposing host health (CPU, RAM, temp, disk usage).

* mqtt2prometheus (v0.1.7) – Exporter service running on port 9641 that parses MQTT payloads from zigbee2mqtt/+ into Prometheus metrics (temperature, humidity, battery, linkquality).

* OpenSSL – Used to generate self-signed X.509 SSL certificates (grafana.crt, grafana.key) for securing Grafana web traffic.

## Client & Desktop Tools

PowerShell 7 / Windows Terminal – Used on PC for network discovery (Get-NetNeighbor) and SSH connection management.

MQTT Explorer – Cross-platform desktop MQTT client used to visualize the topic tree and inspect raw JSON payloads.

Bitwarden – Credential manager used for storing service passwords.

## Hardware

* Raspberry Pi 4 Model B (4GB): A solid choice.
* Kingston Canvas Select Plus 64GB: An excellent choice for this use case—reliable enough to run the operating system and handle continuous log writing without being expensive.
* Raspberry Pi 27W USB-C Power Supply: Designed for the Pi 5, but works perfectly with the Pi 4. If the official 15W USB-C power supply is available, you can save a little money, but the 27W version is completely safe to use.

## Raspberry Pi 4 Network Specifications

* Wi-Fi: Built-in dual-band wireless networking (2.4 GHz and 5.0 GHz IEEE 802.11ac).

* Ethernet: True Gigabit Ethernet port (10/100/1000 Mbit/s) for maximum stability if you have access to a network cable.

* Bluetooth: Built-in Bluetooth 5.0 (BLE), which also allows you to collect data from wireless Bluetooth temperature sensors.

* Micro-HDMI ports

* * You will need either a Micro-HDMI to HDMI cable or a Micro-HDMI to HDMI adapter to connect it to a regular TV or computer monitor.

* You can run a web server (such as Nginx, Apache, or directly through Grafana/Home Assistant) and access it on your local network or over the internet via port 80 (HTTP) or 443 (HTTPS).


![PI](https://github.com/spawnmarvel/todo-and-current/blob/main/raspberrypi/images/pi.png)

## IoT

* Python: Runs out of the box on Raspberry Pi OS. You can immediately start writing scripts to read temperature and humidity sensors without installing any additional environment.

With 4 GB RAM and 64 GB storage, you have plenty of resources available. You can run the following directly on the device:

* Grafana: Create dashboards and visualize temperature trends over time.

* Time-series database (InfluxDB / Prometheus): Efficient storage for all your temperature measurements.

* Home Assistant: Automate irrigation, grow lights, or heating based on sensor readings.

* MQTT broker (Mosquitto): Connect additional wireless sensors as your system grows.


No, Zigbee is not a proprietary protocol.

It is an open global standard managed by the Connectivity Standards Alliance (CSA, formerly the Zigbee Alliance). Because it is built on the open IEEE 802.15.4 physical layer, any hardware manufacturer can build Zigbee-compatible devices without paying licensing fees to a single private owner.

Key Characteristics of Zigbee

● Open Specifications: The core networking and messaging standards are public and maintained by hundreds of member companies within the CSA.

● Cross-Vendor Interoperability: Devices from different manufacturers (e.g., Sonoff, Aqara, Philips Hue, IKEA) can communicate on the same mesh network.

● Community-Driven Extensions: Tools like Zigbee2MQTT can decode payloads from nearly any manufacturer because the standard profile clusters (like Zigbee Home Automation and Zigbee 3.0) follow predictable open specifications.

OPC UA / DA to MQTT Bridge (Unified Pipeline)

To keep your current setup (Mosquitto -> mqtt2prometheus -> Prometheus), you can bridge OPC UA or OPC DA tags to MQTT topics (such as industrial/opc/temperature):

● For OPC UA: Use an edge broker gateway (such as Telegraf, Node-RED, or HiveMQ Edge) running directly on Linux to connect to the OPC UA server and publish payloads to Mosquitto.

● For OPC DA (Legacy): Because OPC DA requires Windows DCOM, run a gateway tool (like OpenOPC, Cogent DataHub, or Node-RED on a Windows machine) to read DCOM tags and publish them over network MQTT to Mosquitto on the Raspberry Pi.

This is what we will build today:

![toplogy](https://github.com/spawnmarvel/todo-and-current/blob/main/raspberrypi/images/toplogy.jpg)

## Documentation

https://www.raspberrypi.com/documentation/computers/getting-started.html

## How to Install Raspberry Pi OS Step by Step

1. Download the tool: Go to raspberrypi.com/software and download and install Raspberry Pi Imager on your PC. Download the Windows version. Install it and run it as Administrator.

2. Insert the memory card: Insert the Kingston 64GB microSD card into the SD card adapter and connect it to your PC.

Select the device and operating system in Imager:

1. Choose Device: Select Raspberry Pi 4.

2. Choose OS: Select Raspberry Pi OS (64-bit).

3. Choose Storage: Select your memory card.

Customize the settings (important for headless startup). When asked if you want to use OS Customisation, choose Edit Settings:

1. Set a username and password of your choice. (See Bitwarden.)

2. Enable wireless networking and enter your Wi-Fi name (SSID), password, and country code (NO).

3. Go to the Services tab and enable SSH (with password authentication).

Write the image to the card: Click Save and then Yes to begin formatting and writing.

When the process finishes, remove the card, insert it into the Raspberry Pi 4, and connect the power. Give it a couple of minutes to connect to Wi-Fi, then you're ready to connect via SSH!

![Install os](https://github.com/spawnmarvel/todo-and-current/blob/main/raspberrypi/images/os.png)

## Connect

We run a simple PowerShell script that scans the subnet and lists all active IP addresses on your network.


```ps1
Get-NetNeighbor -AddressFamily IPv4 | Where-Object { $_.State -ne "Unreachable" -and $_.IPAddress -like "192.168.10.*" } | Select-Object IPAddress, LinkLayerAddress

# You should find a new IP address.
# If not, disconnect the Raspberry Pi power and reconnect it.

ping mira1.local
```

Connect:


```bash
ssh chilliman@mira1.local

uname -a
Linux mira1 6.18.34+rpt-rpi-v8 #1 SMP PREEMPT Debian 1:6.18.34-1+rpt1 (2026-06-09) aarch64 GNU/Linux

cat /proc/device-tree/model; echo
Raspberry Pi 4 Model B Rev 1.5

free -h
top -d 5

df -h
Filesystem      Size  Used Avail Use% Mounted on
udev            1.6G     0  1.6G   0% /dev
tmpfs           760M  9.1M  751M   2% /run
/dev/mmcblk0p2   57G  6.6G   48G  13% /
tmpfs           1.9G  224K  1.9G   1% /dev/shm
tmpfs           5.0M   16K  5.0M   1% /run/lock
tmpfs           1.0M     0  1.0M   0% /run/credentials/systemd-journald.service
tmpfs           1.9G  4.0K  1.9G   1% /tmp
/dev/mmcblk0p1  505M   87M  418M  18% /boot/firmware
tmpfs           380M   64K  380M   1% /run/user/1000
tmpfs           1.0M     0  1.0M   0% /run/credentials/getty@tty1.service

ip address show
# 192.168.10.212

exit

ssh chilliman@192.168.10.212

# Update package lists
sudo apt update

# Upgrade packages (this will take a while)
sudo apt upgrade

df -h
Filesystem      Size  Used Avail Use% Mounted on
udev            1.6G     0  1.6G   0% /dev
tmpfs           760M  9.1M  751M   2% /run
/dev/mmcblk0p2   57G  7.2G   48G  14% /
tmpfs           1.9G  224K  1.9G   1% /dev/shm
tmpfs           5.0M   16K  5.0M   1% /run/lock
tmpfs           1.0M     0  1.0M   0% /run/credentials/systemd-journald.service
tmpfs           1.9G  4.0K  1.9G   1% /tmp
/dev/mmcblk0p1  505M   79M  426M  16% /boot/firmware
tmpfs           380M   64K  380M   1% /run/user/1000
tmpfs           1.0M     0  1.0M   0% /run/credentials/getty@tty1.service
```

## Grafana

```bash
# 1. Install required tools
sudo apt install -y apt-transport-https wget gpg

# 2. Create the key directory and download Grafana's GPG key
sudo mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null

# 3. Add the Grafana repository
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list

# Update
sudo apt update

# Install Grafana Open Source Edition (OSS)
sudo apt install grafana

# Enable and start Grafana
sudo systemctl daemon-reload
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

# Check status
sudo systemctl status grafana-server

grafana-server.service - Grafana instance
     Loaded: loaded (/usr/lib/systemd/system/grafana-server.service; enabled; preset: enabled)
     Active: active (running) since Tue 2026-08-25 18:32:12 CEST; 5s ago
```

Visit Grafana

* http://192.168.10.212:3000
* http://mira1.local:3000/login

admin (see Bitwarden)

## Grafana SSL (HTTPS)

https://mira1.local:3000/


```bash
sudo mkdir -p /etc/grafana/certs

cd /etc/grafana/certs

sudo openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
  -keyout grafana.key \
  -out grafana.crt \
  -subj "/CN=mira1.local"

sudo chown -R grafana:grafana /etc/grafana/certs
sudo chmod 600 grafana.key
sudo chmod 644 grafana.crt

sudo nano /etc/grafana/grafana.ini

# Remove ; before the parameter
# protocol = https
# Add:
# cert_file = /etc/grafana/certs/grafana.crt
# cert_key = /etc/grafana/certs/grafana.key

sudo systemctl restart grafana-server
sudo systemctl status grafana-server

● grafana-server.service - Grafana instance
     Loaded: loaded (/usr/lib/systemd/system/grafana-server.service; enabled; preset: enabled)
     Active: active (running) since Tue 2026-08-25 21:49:33 CEST; 3s ago
```

## Monitor localhost with Prometheus Node Exporter


prometheus (Prometheus Server): Acts as the time-series database backend on port 9090. It periodically pulls (scrapes) metrics from Node Exporter, stores them in its local time-series database on disk, and serves them to Grafana


prometheus-node-exporter (Node Exporter): Acts as the system metric collector running on port 9100. It exposes raw Linux system metrics (like CPU temperature, memory usage, and uptime) as text endpoints for Prometheus Server to collect.

Your Grafana dashboard connects to Prometheus on port 9090 as its TSDB data source, which in turn queries the data scraped from Node Exporter

```bash
sudo apt update
sudo apt install -y prometheus prometheus-node-exporter

# Enable and start the services
sudo systemctl enable --now prometheus
sudo systemctl enable --now prometheus-node-exporter

# Check status
sudo systemctl status prometheus-node-exporter

prometheus-node-exporter.service - Prometheus exporter for machine metrics
     Loaded: loaded (/usr/lib/systemd/system/prometheus-node-exporter.service; enabled; preset: enabled)
     Active: active (running) since Tue 2026-08-25 18:37:58 CEST; 44s ago
```

Connect it in Grafana:

* Open Grafana in your browser (http://192.168.10.212:3000).
* Go to Connections → Data Sources → Add data source. Select Prometheus.
* In the Prometheus server URL field, enter:

```ps1
http://localhost:9090
```

Scroll to the bottom and click Save & Test. You should see a green confirmation message.

![prom](https://github.com/spawnmarvel/todo-and-current/blob/main/raspberrypi/images/prom.png)

Import a ready-made Raspberry Pi / Node Exporter dashboard.

Instead of building graphs manually, import a dashboard that displays all health metrics:

* In Grafana, click + (Create / Import) and select Import dashboard.

![import](https://github.com/spawnmarvel/todo-and-current/blob/main/raspberrypi/images/import.png)

* In the Import via grafana.com field, enter Dashboard ID: 1860 (Node Exporter Full) and click Load.

![1860](https://github.com/spawnmarvel/todo-and-current/blob/main/raspberrypi/images/1860.png)

* Select Prometheus as the data source.
* Click Import.

You now have a complete health dashboard displaying CPU usage, RAM usage, disks, temperatures, and network traffic directly from localhost.

![dash](https://github.com/spawnmarvel/todo-and-current/blob/main/raspberrypi/images/dash.png)

The dashboard comes with predefined panels.

![dash2](https://github.com/spawnmarvel/todo-and-current/blob/main/raspberrypi/images/dash2.png)

Accsessible also on phone.

![phone](https://github.com/spawnmarvel/todo-and-current/blob/main/raspberrypi/images/phone.png)

We created a grafana alert also (more will come), but we need to check temperature, disk, ram and uptime on the raspberry pi also.

![uptime2](https://github.com/spawnmarvel/todo-and-current/blob/main/raspberrypi/images/uptime2.png)

The alert

![alert](https://github.com/spawnmarvel/todo-and-current/blob/main/raspberrypi/images/alert.png)






## Shut Down Raspberry Pi

```bash
sudo shutdown -h now
```
Wait about 10–15 seconds until the green activity LED stops blinking and only the red power LED remains on (or turns off). You can then safely disconnect the USB-C power cable.

## Zigbee Sensors and MQTT

When the goal is to build a unified ecosystem that grows from a single temperature sensor to humidity, motion, and other sensors over time, the choice is essentially between three main protocols.

Zigbee (Most popular for universal sensor networks):

* Why it's used: The most widely used protocol for wireless battery-powered sensors (Aqara, Sonoff, IKEA Tradfri, Philips Hue).

* Architecture: Forms a mesh network where mains-powered devices (such as smart plugs) act as repeaters.

* Sensor selection: A huge range of affordable temperature, humidity, motion, door/window, and leak sensors.

* Requirements: Requires a USB Zigbee coordinator (for example, Sonoff Zigbee 3.0 USB Dongle Plus) connected to the Raspberry Pi.

Wi-Fi (Simple to start with, but harder to scale long term)

BLE / Bluetooth Low Energy (Cheapest for temperature sensors, limited for motion sensors)

* Why it's used: Extremely inexpensive temperature sensors (for example, Xiaomi Mijia or Govee).

* Limitations: Limited range through walls, no mesh networking, and a much smaller ecosystem than Zigbee.

1. USB Zigbee Coordinator (Coordinator/Dongle)

Function: Connects directly to one of the Raspberry Pi USB ports (mira1). It serves as the radio gateway and antenna for your Zigbee network.

2. Wireless Zigbee Temperature Sensor

After connecting the USB Zigbee dongle, install Zigbee2MQTT on the Raspberry Pi.

We choose Zigbee Sensors.

![sonoff](https://github.com/spawnmarvel/todo-and-current/blob/main/raspberrypi/images/sonoff.png)

## Preparing mira1 for Zigbee2MQTT

Get Node.js, Zigbee2MQTT and MQTT Explorer.


Execute these commands in your SSH terminal on mira1 to add the NodeSource repository and install Node.js 20 LTS along with required compilation tools:

```bash
# Add NodeSource repository and install Node.js 20 LTS + build essentials
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs git make g++ gcc

# Verify Node.js and npm versions
node -v
v20.20.2
npm -v
10.8.2
```

Node.js is an open-source, cross-platform JavaScript runtime environment.

Why it is used: It allows applications to run background processes, handle networking, manage file systems, and execute server-side logic efficiently using minimal CPU and memory resources.

npm stands for Node Package Manager. It is installed automatically alongside Node.js

How it works: It is the default package manager for the Node.js ecosystem, serving as a command-line tool paired with an online registry of shared software libraries (packages).

Create the installation directory, clone the official Zigbee2MQTT repository, and install the node dependencies:

```bash
# Create target directory and set user ownership
sudo mkdir -p /opt/zigbee2mqtt
sudo chown -R $USER:$USER /opt/zigbee2mqtt

# Clone Zigbee2MQTT repository
git clone --depth 1 https://github.com/Koenkk/zigbee2mqtt.git /opt/zigbee2mqtt
cd /opt/zigbee2mqtt

# Install dependencies and build Zigbee2MQTT
npm install

# upgrade node
# Node.js Version Warning: Zigbee2MQTT v2.13.0 requires Node.js ^22.2.0, Node 24, or Node 26. Running Node v20.20.2 caused the engine warnings.

# Add NodeSource repository for Node.js 22.x
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -

sudo apt install -y nodejs
# Verify Node.js version is v22.x
node -v
v22.23.2

d /opt/zigbee2mqtt

# Compile TypeScript files
npm run build

# Verify dist/ folder now exists
ls -la dist/

# Once dist/ is created, proceed with configuring the systemd service file:

sudo nano /etc/systemd/system/zigbee2mqtt.service
```

ini
```ini
[Unit]
Description=zigbee2mqtt
After=network.target mosquitto.service

[Service]
Environment=NODE_ENV=production
Type=simple
User=chilliman
ExecStart=/usr/bin/npm start
WorkingDirectory=/opt/zigbee2mqtt
StandardOutput=inherit
StandardError=inherit
Restart=always
RestartSec=10s

[Install]
WantedBy=multi-user.target
```

Save file and:

```bash
sudo systemctl daemon-reload
sudo systemctl enable zigbee2mqtt.service
Created symlink '/etc/systemd/system/multi-user.target.wants/zigbee2mqtt.service' → '/etc/systemd/system/zigbee2mqtt.service'.
```

***Do not start the service just yet***

Do not start the service just yet. Zigbee2MQTT requires a basic configuration.yaml file to know how to communicate with Mosquitto MQTT; otherwise, it will crash on startup.


* Sonoff Dongle Plus MG24 (Silicon Labs EFR32MG24 chip)

* 1-meter USB extension cable (essential for reducing 2.4GHz USB 3.0 port interference on the Pi 4)

* Sonoff SNZB-02P temperature/humidity sensor

![dongle](https://github.com/spawnmarvel/todo-and-current/blob/main/raspberrypi/images/dongle.png)


Step 1: Connect Hardware

* Plug the USB extension cable into a USB 2.0 port (black port) on mira1.

* Plug the Sonoff Dongle Plus MG24 into the cable.

* Remove the battery insulation tab from the SNZB-02P sensor.

Step 2: Identify Serial Port Path
Run this command in SSH on mira1 to find the exact persistent path of the MG24 dongle:

```bash
ls -la /dev/serial/by-id/
ls -la /dev/serial/by-id/
total 0
drwxr-xr-x 2 root root 60 Aug 28 22:34 .
drwxr-xr-x 4 root root 80 Aug 28 22:34 ..
lrwxrwxrwx 1 root root 13 Aug 28 22:34 usb-SONOFF_SONOFF_Dongle_Plus_MG24_6862721ec2f5ef11a0df99a29ed47d52-if00-port0 -> ../../ttyUSB0
```
Step 3:

* Update configuration.yaml

* Start and Verify Zigbee2MQTT Service

* Pair SNZB-02P Sensor & Verify MQTT

```bash
sudo nano /opt/zigbee2mqtt/data/configuration.yaml
```

Config

```yml
homeassistant: false
permit_join: true
mqtt:
  base_topic: zigbee2mqtt
  server: 'mqtt://localhost:1883'
serial:
  port: /dev/serial/by-id/usb-SONOFF_SONOFF_Dongle_Plus_MG24_6862721ec2f5ef11a0df99a29ed47d52-if00-port0
  adapter: ember
```

Start and verify Zigbee2MQTT service

```bash
# Start service
sudo systemctl start zigbee2mqtt

sudo journalctl -u zigbee2mqtt.service -f --no-pager

#  Error: EACCES: permission denied, open '/opt/zigbee2mqtt/data/configuration.yaml'
# ah we should have run nano with no sudo, fix ut back to owner


sudo chown -R chilliman:chilliman /opt/zigbee2mqtt/
sudo systemctl start zigbee2mqtt

sudo journalctl -u zigbee2mqtt.service -f --no-pager

```

More error:
The Ember adapter initialized successfully and communicated with your Sonoff USB dongle (zh:ember: [STACK STATUS] Network up). However, the service crashed on the MQTT connection step:

error: z2m: MQTT failed to connect, exiting... ()

This indicates Mosquitto is either not running, or its default local listener configuration is rejecting connection attempts on 127.0.0.1:1883

We need mosquitto

```bash

# Update package repositories and install Mosquitto broker + CLI utilities
sudo apt update
sudo apt install -y mosquitto mosquitto-clients

# Create config directory and write local listener settings
sudo mkdir -p /etc/mosquitto/conf.d
sudo bash -c 'cat <<EOF > /etc/mosquitto/conf.d/local.conf
listener 1883 0.0.0.0
allow_anonymous true
EOF'

# Enable and start the Mosquitto service
sudo systemctl enable --now mosquitto

# Verify service is running
sudo systemctl status mosquitto

mosquitto.service - Mosquitto MQTT Broker
     Loaded: loaded (/usr/lib/systemd/system/mosquitto.service; enabled; preset: enabled)
     Active: active (running) since Fri 2026-08-28 22:47:52 CEST; 1min 11s ago

```

Once Mosquitto shows active (running), restart Zigbee2MQTT and tail the live logs:

```bash

# Restart Zigbee2MQTT
sudo systemctl restart zigbee2mqtt

# Tail real-time service logs
sudo journalctl -u zigbee2mqtt -f --no-pager

```

Logs

```log
Aug 28 22:49:42 mira1 npm[8563]: [2026-08-28 22:49:42] info:         zh:ember: [STACK STATUS] Network up.
Aug 28 22:49:42 mira1 npm[8563]: [2026-08-28 22:49:42] info:         zh:ember: [INIT TC] Adapter network matches config.
Aug 28 22:49:42 mira1 npm[8563]: [2026-08-28 22:49:42] info:         zh:ember: [CONCENTRATOR] Started source route discovery. 1248ms until next broadcast.
Aug 28 22:49:42 mira1 npm[8563]: [2026-08-28 22:49:42] info:         z2m: zigbee-herdsman started (resumed)
Aug 28 22:49:42 mira1 npm[8563]: [2026-08-28 22:49:42] info:         z2m: Coordinator firmware version: '{"meta":{"build":0,"ezsp":13,"major":7,"minor":4,"patch":5,"revision":"7.4.5 [GA]","special":0,"type":170},"type":"EmberZNet"}'
Aug 28 22:49:42 mira1 npm[8563]: [2026-08-28 22:49:42] info:         z2m: Currently 0 devices are joined.
Aug 28 22:49:42 mira1 npm[8563]: [2026-08-28 22:49:42] info:         z2m: Connecting to MQTT server at mqtt://localhost:1883
Aug 28 22:49:42 mira1 npm[8563]: [2026-08-28 22:49:42] info:         z2m: Connected to MQTT server
Aug 28 22:49:42 mira1 npm[8563]: [2026-08-28 22:49:42] info:         z2m:mqtt: MQTT publish: topic 'zigbee2mqtt/bridge/state', payload '{"state":"online"}'
Aug 28 22:49:43 mira1 npm[8563]: [2026-08-28 22:49:43] info:         z2m: Zigbee2MQTT started!
```

Everything is up and running.

* Mosquitto MQTT: Listening and accepting connections.

* Zigbee Coordinator: Sonoff MG24 running EmberZNet firmware 7.4.5.

* Zigbee2MQTT: Online and connected to mqtt://localhost:1883.

Next Step: Pair Your Sensor

* Take the Sonoff SNZB-02P sensor.

* Press and hold the reset/pairing button on the side for 5 seconds until the LED indicator begins flashing.

* Keep the sensor close to the Sonoff USB dongle on mira1 for initial pairing.



### Verify Incoming Temperature Data

To observe the incoming telemetry payload, open a second terminal session on mira1 and subscribe to all Zigbee topics:


```bash
mosquitto_sub -h localhost -t "zigbee2mqtt/#" -v

```

```log

zigbee2mqtt/bridge/state {"state":"online"}
zigbee2mqtt/bridge/converters []
zigbee2mqtt/bridge/info {"commit":"fcbb7ff4","config":{"advanced":{"cache_state":true,"cache_state_persistent":true,"cache_state_send_on_startup":true,"channel":11,"elapsed":false,"enable_external_js":true,"ext_pan_id":[221,221,221,221,221,221,221,221],"last_seen":"disable","log_console_json":false,"log_debug_namespace_ignore":"","log_debug_to_mqtt_frontend":false,"log_directories_to_keep":10,"log_directory":"/opt/zigbee2mqtt/data/log/%TIMESTAMP%","log_file":"log.log","log_level":"info","log_namespaced_levels":{},"log_output":["console","file"],"log_rotation":true,"log_symlink_current":false,"log_syslog":{},"output":"json","pan_id":6754,"timestamp_format":"YYYY-MM-DD HH:mm:ss"},"availability":{"active":{"backoff":true,"max_jitter":30000,"pause_on_backoff_gt":0,"timeout":10},"enabled":false,"passive":{"timeout":1500}},"blocklist":[],"device_options":{},"devices":{},"frontend":{"base_url":"/","enabled":false,"package":"zigbee2mqtt-windfront","port":8080},"groups":{},"health":{"interval":10,"reset_on_check":false},"homeassistant":{"discovery_topic":"homeassistant","enabled":false,"experimental_event_entities":false,"legacy_action_sensor":false,"status_topic":"homeassistant/status"},"map_options":{"graphviz":{"colors":{"fill":{"coordinator":"#e04e5d","enddevice":"#fff8ce","router":"#4ea3e0"},"font":{"coordinator":"#ffffff","enddevice":"#000000","router":"#ffffff"},"line":{"active":"#009900","inactive":"#994444"}}}},"mqtt":{"base_topic":"zigbee2mqtt","force_disable_retain":false,"include_device_information":false,"keepalive":60,"maximum_packet_size":1048576,"reject_unauthorized":true,"server":"mqtt://localhost:1883","version":4},"ota":{"default_maximum_data_size":50,"disable_automatic_update_check":false,"image_block_request_timeout":150000,"image_block_response_delay":250,"update_check_interval":1440},"passlist":[],"serial":{"adapter":"ember","disable_led":false,"port":"/dev/serial/by-id/usb-SONOFF_SONOFF_Dongle_Plus_MG24_6862721ec2f5ef11a0df99a29ed47d52-if00-port0"},"version":5},"config_schema":{"definitions":{"device":{"properties":{"debounce":{"description":"Debounces messages of this device","requiresRestart":true,"title":"Debounce","type":"number"},"debounce_ignore":{"description":"Protects unique payload values of specified payload properties from overriding within debounce time","examples":["action"],"items":{"type":"string"},"title":"Ignore debounce","type":"array"},"disable_automatic_update_check":{"default":false,"description":"Zigbee devices may request a firmware update, and do so frequently, causing Zigbee2MQTT to reach out to third party servers. If you disable these device initiated checks, you can still initiate a firmware update check manually.","title":"Disable automatic update check","type":"boolean"},"disabled":{"description":"Disables the device (excludes device from network scans, availability and group state updates)","requiresRestart":true,"title":"Disabled","type":"boolean"},"filtered_attributes":{"description":"Filter attributes with regex from published payload.","examples":["^temperature$","^battery$","^action$"],"items":{"type":"string"},"title":"Filtered publish attributes","type":"array"},"filtered_cache":{"description":"Filter attributes with regex from
```

The payload from Mosquitto confirms that Zigbee2MQTT is fully operational:

* Bridge State: online

* Adapter: ember on /dev/serial/by-id/usb-SONOFF_SONOFF_Dongle_Plus_MG24_...

* MQTT Server: mqtt://localhost:1883

A red light blinking once per second on the Sonoff SNZB-02P means it is actively broadcasting pairing requests, but it is not receiving an acknowledgment back from the Zigbee coordinator to complete the handshake.


Enable Permissive Joining & Reset

Sometimes the coordinator needs an explicit command to open pairing mode. Run these steps on mira1

```bash
# Re-open permit joining on mira1:
mosquitto_pub -h localhost -t "zigbee2mqtt/bridge/request/permit_join" -m '{"value": true, "time": 180}'
```

Reset the sensor into Pairing Mode:

Press and hold the button for full 5–7 seconds until the LED flashes three times (or starts blinking slowly on its own).

Release the button immediately.

Place the sensor right next to the Sonoff MG24 USB antenna and let it sit undisturbed for 10–20 seconds while it completes the 180-second pairing window automatically.

Check your journalctl log stream—you should see Zigbee2MQTT register device_joined followed by interviewing

```bash
sudo journalctl -u zigbee2mqtt -f --no-pager
```

log

```log
Aug 28 23:09:06 mira1 npm[8563]: [2026-08-28 23:09:06] info:         z2m:mqtt: MQTT publish: topic 'zigbee2mqtt/0x70d07efffea42afc', payload '{"battery":100,"humidity":49.7,"humidity_calibration":0,"linkquality":255,"temperature":25.3,"temperature_calibration":0}'
Aug 28 23:09:41 mira1 npm[8563]: [2026-08-28 23:09:41] info:         z2m:mqtt: MQTT publish: topic 'zigbee2mqtt/0x70d07efffea42afc', payload '{"battery":100,"humidity":49.7,"humidity_calibration":0,"linkquality":255,"temperature":25.3,"temperature_calibration":0,"update":{"installed_version":8704,"latest_release_notes":null,"latest_source":"https://raw.githubusercontent.com/Koenkk/zigbee-OTA/master/images/Sonoff/snzb-02p_v2.2.0.ota","latest_version":8704,"state":"idle"}}'
Aug 28 23:09:43 mira1 npm[8563]: [2026-08-28 23:09:43] info:         z2m:mqtt: MQTT publish: topic 'zigbee2mqtt/bridge/health', payload '{"response_time":1787951383058,"os":{"load_average":[0.04,0.01,0.02],"memory_used_mb":789.75,"memory_percent":20.8059},"process":{"uptime_sec":1204,"memory_used_mb":131.27,"memory_percent":3.4584},"mqtt":{"connected":true,"queued":0,"published":178,"received":7},"devices":{"0x70d07efffea42afc":{"messages":101,"messages_per_sec":0.2926,"leave_count":2,"network_address_changes":0}}}'
Aug 28 23:10:17 mira1 npm[8563]: [2026-08-28 23:10:17] info:         zh:ember: [STACK STATUS] Network closed.
```

### Key Telemetry Output

The sensor paired successfully and is actively reporting live data over MQTT:

* IEEE Address: 0x70d07efffea42afc

* Temperature: 25.3 °C

* Humidity: 49.7 %

* Battery: 100%

* Link Quality: 255 (maximum signal strength)


### Assign a Friendly Name in Zigbee2MQTT

To change the default IEEE address topic (zigbee2mqtt/0x70d07efffea42afc) to something descriptive like plant_sensor, publish an MQTT command:

```bash
mosquitto_pub -h localhost -t "zigbee2mqtt/bridge/request/device/rename" -m '{"from": "0x70d07efffea42afc", "to": "plant_sensor1"}'
```

When the sensor reports its next periodic update (or when you trigger a reading by warming it with your hand), you will see the payload published directly to zigbee2mqtt/plant_sensor1

```json
{"battery":100,"humidity":49.7,"humidity_calibration":0,"linkquality":255,"temperature":25.3,"temperature_calibration":0}
```

### Get and view data

```bash
# Listen to all Zigbee2MQTT messages:
mosquitto_sub -h localhost -t "zigbee2mqtt/#" -v

```

```bash
# Listen only to your plant sensor:
mosquitto_sub -h localhost -t "zigbee2mqtt/plant_sensor1" -v
```

MQTT Explorer is a comprehensive MQTT client that provides a structured overview of your MQTT topics and makes working with devices/services on your broker dead-simple.

* https://mqtt-explorer.com/

### Force Telemetry Request via MQTT from Sonoff SNZB-02P

Reporting Frequency Factors

The Sonoff SNZB-02P sends values based on two triggers:

Threshold Triggers (Immediate): The sensor wakes up instantly and sends an MQTT update whenever a noticeable change in temperature or humidity occurs.

Periodic Heartbeat (Time-based): If environment conditions remain completely static, the sensor sends a periodic report to confirm it is online and report battery status (typically every 1 to 4 hours).

You can request Zigbee2MQTT to read the current values over MQTT

```bash
# Request temperature read
# Just move the sensor or blow on it
mosquitto_pub -h localhost -t "zigbee2mqtt/plant_sensor1/get" -m '{"temperature": ""}'

# Request humidity read
# Just move the sensor or blow on it
mosquitto_pub -h localhost -t "zigbee2mqtt/plant_sensor1/get" -m '{"humidity": ""}'
```

![blow](https://github.com/spawnmarvel/todo-and-current/blob/main/raspberrypi/images/blow.png)

***Explanation of MQTT Explorer Output***

Why Values Are Not Updating

The SNZB-02P is currently sleeping to preserve its CR2477 battery. It will not process the /get request sitting in the queue until either

* A reportable environment change occurs (temperature shift > 0.2 C or humidity shift > 1%).

* Its periodic wake-up timer triggers.

* The physical button on the sensor is pressed

I went down and moved it and blew air on it, and then it pushed values.

![mqtt_blow](https://github.com/spawnmarvel/todo-and-current/blob/main/raspberrypi/images/mqtt_blow.png)

### Sensor data to Grafana

```bash
which prometheus
/usr/bin/prometheus

# Check systemd service status
sudo systemctl status prometheus

# Check if port 9090 is listening
curl -s http://localhost:9090/-/healthy
Prometheus Server is Healthy

```

Install Exporter

```bash
# Download version 0.1.7 for Linux ARM64
wget https://github.com/hikhvar/mqtt2prometheus/releases/download/v0.1.7/mqtt2prometheus_0.1.7_linux_arm64.tar.gz

# Extract binary
tar -xvf mqtt2prometheus_0.1.7_linux_arm64.tar.gz

# Move binary to /usr/local/bin
sudo mv mqtt2prometheus /usr/local/bin/
rm mqtt2prometheus_0.1.7_linux_arm64.tar.gz

# Create configuration file
sudo bash -c 'cat <<EOF > /etc/mqtt2prometheus.yaml
mqtt:
  server: tcp://127.0.0.1:1883
  topic_path: "zigbee2mqtt/+"
  device_id_regex: "zigbee2mqtt/(?P<deviceid>[a-zA-Z0-9_]+)"

metrics:
  - prom_name: "temperature"
    mqtt_name: "temperature"
    help: "Plant sensor temperature in Celsius"
    type: "gauge"
  - prom_name: "humidity"
    mqtt_name: "humidity"
    help: "Plant sensor relative humidity percentage"
    type: "gauge"
  - prom_name: "battery"
    mqtt_name: "battery"
    help: "Plant sensor battery level"
    type: "gauge"
  - prom_name: "linkquality"
    mqtt_name: "linkquality"
    help: "Zigbee link quality indicator"
    type: "gauge"
EOF'


# Create and start systemd service
sudo bash -c 'cat <<EOF > /etc/systemd/system/mqtt2prometheus.service
[Unit]
Description=MQTT to Prometheus Exporter
After=network.target mosquitto.service

[Service]
ExecStart=/usr/local/bin/mqtt2prometheus -config /etc/mqtt2prometheus.yaml
Restart=always
User=nobody

[Install]
WantedBy=multi-user.target
EOF'

sudo systemctl daemon-reload
sudo systemctl enable --now mqtt2prometheus

sudo systemctl restart mqtt2prometheus.service

sudo systemctl status mqtt2prometheus.service
mqtt2prometheus.service - MQTT to Prometheus Exporter
     Loaded: loaded (/etc/systemd/system/mqtt2prometheus.service; enabled; preset: enabled)
     Active: active (running) since Fri 2026-08-28 23:56:03 CEST; 4s ago

```
Verify Exporter Output

Once started, confirm that the metrics endpoint is serving data locally:

```bash
# blow or move the sensor

curl -s http://localhost:9641/metrics | grep -E "temperature|humidity"
# HELP humidity Plant sensor relative humidity percentage
# TYPE humidity gauge
humidity{sensor="plant_sensor1",topic="zigbee2mqtt/plant_sensor1"} 83.3 1787954275403
# HELP temperature Plant sensor temperature in Celsius
# TYPE temperature gauge
temperature{sensor="plant_sensor1",topic="zigbee2mqtt/plant_sensor1"} 23.3 1787954275403

```


Step 1: Add Scrape Job to Prometheus Configuration
Open /etc/prometheus/prometheus.yml in your editor:

```bash
sudo nano /etc/prometheus/prometheus.yml
```

Under the scrape_configs: section, append the new exporter job

```yml
- job_name: 'zigbee_sensors'
    static_configs:
      - targets: ['localhost:9641']
```

Step 2: Reload Prometheus
Save the file and reload the Prometheus service configuration:

```bash
sudo systemctl reload prometheus
```

Verify that Prometheus sees the new target as UP by checking http://mira1:9090/targets or running:

```bash
curl -s http://localhost:9090/api/v1/targets | grep zigbee_sensors

```

log

```json
{"status":"success","data":{"activeTargets":[{"discoveredLabels":{"__address__":"localhost:9100","__metrics_path__":"/metrics","__scheme__":"http","__scrape_interval__":"15s","__scrape_timeout__":"10s","job":"node"},"labels":{"instance":"localhost:9100","job":"node"},"scrapePool":"node","scrapeUrl":"http://localhost:9100/metrics","globalUrl":"http://mira1:9100/metrics","lastError":"","lastScrape":"2026-08-29T00:01:19.524908702+02:00","lastScrapeDuration":0.227885045,"health":"up","scrapeInterval":"15s","scrapeTimeout":"10s"},{"discoveredLabels":{"__address__":"localhost:9090","__metrics_path__":"/metrics","__scheme__":"http","__scrape_interval__":"5s","__scrape_timeout__":"5s","job":"prometheus"},"labels":{"instance":"localhost:9090","job":"prometheus"},"scrapePool":"prometheus","scrapeUrl":"http://localhost:9090/metrics","globalUrl":"http://mira1:9090/metrics","lastError":"","lastScrape":"2026-08-29T00:01:16.798531823+02:00","lastScrapeDuration":0.034452304,"health":"up","scrapeInterval":"5s","scrapeTimeout":"5s"},{"discoveredLabels":{"__address__":"localhost:9641","__metrics_path__":"/metrics","__scheme__":"http","__scrape_interval__":"15s","__scrape_timeout__":"10s","job":"zigbee_sensors"},"labels":{"instance":"localhost:9641","job":"zigbee_sensors"},"scrapePool":"zigbee_sensors","scrapeUrl":"http://localhost:9641/metrics","globalUrl":"http://mira1:9641/metrics","lastError":"","lastScrape":"2026-08-29T00:01:19.266747279+02:00","lastScrapeDuration":0.011026352,"health":"up","scrapeInterval":"15s","scrapeTimeout":"10s"}],"droppedTargets":[],"droppedTargetCounts":{"node":0,"prometheus":0,"zigbee_sensors":0}}}
```


Step 3: Create Panels in Grafana

1. Open Grafana in your web browser (http://mira1:3000 or http://<PI_IP>:3000).

2. Navigate to Dashboards > New Dashboard > Add Visualization.

3. Select your Prometheus data source.

4. Configure the following PromQL queries for your panels:

Temperature Panel:

* PromQL Query: temperature{sensor="plant_sensor1"}

* Panel Type: Time Series or Gauge

* Unit: Celsius (°C) (misc > Celsius (°C))

Humidity Panel:

* PromQL Query: humidity{sensor="plant_sensor1"}

* Panel Type: Time Series or Gauge

* Unit: Percent (0-100) (relative > Percent (0-100))

Target Thresholds for Capsicum (Chili & Paprika)

For chili and paprika plants (Capsicum):

* Vegetative & Growth Phase: 55% – 65% RH
* Flowering & Pollination Phase: 45% – 55% RH (High humidity above 65% during flowering causes pollen to clump, reducing fruit set)
* Critical High Threshold: $> 75%$ RH

![grafana_limit](https://github.com/spawnmarvel/todo-and-current/blob/main/raspberrypi/images/grafana_limit.png)




Now the dashboard is ready, go down and move the sensor.

![mqtt_explorer](https://github.com/spawnmarvel/todo-and-current/blob/main/raspberrypi/images/mqtt_explorer.png)

Grafana

![grafana_plant](https://github.com/spawnmarvel/todo-and-current/blob/main/raspberrypi/images/grafana_plant.png)


Now we monitor!

![done](https://github.com/spawnmarvel/todo-and-current/blob/main/raspberrypi/images/done.png)

## Extended with Python and MQTT

1. Get to know Eclipse Mosquitto and Python paho-mqtt

2. MQTT Explorer Setup Connection

3. Python Script (v1.0.0)

4. Verification in MQTT Explorer

### Eclipse Mosquitto

An open source MQTT broker

* https://mosquitto.org/

Let's get to know the broker before we start coding.


### Python

```py
import paho.mqtt.client as mqtt
```

https://pypi.org/project/paho-mqtt/

