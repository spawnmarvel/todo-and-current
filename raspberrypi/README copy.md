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

Official Raspberry Pi 4 Case, Red/White

https://www.dustin.no/product/5020006823/4-case---redwhite-for-rpi-4

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

![sonoff](https://github.com/spawnmarvel/todo-and-current/blob/main/raspberrypi/images/sonoff.png)