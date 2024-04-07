#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024-present AmberELEC (https://github.com/AmberELEC)

. /etc/profile

# cleanup in case of failure
rm -f /tmp/onSleep /tmp/ssDate /tmp/sdDate /tmp/lastGame /tmp/resume_game

# Set the input device path
ARCH="$(cat /storage/.config/.OS_ARCH)"
if [ "${ARCH}" == "RG351P" ] || [ "${ARCH}" == "RG351V" ]; then
    input_device=/dev/input/by-path/platform-ff300000.usb-usb-0:1.2:1.0-event-joystick
else
    input_device=/dev/input/by-path/platform-odroidgo3-joypad-event-joystick
fi

platform=$1
rom=$(basename "$2")

# Read the configuration file
config=$(cat /storage/.config/distribution/configs/distribution.conf)

# Extract the values based on the selected parameter using basic regular expressions
prom="$platform\[\"$rom\"\]"

es_sdt=""
es_sst=""

get_value() {
    if [ -z "$es_sdt" ]; then
        es_sdt=$(echo "$config" | grep "$1\.screensaverautoshutdowntime" | awk -F '=' '{print $2}')
    fi
    if [ -z "$es_sst" ]; then
        es_sst=$(echo "$config" | grep "$1\.screensavertime" | awk -F '=' '{print $2}')
    fi
}

get_value "$prom"
get_value "$platform"
get_value "global"

if [[ $es_sst == "0" ]]; then
    exit
fi

if [[ $es_sdt == "off" ]]; then
    es_sdt=-1
fi

# Define the duration in seconds
duration=$(($es_sst*60))
sdown=$(($es_sdt*60))

# check if we have custom variables
if test -f /storage/.config/custom.cfg; then
    source /storage/.config/custom.cfg
fi

# Set start time
start_time=$(date +%s)
echo $start_time > /tmp/ssDate

evtest "$input_device" | while read -r line; do
    # Check if the line contains "Event: time" indicating an input event
    if [[ "$line" == *"Event: time"* ]]; then
        if ! test -f /tmp/onSleep; then
            echo $(date +%s) > /tmp/ssDate
        else
            rm -f /tmp/onSleep
            powermode=$(</dev/shm/powermode)
            rm -f /dev/shm/powermode
            eval "$powermode"
            if pgrep -fn "/usr/bin/retroarch" >/dev/null; then
                if test -f /tmp/resume_game; then
                    $(rm -f /tmp/resume_game)
                    /usr/bin/retroarch --command RESUME_GAME > /dev/null 2>&1
                fi
            fi
            echo 0 > /sys/class/backlight/backlight/bl_power
        fi
    fi
done &

# Loop until current time exceeds start time + duration
while true; do
    if ! test -f /tmp/onSleep; then
        if ! pgrep -fn "/usr/bin/mpv" >/dev/null; then
            start_time=$(date +%s)
            exit_flag=0
            while [[ $(($(date +%s) - start_time)) -lt "$duration" ]]; do
                if ! pgrep -fn "/usr/bin/runemu.py" >/dev/null; then
                    exit
                fi
                new_date=$(cat /tmp/ssDate)
                if [[ "$start_time" -lt "$new_date" ]]; then
                    exit_flag=0
                    break
                else
                    sleep 1
                    if [[ "$sdown" -eq 0 ]]; then
                        exit_flag=2
                    else
                        exit_flag=1
                    fi
                fi
            done
            if [[ "$exit_flag" -eq 1 ]]; then
                touch /tmp/onSleep
                echo 1 > /sys/class/backlight/backlight/bl_power
                $(cat /tmp/powermode > /dev/shm/powermode)
                $(powersave "screensaver")
                if pgrep -fn "/usr/bin/retroarch" >/dev/null; then
                    isOnPause=$(echo -n "GET_STATUS" | nc -u -w1 127.0.0.1 55355 | awk '{print $2}')
                    if [[ "$isOnPause" != "PAUSED" ]]; then
                        touch /tmp/resume_game
                        /usr/bin/retroarch --command PAUSE_GAME > /dev/null 2>&1
                    fi
                fi
                doShutDown=false
                if [[ "$sdown" -gt 0 ]]; then
                    sd_time=$(date +%s)
                    while [[ $(($(date +%s) - sd_time)) -lt "$sdown" ]]; do
                        if ! pgrep -fn "/usr/bin/runemu.py" >/dev/null; then
                            exit
                        elif ! test -f /tmp/onSleep; then
                            doShutDown=false
                            break
                        fi
                        sleep 1
                        doShutDown=true

                    done
                    if $doShutDown ; then
                        powermode=$(</dev/shm/powermode)
                        rm -f /dev/shm/powermode
                        eval "$powermode"
                        $(touch /tmp/lastGame)
                        $(systemctl restart lastgame)
                    fi
                fi
            elif [[ "$exit_flag" -eq 2 ]]; then
                $(touch /tmp/lastGame)
                $(systemctl restart lastgame)
            fi
        fi
    fi
done
