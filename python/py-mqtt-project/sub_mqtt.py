#!/usr/bin/env python3
# Version: 1.1.0
# Description: OOP-based MQTT subscriber consuming telemetry data from Mosquitto.
# pip install paho-mqtt

import json
import paho.mqtt.client as mqtt


class SensorConsumer:
    def __init__(self, host: str = "127.0.0.1", port: int = 1883, topic_pattern: str = "factory/#"):
        self.host = host
        self.port = port
        self.topic_pattern = topic_pattern

        # Instantiate client using Paho MQTT v2 API standard
        self.client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)

        # Attach instance methods as callbacks
        self.client.on_connect = self._on_connect
        self.client.on_message = self._on_message

    def _on_connect(self, client, userdata, flags, reason_code, properties=None):
        """Callback executed when client connects to broker."""
        if reason_code == 0:
            print(
                f"Connected to Mosquitto. Subscribing to '{self.topic_pattern}'...")
            self.client.subscribe(self.topic_pattern)
        else:
            print(f"Failed to connect, return code: {reason_code}")

    def _on_message(self, client, userdata, msg):
        """Callback executed when a message arrives on a subscribed topic."""
        try:
            payload_str = msg.payload.decode("utf-8")
            data = json.loads(payload_str)

            print(f"\n[RECEIVED] Topic: {msg.topic}")
            print(f"Payload: {data}")

            if "sensor" in data:
                print(f" -> Sensor ID: {data['sensor']}")
            if "open" in data:
                status = "OPEN" if data["open"] else "CLOSED"
                print(f" ->  Status: {status}")

        except json.JSONDecodeError:
            print(f"Received non-JSON message on {msg.topic}: {msg.payload}")

    def start(self):
        """Starts connection and blocks thread to process incoming events."""
        print(f"Connecting to Mosquitto broker at {self.host}:{self.port}...")
        self.client.connect(self.host, self.port, keepalive=60)

        try:
            self.client.loop_forever()
        except KeyboardInterrupt:
            print("\nStopping consumer...")
        finally:
            self.client.disconnect()
            print("Disconnected cleanly.")


def main():
    consumer = SensorConsumer(
        host="192.168.10.212",
        port=1883,
        topic_pattern="factory/#"
    )
    consumer.start()


if __name__ == "__main__":
    main()
