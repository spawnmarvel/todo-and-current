
# Python and MQTT

1. Get to know Eclipse Mosquitto and Python paho-mqtt

2. MQTT Explorer Setup Connection

3. Python Script (v1.0.0)

4. Verification in MQTT Explorer

5. Secure mqtt and build or mirror something fun

## Table of Contents

- [Eclipse Mosquitto](#eclipse-mosquitto)
- [Python](#python)
- [Publish](#publish)
- [Consume](#consume)

## Eclipse Mosquitto

An open source MQTT broker

* https://mosquitto.org/

Let's get to know the broker as we do coding.


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


![pub 1](https://github.com/spawnmarvel/todo-and-current/blob/main/raspberrypi/iamgespy/pub1.png)


### Consume

To do consume, we must first start the consumer in one session.

```cmd
python sub_mqtt.py
Connecting to Mosquitto broker at 192.168.10.212:1883...
Connected to Mosquitto. Subscribing to 'factory/#'...
```

Then we start the publisher and publish a new packet

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