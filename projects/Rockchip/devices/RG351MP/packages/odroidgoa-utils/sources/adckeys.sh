#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024-present AmberELEC (https://github.com/AmberELEC)

if [[ $(cat /sys/firmware/devicetree/base/model | tr '\0' '\n') == *"D007 Plus"* ]]; then
    DEVICE_FILE="/dev/input/by-path/platform-func-keys-event"
    while true; do
        evtest --grab "$DEVICE_FILE" | while read -r line; do
            if [[ $line == *"KEY_ESC"* ]]; then
                if [[ $line == *"value 1"* ]]; then
                    $(/usr/bin/adckeys.py startselect)
                fi
            elif [[ $line == *"KEY_RIGHTSHIFT"* ]]; then
                if [[ $line == *"value 1"* ]]; then
                    $(/usr/bin/adckeys.py select_press)
                elif [[ $line == *"value 0"* ]]; then
                    $(/usr/bin/adckeys.py select_release)
                fi
            elif [[ $line == *"KEY_ENTER"* ]]; then
                if [[ $line == *"value 1"* ]]; then
                    $(/usr/bin/adckeys.py start_press)
                elif [[ $line == *"value 0"* ]]; then
                    $(/usr/bin/adckeys.py start_release)
                fi
            fi
        done
    done
fi