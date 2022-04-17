#!/bin/bash
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Fewtarius
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

# Source predefined functions and variables
. /etc/profile

if [ ! -z "${1}" ] && [ -s "${1}" ]
then
  OPTIONS="-run"
  CART="${1}"
else
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