#!/usr/bin/env python3
# Version: 1.1.0
# Description: OOP-based MQTT publisher to send  sensor telemetry to Mosquitto.
# pip install paho-mqtt

import json
import time
import paho.mqtt.client as mqtt


class SensorPublisher:
    def __init__(self, host: str = "192.168.10.212", port: int = 1883):
        self.host = host
        self.port = port
        self.client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)

    def connect(self):
        """Establishes connection to the MQTT broker and starts background loop."""
        self.client.connect(self.host, self.port)
        self.client.loop_start()

    def publish_status(self, topic: str, sensor_id: str, is_open: bool, retain: bool):
        """Formats  state data into JSON and publishes to target topic."""
        data = {
            "sensor": sensor_id,
            "open": is_open
        }
        payload = json.dumps(data)
        self.client.publish(topic, payload, retain=retain)
        print(f"Published message to '{topic}': {payload}")

    def disconnect(self):
        """Stops background loop and disconnects cleanly from broker."""
        time.sleep(1)
        self.client.loop_stop()
        self.client.disconnect()


def main():
    topic = "factory/level1/1/sensor1"
    
    # Initialize OOP Publisher instance
    publisher = SensorPublisher(host="192.168.10.212", port=1883)
    
    try:
        publisher.connect()
        publisher.publish_status(topic=topic, sensor_id="sensor1", is_open=False, retain=True)
    finally:
        publisher.disconnect()


if __name__ == "__main__":
    main()