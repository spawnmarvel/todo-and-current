
# Python and MQTT

1. Get to know Eclipse Mosquitto and Python paho-mqtt

2. MQTT Explorer Setup Connection

3. Python Script (v1.0.0)

4. Verification in MQTT Explorer

## Table of Contents

- [Python and MQTT](#python-and-mqtt)
  - [Table of Contents](#table-of-contents)
  - [Eclipse Mosquitto](#eclipse-mosquitto)
  - [Comparing MQTT Brokers and OPC UA vs MQTT](#comparing-mqtt-brokers-and-opc-ua-vs-mqtt)
  - [Python](#python)
    - [Publish](#publish)
    - [Consume](#consume)
    - [Retained Messages](#retained-messages)
      - [When to Use retain=True](#when-to-use-retaintrue)
      - [When NOT to Use retain=True](#when-not-to-use-retaintrue)
      - [Key Takeaway](#key-takeaway)
  - [Clean up mapping and path](#clean-up-mapping-and-path)
  - [SSL Mosquitto](#ssl-mosquitto)


## Eclipse Mosquitto

An open source MQTT broker

* https://mosquitto.org/

Let's get to know the broker as we do coding.

mosquitto-2.1.2-install-windows-x64.exe

Download it and install it on windows

C:\Program Files\Mosquitto

Then you get a service

* Mosquitto Broker, Eclipse Mosquitto MQTT v5/v3.1.1 broker


![localhost](https://github.com/spawnmarvel/todo-and-current/blob/main/python/py-mqtt-project/images/localhost.png)

## Comparing MQTT Brokers and OPC UA vs MQTT

Comparing MQTT Brokers for the Industrial IoT

* https://www.umh.app/insight/comparing-mqtt-brokers-for-the-industrial-iot

OPC UA vs MQTT: Which Protocol Should You Use for IIoT Data Integration?

The Best Answer Is Often: Use Both

This hybrid approach — sometimes called the OPC UA to MQTT bridge pattern — is increasingly common in Industry 4.0 architectures.

For example, a manufacturing plant running ABB AC 800M controllers might use OPC UA to collect structured process data, then forward that data via MQTT to an Azure IoT Hub for cloud-based analytics and predictive maintenance models.

* https://vnodeautomation.com/opc-ua-vs-mqtt/


## Python

### Publish

```cmd
pip install paho-mqtt
python pub_mqtt.py

```

Log

```log
Published message to 'factory/level1/door1/sensor1': {"sensor": "sensor1", "open": true}
```

View in MQTT Explorer


### Consume

To do consume, we must first start the consumer in one session.

```cmd
python sub_mqtt.py
Connecting to Mosquitto broker at 192.168.10.212:1883...
Connected to Mosquitto. Subscribing to 'factory/#'...
```

But we have no messages, not event the last that was published.

Ok, lets start the publisher and publish a new packet

```cmd
python pub_mqtt.py
Published message to 'factory/level1/door1/sensor1': {"sensor": "sensor1", "open": false}

```

Now back at the consumer

```cmd
python sub_mqtt.py
Connecting to Mosquitto broker at 192.168.10.212:1883...
Connected to Mosquitto. Subscribing to 'factory/#'...

[RECEIVED] Topic: factory/level1/door1/sensor1
Payload: {'sensor': 'sensor1', 'open': False}
 -> Sensor ID: sensor1
 -> Door Status: CLOSED
```

https://pypi.org/project/paho-mqtt/


### Retained Messages

When you launch sub_mqtt.py afterward, it receives nothing until a brand-new message is published.

The Solution: Retained Messages

* MQTT addresses this using the Retain Flag (retain=True)


1. Mosquitto delivers the message to all current subscribers.

2. Mosquitto stores the message in memory as the "last known good value" for that specific topic (factory/level1/door1/sensor1).

3. Whenever a new subscriber (sub_mqtt.py) connects later, Mosquitto instantly delivers the stored message.

Add retain=True to your publish() call.

Now, when you execute python3 pub_mqtt.py and exit, starting python3 sub_mqtt.py minutes later will immediately yield the door's last published status.


Yes, for state-based data, using retain=True is considered industry best practice. It provides an instant "state snapshot" to any client, dashboard, or service that connects or restarts later, without waiting for the next scheduled transmission.


#### When to Use retain=True

● State & Status Data: Door positions (open/closed), switch states (on/off), or system status (online/offline).

● Slow-Changing Telemetry: Room temperature, soil moisture, or battery level where updates occur infrequently (e.g., every 15–30 minutes).

● Device Birth/Death Messages (LWT): Last Will and Testament payloads that declare whether a device is reachable.

#### When NOT to Use retain=True

● Event Streams & Actions: Commands like button_click, doorbell_ring, or motion_detected. If retained, a newly connected consumer would re-trigger an action (like playing a chime or triggering an alarm) based on stale data.

● High-Frequency Telemetry: High-rate sensor logs (e.g., vibration analysis at 100 Hz) where historical trend aggregators (like Prometheus or databases) capture data continuously, rendering individual point snapshots unnecessary.

#### Key Takeaway

Think of MQTT topics as storage slots:

● retain=False: Treat the message like a live radio broadcast (if you aren't listening when it airs, you miss it).

● retain=True: Treat the message like a status board (the current value remains displayed on the wall until replaced by a new one).

![retain](https://github.com/spawnmarvel/todo-and-current/blob/main/python/py-mqtt-project/images/retain.png)


## Clean up mapping and path

So if we are to build something we need to think about a structure, lets clean up the publisher a bit and use retain for state and telemetry and use uns.

```ini
status_topic = "factory/level1/door1/sensor1/status"
telemetry_topic = "factory/level1/door1/sensor1/telemetry"

```

Telemetry

![uns telemetry](https://github.com/spawnmarvel/todo-and-current/blob/main/python/py-mqtt-project/images/uns_tele.png)

Status

![uns status](https://github.com/spawnmarvel/todo-and-current/blob/main/python/py-mqtt-project/images/uns_status.png)


## SSL Mosquitto

Lets enable ssl before we proceed.

C:\Program Files\Mosquitto

mosquitto.conf

1. Create Password File and Enable Authentication

Open Command Prompt as Administrator and navigate to your Mosquitto installation directory:

Run mosquitto_passwd.exe to create a new password file named pwfile and add a user (e.g., factory_admin)
```cmd

cd "C:\Program Files\Mosquitto"

mosquitto_passwd.exe -c pwfile factory_admin
Password:

Reenter password:

Adding password for user factory_admin

```
It is the tech from aspen that is 100 years old.

2. Generate TLS Certificates (OpenSSL)

Create a dedicated folder for certificates and passwd:

```cmd
mkdir "C:\mqttssl"

```

Generate certs

```cmd
c:\Program Files\OpenSSL-Win64\bin>openssl version
OpenSSL 1.1.1m  14 Dec 2021
# 1. Generate CA private key and certificate
openssl req -new -x509 -days 3650 -extensions v3_ca -keyout C:\mqttssl\ca.key -out C:\mqttssl\ca.crt -subj "/CN=MosquittoCA" -nodes

# 2. Generate Server private key
openssl genrsa -out C:\mqttssl\server.key 2048

# 3. Generate Certificate Signing Request (CSR)
# NOTE: Replace 'localhost' with your broker's actual IP/hostname if connecting from remote machines

openssl req -new -key C:\mqttssl\server.key -out C:\mqttssl\server.csr -subj "/CN=BER-0803"

# 4. Sign the Server certificate with your CA
openssl x509 -req -in C:\mqttssl\server.csr -CA C:\mqttssl\ca.crt -CAkey C:\mqttssl\ca.key -CAcreateserial -out C:\mqttssl\server.crt -days 3650
```

3. Configure Mosquitto (mosquitto.conf)

Take a backup of mosquitto.conf

And move the files to correct location C:\mqttssl, else it the service will not start, we can not store them inside mosquitto folder.

Open C:\Program Files\Mosquitto\mosquitto.conf in a text editor as Administrator and add or update the following settings:

```ini
# =================================================================
# General configuration
# =================================================================
per_listener_settings false

# =================================================================
# Listeners
# =================================================================

# Encrypted TLS Listener
listener 8883
allow_anonymous false
password_file C:\mqttssl\pwfile

cafile C:\mqttssl\ca.crt
certfile C:\mqttssl\server.crt
keyfile C:\mqttssl\server.key
tls_version tlsv1.2
```


Check config

```cmd
cd "C:\Program Files\Mosquitto"

mosquitto.exe -c mosquitto.conf -v
1788511224: The 'per_listener_settings' option is now deprecated and will be removed in version 3.0. Please see the documentation for how to achieve the same effect.
1788511224: mosquitto version 2.1.2 starting
1788511224: Config loaded from mosquitto.conf.
1788511224: Bridge support available.
1788511224: Persistence support available.
1788511224: TLS support available.
1788511224: TLS-PSK support available.
1788511224: Websockets support available.
1788511224: Plugin builtin-security has registered to receive 'basic-auth' events.
1788511224: Opening ipv6 listen socket on port 8883.
1788511224: Opening ipv4 listen socket on port 8883.
1788511224: mosquitto version 2.1.2 running

```
Restart service and login.


![ssl](https://github.com/spawnmarvel/todo-and-current/blob/main/python/py-mqtt-project/images/ssl.png)


Now run the updated code with ssl:

```cmd
python pub_mqtt_ssl.py
```

log

```log
Published status to 'factory/level1/door1/sensor1/status' (retain=True): {"sensor": "sensor1", "open": false}
Published telemetry to 'factory/level1/door1/sensor1/telemetry' (retain=False): {"sensor": "sensor1", "temperature": 22.1}

```


## Quality of Service (QoS 0, 1, and 2) tbd

## Last Will and Testament (LWT)

