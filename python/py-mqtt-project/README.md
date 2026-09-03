
# Python and MQTT

1. Get to know Eclipse Mosquitto and Python paho-mqtt

2. MQTT Explorer Setup Connection

3. Python Script (v1.0.0)

4. Verification in MQTT Explorer

## Table of Contents

- [Python and MQTT](#python-and-mqtt)
  - [Table of Contents](#table-of-contents)
  - [Eclipse Mosquitto](#eclipse-mosquitto)
  - [Python](#python)
    - [Publish](#publish)
    - [Consume](#consume)
    - [Retained Messages](#retained-messages)
      - [When to Use retain=True](#when-to-use-retaintrue)
      - [When NOT to Use retain=True](#when-not-to-use-retaintrue)
      - [Key Takeaway](#key-takeaway)
  - [Clean up mapping and path](#clean-up-mapping-and-path)


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

## Clean up mapping and path

So if we are to build something we need to think about a structure, lets clean up the publisher a bit and use retain for state and telemetry and use uns.

```ini
status_topic = "factory/level1/door1/sensor1/status"
telemetry_topic = "factory/level1/door1/sensor1/telemetry"

```

Telemetry

![uns telemetry]()https://github.com/spawnmarvel/todo-and-current/blob/main/python/py-mqtt-project/images/uns_tele.png

Status

![uns status](https://github.com/spawnmarvel/todo-and-current/blob/main/python/py-mqtt-project/images/uns_status.png)



