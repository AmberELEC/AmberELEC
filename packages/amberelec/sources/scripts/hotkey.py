#!/usr/bin/python

import os
import subprocess
import selectors
import evdev
from evdev import ecodes

# set global hotkey
HOTKEY = evdev.ecodes.BTN_TRIGGER_HAPPY1

# powerkey - suspend
# hotkey + power - poweroff
def process_event(dev, ev, hotkey):
    if hotkey and ev.value == 1:
        if ev.code == evdev.ecodes.KEY_POWER and ev.value > 0:
            subprocess.run(['systemctl', 'poweroff'])
    elif ev.code == evdev.ecodes.KEY_POWER and ev.value == 1:
        subprocess.run(['systemctl', 'suspend'])

# read all available events from /dev/input/
def get_all_input_devices():
    input_devices = []
    for device in os.listdir('/dev/input'):
        if device.startswith('event'):
            input_devices.append(evdev.InputDevice(os.path.join('/dev/input', device)))
    return input_devices

def main():
    selector = selectors.DefaultSelector()
    devs = []

    input_devices = get_all_input_devices()

    for event_dev in input_devices:
        dev = evdev.InputDevice(event_dev)
        dev_fd = dev.fd
        selector.register(dev_fd, selectors.EVENT_READ, data=dev)
        devs.append(dev)
        #print(f"Added {event_dev}")

    hotkey = False
    selectkey = False

    while True:
        events = selector.select()
        for key, _ in events:
            dev = key.data
            for ev in dev.read():
                if ev.type == evdev.ecodes.EV_KEY:
                    if ev.code == HOTKEY:
                        hotkey = ev.value == 1
                    process_event(dev, ev, hotkey)
                    

if __name__ == "__main__":
    main()
