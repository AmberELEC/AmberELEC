#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024-present tech4bot (https://github.com/tech4bot)
# Copyright (C) 2024-present AmberELEC (https://github.com/AmberELEC)

# Source predefined functions and variables
. /etc/profile

DEVICE=$(tr -d '\0' < /sys/firmware/devicetree/base/model)

if [ "$DEVICE" = "SZDiiER D007 Plus" ]; then
    # Configuration file
    CONFIG_FILE="/storage/.config/joyleds.cfg"

    # Function to check and create the configuration file
    check_create_config_file() {
        if [ ! -e "$CONFIG_FILE" ]; then
            echo "0" > "$CONFIG_FILE"
        fi
    }

    # Function to read the configuration value
    read_config() {
        cat "$CONFIG_FILE"
    }

    # Function to write the configuration value
    write_config() {
        echo "$1" > "$CONFIG_FILE"
    }

    # Check and create the configuration file
    check_create_config_file

    # Read the configuration value
    RUN_SCRIPT=$(read_config)

    # Perform actions based on the configuration value
    case $RUN_SCRIPT in
        0)
            # Input device path
            INPUT_DEVICE="/dev/input/by-path/platform-odroidgo3-joypad-joystick"

            # Run jstest with specific options to capture joystick events
            stdbuf -oL jstest --event "$INPUT_DEVICE" | \
            while read -r line; do
                if [[ $line == *"type 2,"* && $line == *"number 0, value "* ]]; then
                    if [[ $line != *"number 0, value 0"* ]]; then
                        # Y-axis movement for left joystick ON
                        echo 1 > /sys/class/leds/left_joystick/brightness
                    else
                        # Y-axis movement for left joystick OFF
                        echo 0 > /sys/class/leds/left_joystick/brightness
                    fi
                elif [[ $line == *"type 2,"* && $line == *"number 1, value "* ]]; then
                    if [[ $line != *"number 1, value 0"* ]]; then
                        # Y-axis movement for left joystick ON
                        echo 1 > /sys/class/leds/left_joystick/brightness
                    else
                        # Y-axis movement for left joystick OFF
                        echo 0 > /sys/class/leds/left_joystick/brightness
                    fi
                elif [[ $line == *"type 2,"* && $line == *"number 2, value "* ]]; then
                    if [[ $line != *"number 2, value 0"* ]]; then
                        # Y-axis movement for right joystick ON
                        echo 1 > /sys/class/leds/right_joystick/brightness
                    else
                        # Y-axis movement for right joystick OFF
                        echo 0 > /sys/class/leds/right_joystick/brightness
                    fi
                elif [[ $line == *"type 2,"* && $line == *"number 3, value "* ]]; then
                    if [[ $line != *"number 3, value 0"* ]]; then
                        # Y-axis movement for right joystick ON
                        echo 1 > /sys/class/leds/right_joystick/brightness
                    else
                        # Y-axis movement for right joystick OFF
                        echo 0 > /sys/class/leds/right_joystick/brightness
                    fi
                fi
            done
            ;;
        1)
            # Run this one time if config value is 1
            echo 1 > /sys/class/leds/left_joystick/brightness
            echo 1 > /sys/class/leds/right_joystick/brightness
            ;;
        2)
            # Run this one time if config value is 2
            echo 0 > /sys/class/leds/left_joystick/brightness
            echo 0 > /sys/class/leds/right_joystick/brightness
            ;;
        *)
            echo "Invalid configuration value."
            ;;
    esac
fi