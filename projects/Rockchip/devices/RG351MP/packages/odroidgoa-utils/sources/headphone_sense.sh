#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)

# Source predefined functions and variables
. /etc/profile

DEVICE=$(tr -d '\0' < /sys/firmware/devicetree/base/model)

if [ "$DEVICE" = "SZDiiER D007 Plus" ]; then
    # set amixer to SPK_HP
    amixer -c 0 cset iface=MIXER,name='Playback Path' SPK_HP
    # set spearker gpio 0 pin 11 to enable speaker
    echo 11 > /sys/class/gpio/export
    echo out > /sys/class/gpio/gpio11/direction
    # enable speaker
    # echo 1 > /sys/class/gpio/gpio11/value 

    # Switch to headphones if we have them already connected at boot
    GPIO=$(cat /sys/class/gpio/gpio75/value)
    [[ "$GPIO" == "0" ]] && echo 0 > /sys/class/gpio/gpio11/value || echo 1 > /sys/class/gpio/gpio11/value

    # Headphone sensing - change to symlink in case the event is differnet
    DEVICE='/dev/input/event2'

    HP_ON='*(SW_HEADPHONE_INSERT), value 1*'
    HP_OFF='*(SW_HEADPHONE_INSERT), value 0*'

    evtest "${DEVICE}" | while read line; do
        case $line in
        (${HP_ON})
        echo 0 > /sys/class/gpio/gpio11/value 
        set_ee_setting "audio.device" "headphone"
        ;;
        (${HP_OFF})
        echo 1 > /sys/class/gpio/gpio11/value
        set_ee_setting "audio.device" "speakers"
        ;;
        esac
    done
elif [ "$DEVICE" = "PowKiddy Magicx XU10" ]; then
    # Switch to headphones if we have them already connected at boot
    GPIO=$(cat /sys/class/gpio/gpio86/value)
    [[ "$GPIO" == "0" ]] && set_ee_setting "audio.device" "headphone" || set_ee_setting "audio.device" "speakers"

    if [ -e "/storage/.config/distribution/configs/distribution.conf" ]; then
    /usr/bin/odroidgoa_utils.sh setaudio $(get_ee_setting "audio.device")
    /usr/bin/odroidgoa_utils.sh vol $(get_ee_setting "audio.volume")
    fi

    # Headphone sensing 
    DEVICE='/dev/input/event1'

    HP_ON='*(SW_HEADPHONE_INSERT), value 1*'
    HP_OFF='*(SW_HEADPHONE_INSERT), value 0*'

    evtest "${DEVICE}" | while read line; do
        case $line in
        (${HP_ON})
        amixer cset name='Playback Path' HP
        set_ee_setting "audio.device" "headphone"
        ;;
        (${HP_OFF})
        amixer cset name='Playback Path' SPK
        set_ee_setting "audio.device" "speakers"
        ;;
        esac
    done

fi