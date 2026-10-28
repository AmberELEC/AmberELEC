#!/usr/bin/python

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024-present AmberELEC (https://github.com/AmberELEC)

import sys, struct, time

def write_ev_key_event(device, event_code, event_value):
    ev_key_event = struct.pack('llHHI', 0, 0, 1, event_code, event_value)
    with open(device, 'wb') as fd:
        fd.write(ev_key_event)

# Specify your input event device
input_device = '/dev/input/by-path/platform-odroidgo3-joypad-event-joystick'  # Change this to your actual device

# Specify the keys you want to simulate
key1_code = 0x2c0  # BTN_TRIGGER_HAPPY1 code, replace with your desired code
key2_code = 0x2c1  # BTN_TRIGGER_HAPPY2 code, replace with your desired code

def main(arguments):
    if len(arguments) == 1:
        argument = arguments[0]
        if argument == "select":
            # Simulate the press of two buttons simultaneously
            write_ev_key_event(input_device, key1_code, 1)

            # wait for 100 ms
            time.sleep(0.1)

            # Simulate the release of the two buttons
            write_ev_key_event(input_device, key1_code, 0)
        elif argument == "start":
            # Simulate the press of two buttons simultaneously
            write_ev_key_event(input_device, key2_code, 1)

            # wait for 100 ms
            time.sleep(0.1)

            # Simulate the release of the two buttons
            write_ev_key_event(input_device, key2_code, 0)
        elif argument == "startselect":
            # Simulate the press of two buttons simultaneously
            write_ev_key_event(input_device, key1_code, 1)
            write_ev_key_event(input_device, key2_code, 1)

            # wait for 100 ms
            time.sleep(0.1)

            # Simulate the release of the two buttons
            write_ev_key_event(input_device, key1_code, 0)
            write_ev_key_event(input_device, key2_code, 0)
        elif argument == "select_press":
            write_ev_key_event(input_device, key1_code, 1)
        elif argument == "select_release":
            write_ev_key_event(input_device, key1_code, 0)
        elif argument == "start_press":
            write_ev_key_event(input_device, key2_code, 1)
        elif argument == "start_release":
            write_ev_key_event(input_device, key2_code, 0)
        else:
            print("unknown command")
    elif len(arguments) == 2:
        argument1 = int(arguments[0], 16)
        argument2 = arguments[1]
        if argument2 == "press":
            write_ev_key_event(input_device, argument1, 1)
        elif argument2 == "release":
            write_ev_key_event(input_device, argument1, 0)
        else:
            print("Unknown combination of arguments")
    else:
        print("Please provide exactly one or two arguments.")

if __name__ == "__main__":
    if len(sys.argv) >= 2:
        user_arguments = sys.argv[1:]
        main(user_arguments)
    else:
        print("Please provide at least one argument.")