#!/bin/bash
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Fewtarius
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

# Source predefined functions and variables
. /etc/profile

CONF="/storage/.config/distribution/configs/distribution.conf"
ROM="${1##*/}"
PLATFORM="pico-8"

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


if [ ! -z "${1}" ] && [ -s "${1}" ]
then
  CART="${1}"

  #Get settings for pixel perfect
  get_setting "integer_scaling_(pixel_perfect)"
  if [ "${EES}" == "auto" ] || [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
    OPTIONS="-run"
  else
    OPTIONS="-run -pixel_perfect 1"
  fi
else
  jslisten set "killall pico8_64" &
  OPTIONS="-splore"
fi

mkdir -p "/storage/roms/pico-8"
cp -f /usr/config/SDL-GameControllerDB/gamecontrollerdb.txt /storage/roms/pico-8/sdl_controllers.txt

if [ ! -f "/storage/roms/pico-8/pico8_64" ] || [ ! -f "/storage/roms/pico-8/pico8.dat" ]; then
  text_viewer -e -w -t "Missing Pico-8 binaries!" -m "Extract your purchased pico8_64 and pico8.dat and place them in the pico-8 directory on your games partition."
else
  /storage/roms/pico-8/pico8_64 -home -root_path /storage/roms/pico-8 -joystick 0 ${OPTIONS} "${CART}"
fi

ret_error=$?

exit $ret_error
