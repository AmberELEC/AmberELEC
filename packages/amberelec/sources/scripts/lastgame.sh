#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024-present AmberELEC (https://github.com/AmberELEC)

hotkey_ev=/dev/input/by-path/platform-odroidgo3-joypad-event-joystick
power_ev=/dev/input/by-path/platform-ff180000.i2c-event
hotkey=BTN_TRIGGER_HAPPY1
hotkey_code=0x2c0
powerkey=KEY_POWER

ARCH="$(cat /storage/.config/.OS_ARCH)"
if [ "${ARCH}" == "RG351P" ] || [ "${ARCH}" == "RG351V" ]; then
    hotkey_ev=/dev/input/by-path/platform-ff300000.usb-usb-0:1.2:1.0-event-joystick
    hotkey=BTN_TR
    hotkey_code=0x137
elif [ "${ARCH}" == "RG552" ]; then
    power_ev=/dev/input/by-path/platform-rockchip-key-event
fi

# check if we have custom variables
if test -f /storage/.config/custom.cfg; then
    source /storage/.config/custom.cfg
fi

hotkey_press="*($hotkey), value 1*"
hotkey_release="*($hotkey), value 0*"
power_key="($powerkey), value 1"
POWER_PID=0
HOTKEY_PID=0

extract_info() {
    local string="$1"

    # Extracting the dynamic part after --rom
    rom_part="${string#*--rom }"
    rom_part="${rom_part%% --*}"

    # Extracting the dynamic part after --platform
    platform_part="${string#*--platform }"
    platform_part="${platform_part%% --*}"

    # Extracting the ROM file name only
    full_file="${rom_part##*/}"

    # Extract ROM without extension
    only_rom="${full_file%.zip}"

    # extract last ROM saved
    save_state=$(ls -tp /storage/roms/savestates/$platform_part | grep -E "$only_rom" | head -1)

    # Extract the number using sed
    save_number=$(echo "$save_state" | sed -n 's/.*state\([0-9]\{1,\}\).*/\1/p')

    # If no number is found, set number to 0
    if [ -z "$save_number" ]; then
        save_number=0
    fi

    # Return the extracted number
    echo $save_number
}

modify_command() {
    local string="$1"
    local variable="$2"

    # Replace 'autosave 0' with 'autosave 1'
    # string="${string//autosave 0/autosave 1}"

    # Extracting the dynamic part after '-state_slot '
    slot_part="${string#*-state_slot }"
    slot_part="${slot_part%% *}"

    # Replace '-state_slot <dynamic_value>' with '-state_slot $variable'
    string="${string//-state_slot $slot_part/-state_slot ${variable}}"

    echo "$string"
}

power_proc () {
    evtest --grab "$power_ev" | while read line; do
        if [[ $line == *"$power_key"* ]] || [[ $# -gt 0 ]]; then
            $(/usr/bin/adckeys.py hotkey_code release)
            PID=$(pgrep -f "sh -c -- /usr/bin/runemu.py --rom")
            if [ -n "$PID" ]; then
                # Extract and store the command related to running the emulator
                echo 1 > /sys/class/backlight/backlight/bl_power
                COMMAND=$(tr '\0' ' ' < "/proc/$PID/cmdline" | sed 's/sh -c -- //')
                if [[ $COMMAND == *"autosave 1"* ]] || [[ $(grep 'savestate_auto_save = "true"' /tmp/raappend.cfg) ]]; then
                    echo "$COMMAND" > /storage/.config/lastgame
                    $(/usr/bin/retroarch --command QUIT > /dev/null 2>&1 && /usr/bin/retroarch --command QUIT > /dev/null 2>&1)
                    sleep 0.5
                    $(/usr/bin/sync)
                    $(systemctl poweroff)
                elif [[ $COMMAND == *"autosave 0"* ]]; then
                    $(/usr/bin/retroarch --command SAVE_STATE > /dev/null 2>&1)
                    sleep 0.5
                    state_number=$(extract_info "$COMMAND")
                    new_command=$(modify_command "$COMMAND" "$state_number")
                    echo $new_command > /storage/.config/lastgame
                    $(/usr/bin/retroarch --command QUIT > /dev/null 2>&1 && /usr/bin/retroarch --command QUIT > /dev/null 2>&1)
                    sleep 0.5
                    $(/usr/bin/sync)
                    $(systemctl poweroff)
                fi
            elif ! pgrep -f "sh -c --" >/dev/null; then
                $(/usr/bin/show_splash.sh)
                $(/usr/bin/sync)
                $(systemctl poweroff)
            fi
        fi
    done
}

hotkey_proc () {
    evtest "$hotkey_ev" | while read line; do
        case $line in
            ($hotkey_press)
                pid_file="/var/run/power_proc.pid"
                if [ -f "$pid_file" ]; then
                    kill "$(cat "$pid_file")" >/dev/null 2>&1
                    rm "$pid_file"
                fi
                power_proc &
                POWER_PID=$!
                echo $POWER_PID > "$pid_file"
            ;;
                ($hotkey_release)
                kill $((POWER_PID+1))
            ;;
        esac
        if test -f /tmp/lastGame; then
            rm -rf /tmp/lastGame
            power_proc "now"
        fi
    done
}

hotkey_proc