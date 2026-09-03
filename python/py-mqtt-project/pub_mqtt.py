#!/usr/bin/env python3
# Version: 1.2.0
# Description: OOP-based MQTT publisher supporting state and telemetry metrics.
# pip install paho-mqtt

import json
import time
import paho.mqtt.client as mqtt


class SensorPublisher:
    def __init__(self, host: str = "127.0.0.1", port: int = 1883):
        self.host = host
        self.port = port
        self.client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)

    def connect(self):
        """Establishes connection to the MQTT broker and starts background loop."""
        self.client.connect(self.host, self.port)
        self.client.loop_start()

    def publish_status(self, topic: str, sensor_id: str, is_open: bool, retain: bool = True):
        """Publishes state/status data with retain=True by default."""
        data = {
            "sensor": sensor_id,
            "open": is_open
        }
        payload = json.dumps(data)
        self.client.publish(topic, payload, retain=retain)
        print(f"Published status to '{topic}' (retain={retain}): {payload}")

    def publish_telemetry(self, topic: str, sensor_id: str, temperature: float, retain: bool = False):
        """Publishes sensor telemetry reading (e.g. temperature) with retain=False by default."""
        data = {
            "sensor": sensor_id,
            "temperature": temperature
        }
        payload = json.dumps(data)
        self.client.publish(topic, payload, retain=retain)
        print(f"Published telemetry to '{topic}' (retain={retain}): {payload}")

    def disconnect(self):
        """Stops background loop and disconnects cleanly from broker."""
        time.sleep(1)
        self.client.loop_stop()
        self.client.disconnect()


def main():
    status_topic = "factory/level1/door1/sensor1/status"
    telemetry_topic = "factory/level1/door1/sensor1/telemetry"

    # Initialize OOP Publisher instance
    publisher = SensorPublisher(host="127.0.0.1", port=1883)

    try:
        publisher.connect()

        # 1. Retained status message (saved on Mosquitto for instant pickup)
        publisher.publish_status(
            topic=status_topic, sensor_id="sensor1", is_open=False, retain=True
        )

        # 2. Non-retained telemetry measurement (streaming value)
        publisher.publish_telemetry(
            topic=telemetry_topic, sensor_id="sensor1", temperature=22.1, retain=False
        )
    finally:
        publisher.disconnect()


if __name__ == "__main__":
    main()
