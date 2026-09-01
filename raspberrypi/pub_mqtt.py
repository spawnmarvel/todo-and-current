#!/usr/bin/env python3
# Version: 1.0.0
# Description: Simple MQTT publisher to test sending data to Mosquitto.
# pip install paho-mqtt

import json
import time
import paho.mqtt.client as mqtt

# Broker configuration
# raspberrypi:
BROKER_HOST = "192.168.10.212"
BROKER_PORT = 1883
TOPIC = "factory/level1/door1/sensor1"

def main():
    # Instantiate client using Paho MQTT v2 API standard
    client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)

    # Connect to Mosquitto broker
    client.connect(BROKER_HOST, BROKER_PORT)
    client.loop_start()

    # Telemetry test payload
    data = {
        "sensor": "sensor1",
        "open": True
    }

    # Convert dict to JSON string and publish
    payload = json.dumps(data)
    client.publish(TOPIC, payload)
    print(f"Published message to '{TOPIC}': {payload}")

    # Allow background thread time to complete transmission
    time.sleep(1)
    client.loop_stop()
    client.disconnect()

if __name__ == "__main__":
    main()