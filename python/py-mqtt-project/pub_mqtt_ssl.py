#!/usr/bin/env python3
# Version: 1.3.0
# Description: OOP-based MQTT publisher supporting TLS/SSL encryption, authentication, state, and telemetry metrics.
# pip install paho-mqtt

import json
import time
import paho.mqtt.client as mqtt
import random


class SensorPublisher:
    def __init__(
        self,
        host: str = "localhost",
        port: int = 8883,
        username: str = None,
        password: str = None,
        ca_cert: str = None,
    ):
        self.host = host
        self.port = port
        self.client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)

        if username and password:
            self.client.username_pw_set(username, password)

        if ca_cert:
            self.client.tls_set(ca_certs=ca_cert)

    def connect(self):
        """Establishes connection to the MQTT broker over TLS and starts background loop."""
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

    def generate_random_temperature(self, min_temp: float = 10.0, max_temp: float = 30.0) -> float:
        """Generates a random temperature value within the specified range."""
        return round(random.uniform(min_temp, max_temp), 2)


def main():
    status_topic = "factory/level1/door1/sensor1/status"
    telemetry_topic = "factory/level1/door1/sensor1/telemetry"

    status_topic2 = "factory/level1/door1/sensor2/status"
    telemetry_topic2 = "factory/level1/door1/sensor2/telemetry"

    # Initialize OOP Publisher instance with SSL and Authentication
    publisher = SensorPublisher(
        host="BER-0803",
        port=8883,
        username="factory_admin",
        password="aspen100",
        ca_cert=r"C:\mqttssl\ca.crt",
    )

    try:
        publisher.connect()

        # 1. Retained status message (saved on Mosquitto for instant pickup)
        publisher.publish_status(
            topic=status_topic, sensor_id="sensor1", is_open=False, retain=True
        )

        # 2. Non-retained telemetry measurement (streaming value)
        publisher.publish_telemetry(
            topic=telemetry_topic, sensor_id="sensor1", temperature=publisher.generate_random_temperature(), retain=False
        )
        # 1. Retained status message (saved on Mosquitto for instant pickup)
        publisher.publish_status(
            topic=status_topic2, sensor_id="sensor2", is_open=False, retain=True
        )

        # 2. Non-retained telemetry measurement (streaming value)
        publisher.publish_telemetry(
            topic=telemetry_topic2, sensor_id="sensor2", temperature=publisher.generate_random_temperature(), retain=False
        )

    finally:
        publisher.disconnect()


if __name__ == "__main__":
    main()
