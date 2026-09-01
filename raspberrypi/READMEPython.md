
# Python and MQTT

1. Get to know Eclipse Mosquitto and Python paho-mqtt

2. MQTT Explorer Setup Connection

3. Python Script (v1.0.0)

4. Verification in MQTT Explorer

### Eclipse Mosquitto

An open source MQTT broker

* https://mosquitto.org/

Let's get to know the broker before we start coding.


### Python



#### Publish

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


#### Consume

https://pypi.org/project/paho-mqtt/