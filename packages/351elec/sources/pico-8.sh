#!/bin/bash
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Fewtarius

# Source predefined functions and variables
. /etc/profile

if [ ! -z "${1}" ]
then
  RUN="-run ${1}"
else
  RUN="-splore"
fi

if [ ! -d "/storage/roms/gamedata/pico-8" ]
then
  mkdir -p "/storage/roms/gamedata/pico-8"
  echo "Extract your purchased pico-8 binaries and place them in gamedata/pico-8 on your games partition" >/tmp/logs/emuelec.log
fi

cp /usr/config/SDL-GameControllerDB/gamecontrollerdb.txt /storage/roms/gamedata/pico-8/sdl_controllers.txt

unset MYARCH
TEST=$(ldd /usr/bin/emulationstation | grep 64)
if [ $? == 0 ]
then
  patchelf --set-interpreter /usr/lib32/ld-linux-armhf.so.3 /storage/roms/gamedata/pico-8/pico8_dyn
  export LD_LIBRARY_PATH=/usr/lib32
fi

/storage/roms/gamedata/pico-8/pico8_dyn -home -root_path /storage/gamedata/pico-8 -joystick 0 ${RUN}

ret_error=$?

exit $ret_error
