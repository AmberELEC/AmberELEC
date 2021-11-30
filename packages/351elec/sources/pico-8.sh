#!/bin/bash
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Fewtarius

# Source predefined functions and variables
. /etc/profile

if [ ! -z "${1}" ]
then
  OPTIONS="-run"
  CART="${1}"
else
  OPTIONS="-splore"
fi

if [ ! -d "/storage/roms/pico-8" ]
then
  mkdir -p "/storage/roms/pico-8"
  echo "Extract your purchased pico-8 binaries and place them in the pico-8 directory on your games partition" >/tmp/logs/exec.log
fi

cp -f /usr/config/SDL-GameControllerDB/gamecontrollerdb.txt /storage/roms/pico-8/sdl_controllers.txt

unset MYARCH
TEST=$(ldd /usr/bin/emulationstation | grep 64)
if [ $? == 0 ]
then
  patchelf --set-interpreter /usr/lib32/ld-linux-armhf.so.3 /storage/roms/pico-8/pico8_dyn
  export LD_LIBRARY_PATH=/usr/lib32
fi

/storage/roms/pico-8/pico8_dyn -home -root_path /storage/roms/pico-8 -joystick 0 ${OPTIONS} "${CART}"

ret_error=$?

exit $ret_error
