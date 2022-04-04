#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

# Source predefined functions and variables
. /etc/profile

EE_DEVICE=$(cat /storage/.config/.OS_ARCH)

ROM="${1##*/}"
PLATFORM="saturn"
CONF="/storage/.config/distribution/configs/distribution.conf"

function get_setting() {
        #We look for the setting on the ROM first, if not found we search for platform and lastly we search globally
        PAT="s|^${PLATFORM}\[\"${ROM}\"\].*${1}=\(.*\)|\1|p"
        EES=$(sed -n "${PAT}" "${CONF}" | head -1)

        if [ -z "${EES}" ]; then
                PAT="s|^${PLATFORM}[\.-]${1}=\(.*\)|\1|p"
                EES=$(sed -n "${PAT}" "${CONF}" | head -1)
        fi

        if [ -z "${EES}" ]; then
                PAT="s|^global[\.-].*${1}=\(.*\)|\1|p"
                EES=$(sed -n "${PAT}" "${CONF}" | head -1)
        fi

        [ -z "${EES}" ] && EES="false"
}

# Use HLEBIOS
# Get configuration from distribution.conf
get_setting "use_hlebios"
if [ "${EES}" == "auto" ] || [ "${EES}" == "standard" ] || [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
        HLEBIOS='0'
else
        HLEBIOS='1'
fi


mkdir -p "/storage/roms/saturn/yabasanshiro/"

BIOS=""

# Gamepad Autoconfiguration
GAMEPAD=$(sdljoytest -skip_loop | grep "0 name" | sed "s|Joystick 0 name ||")
GAMEPADCONFIG=$(xmlstarlet sel -t -c "//inputList/inputConfig[@deviceName=${GAMEPAD}]" -n /storage/.emulationstation/es_input.cfg)

if [ ! -z "${GAMEPADCONFIG}" ]; then
    echo -e "<?xml version=\"1.0\"?>\n<inputList>" > "/storage/roms/saturn/yabasanshiro/input.cfg"
    echo "${GAMEPADCONFIG}" >> "/storage/roms/saturn/yabasanshiro/input.cfg"
    echo "</inputList>" >> "/storage/roms/saturn/yabasanshiro/input.cfg"
fi

# if the auto config was not succesful copy the default just in case.
if [ ! -e "/storage/roms/saturn/yabasanshiro/input.cfg" ]; then
    cp -rf "/usr/config/yabasanshiro/input.cfg" "/storage/roms/saturn/yabasanshiro/input.cfg"
fi

if [ "${HLEBIOS}" != 1 ]; then 
    if [ -e "/storage/roms/bios/saturn_bios.bin" ]; then
        BIOS="-b /storage/roms/bios/saturn_bios.bin"
    else
        text_viewer -e -w -t "Notice! Yabasanshiro BIOS Missing!" -m "/storage/roms/bios/saturn_bios.bin was not found!\n\nYabasanshiro will continue to load with HLE BIOS\n\nTo avoid this message please copy saturn_bios.bin with checksum af5828fdff51384f99b3c4926be27762 to /storage/roms/bios/\n\nOr select \"USE HLE BIOS\" on the emulator options"
        BIOS=""
    fi
fi

# hide event4 on RG552
if [[ "$EE_DEVICE" == RG552 ]]; then
  mv /dev/input/event4 /dev/input/_event4
fi

# We use { } to avoid SIGUSR signal showing text and messing up with the error handling
{ yabasanshiro -r 2 -i "${1}" ${BIOS}; } > /tmp/logs/exec.log 2>&1

# restore event4 on RG552
if [[ "$EE_DEVICE" == RG552 ]]; then
  mv /dev/input/_event4 /dev/input/event4
fi
