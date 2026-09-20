#!/usr/bin/env python3
# Version: 1.5.0
# Purpose: Display photos from USB memory stick on TV via feh, controlled via xdotool and MQTT clicks from button_1.

import os
import glob
import json
import subprocess
import paho.mqtt.client as mqtt

# Configuration - USB Mount Path
PHOTO_DIR = "/media/chilliman/UBUNTU 24_0"
MQTT_BROKER = "127.0.0.1"
MQTT_PORT = 1883
TOPIC = "zigbee2mqtt/button_1"

# State tracking
feh_process = None
images_list = []
current_index = 0

def get_images():
    extensions = ("*.jpg", "*.jpeg", "*.png", "*.JPG", "*.PNG")
    images = []
    # Search top-level directory and recursive subfolders on USB
    for root, _, _ in os.walk(PHOTO_DIR):
        for ext in extensions:
            images.extend(glob.glob(os.path.join(root, ext)))
    images.sort()
    return images

def start_feh_slideshow():
    global feh_process, images_list, current_index
    images_list = get_images()

    if not images_list:
        print(f"[Photo Album] Error: No images found in {PHOTO_DIR}")
        return

    current_index = 0
    first_image = os.path.basename(images_list[current_index])

    cmd = [
        "feh",
        "-F",              # Fullscreen
        "-Z",              # Auto-zoom / fit screen
        "--hide-pointer",  # Hide mouse pointer
        "--slideshow-delay", "99999"  # Pause automatic progression
    ] + images_list
    
    env = os.environ.copy()
    env["DISPLAY"] = ":0"
    
    feh_process = subprocess.Popen(cmd, env=env)
    print(f"[Photo Album] Started feh with {len(images_list)} images from USB ({PHOTO_DIR})")
    print(f"[Photo Album] Currently displaying: {first_image} (Index {current_index + 1}/{len(images_list)})")

def handle_action(action):
    global current_index, images_list
    if not images_list:
        return

    env = os.environ.copy()
    env["DISPLAY"] = ":0"

    if action == "single":
        current_index = (current_index + 1) % len(images_list)
        image_name = os.path.basename(images_list[current_index])
        print(f"[Photo Album] Single click -> Displaying: {image_name} (Index {current_index + 1}/{len(images_list)})")
        subprocess.run(["xdotool", "search", "--onlyvisible", "--class", "feh", "key", "n"], env=env)

    elif action == "double":
        current_index = 0
        image_name = os.path.basename(images_list[current_index])
        print(f"[Photo Album] Double click -> Resetting to: {image_name} (Index 1/{len(images_list)})")
        subprocess.run(["xdotool", "search", "--onlyvisible", "--class", "feh", "key", "Home"], env=env)

def on_connect(client, userdata, flags, reason_code, properties):
    print(f"[MQTT] Connected to broker (reason code {reason_code}). Subscribing to {TOPIC}...")
    client.subscribe(TOPIC)

def on_message(client, userdata, msg):
    try:
        payload = json.loads(msg.payload.decode("utf-8"))
        if "action" in payload and payload["action"]:
            action = payload["action"]
            print(f"[MQTT] Button action received: {action}")
            handle_action(action)
    except Exception as e:
        print(f"[MQTT] Error parsing message: {e}")

if __name__ == "__main__":
    start_feh_slideshow()

    client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
    client.on_connect = on_connect
    client.on_message = on_message

    client.connect(MQTT_BROKER, MQTT_PORT, 60)
    client.loop_forever()