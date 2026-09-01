#!/usr/bin/env python3
# Version: 1.0.0
# Description: MQTT subscriber consuming JSON telemetry data from Mosquitto.

import json
import paho.mqtt.client as mqtt

# raspberrypi:
BROKER_HOST = "192.168.10.212"
BROKER_PORT = 1883
TOPIC_PATTERN = "factory/#"  # # wildcard listens to all topics under factory/

def on_connect(client, userdata, flags, reason_code, properties=None):
    if reason_code == 0:
        print(f"Connected to Mosquitto. Subscribing to '{TOPIC_PATTERN}'...")
        client.subscribe(TOPIC_PATTERN)
    else:
        print(f"Failed to connect, return code: {reason_code}")

def on_message(client, userdata, msg):
    try:
        # Decode UTF-8 bytes payload to dict
        payload_str = msg.payload.decode("utf-8")
        data = json.loads(payload_str)
        
        print(f"\n[RECEIVED] Topic: {msg.topic}")
        print(f"Payload: {data}")

        # Extract specific keys from the payload
        if "sensor" in data:
            print(f" -> Sensor ID: {data['sensor']}")
        if "open" in data:
            status = "OPEN" if data["open"] else "CLOSED"
            print(f" -> Door Status: {status}")

    except json.JSONDecodeError:
        print(f"Received non-JSON message on {msg.topic}: {msg.payload}")

def main():
    # Instantiate client using Paho MQTT v2 API standard
    client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)

    # Attach callbacks
    client.on_connect = on_connect
    client.on_message = on_message

    print(f"Connecting to Mosquitto broker at {BROKER_HOST}:{BROKER_PORT}...")
    client.connect(BROKER_HOST, BROKER_PORT, keepalive=60)

    # Blocking loop to keep listening for incoming messages
    try:
        client.loop_forever()
    except KeyboardInterrupt:
        print("\nStopping consumer...")
    finally:
        client.disconnect()
        print("Disconnected cleanly.")

if __name__ == "__main__":
    main()