# Raspberry Pi IoT

## Table of Contents

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

# Raspberry Pi IoT

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

We created a grafana alert also (more will come), but we need to check temperature and uptime.

![uptime](https://github.com/spawnmarvel/todo-and-current/blob/main/raspberrypi/images/uptime.png)

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

* Once your Sonoff USB dongle arrives, we will verify its exact USB serial path using

```bash

```

Zigbee2MQTT

* https://www.zigbee2mqtt.io/

SONOFF Dongle-PMG24

* https://www.zigbee2mqtt.io/devices/Dongle-PMG24.html#sonoff-dongle-pmg24

MQTT Explorer is a comprehensive MQTT client that provides a structured overview of your MQTT topics and makes working with devices/services on your broker dead-simple.

* https://mqtt-explorer.com/