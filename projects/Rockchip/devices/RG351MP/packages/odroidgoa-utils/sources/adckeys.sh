#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024-present AmberELEC (https://github.com/AmberELEC)

if [[ $(cat /sys/firmware/devicetree/base/model | tr '\0' '\n') == *"D007 Plus"* ]]; then
    DEVICE_FILE="/dev/input/by-path/platform-rg351-keys-event"
    while true; do
        if pgrep -fn "/usr/bin/runemu.py" >/dev/null; then
            evtest --grab "${DEVICE_FILE}" | while read -r line; do
                if [[ ${line} == *"KEY_ESC"* ]]; then
                    if [[ ${line} == *"value 1"* ]]; then
                        $(/usr/bin/adckeys.py startselect)
                    fi
                elif [[ ${line} == *"KEY_RIGHTSHIFT"* ]]; then
                        if [[ ${line} == *"value 1"* ]]; then
                            $(/usr/bin/adckeys.py select_press)
                        elif [[ ${line} == *"value 0"* ]]; then
                            $(/usr/bin/adckeys.py select_release)
                        fi
                elif [[ ${line} == *"KEY_ENTER"* ]]; then
                        if [[ ${line} == *"value 1"* ]]; then
                            $(/usr/bin/adckeys.py start_press)
                        elif [[ ${line} == *"value 0"* ]]; then
                            $(/usr/bin/adckeys.py start_release)
                        fi
                elif [[ ${line} == *"KEY_VOLUMEUP"* ]]; then
                    if [[ ${line} == *"value 1"* ]]; then
                        $(/usr/bin/odroidgoa_utils.sh vol + > /dev/null 2>&1)
                    fi
                elif [[ ${line} == *"KEY_VOLUMEDOWN"* ]]; then
                    if [[ ${line} == *"value 1"* ]]; then
                        $(/usr/bin/odroidgoa_utils.sh vol - > /dev/null 2>&1)
                    fi
                elif ! pgrep -f "/usr/bin/runemu.py" >/dev/null; then
                    systemctl restart adckeys
                fi
            done
        fi
    done
fi