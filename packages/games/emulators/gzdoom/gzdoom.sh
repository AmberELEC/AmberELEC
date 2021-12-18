#!/usr/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present 351ELEC (https://github.com/351ELEC)

. /etc/profile

EE_DEVICE=$(cat /storage/.config/.OS_ARCH)
RUN_DIR="/storage/roms/doom"
CONFIG="/storage/.config/distribution/gzdoom/gzdoom.ini"
SAVE_DIR="/storage/roms/gamedata/gzdoom"

if [ ! -L "/storage/.config/gzdoom" ]
then
  ln -sf "/storage/.config/distribution/gzdoom" "/storage/.config/gzdoom"
fi

if [ ! -f "/storage/.config/distribution/gzdoom/gzdoom.ini" ]
then
  cp -rf /usr/config/distribution/gzdoom/gzdoom.ini /storage/.config/distribution/gzdoom/
fi

mkdir -p ${SAVE_DIR}

params=" -config ${CONFIG} -savedir ${SAVE_DIR}"

# EXT can be wad, WAD, iwad, IWAD, pwad, PWAD or doom
EXT=${1#*.}

# If its not a simple wad (extension .doom) read the file and parse the data
if [ ${EXT} == "doom" ]; then
  dos2unix "${1}"
  while IFS== read -r key value; do
    if [ "$key" == "IWAD" ]; then
      params+=" -iwad $value"
    fi
    if [ "$key" == "MOD" ]; then
      params+=" -file $value"
    fi
    done < "${1}"
else
  params+=" -iwad ${1}"
fi

if [[ "$EE_DEVICE" == RG351P ]]; then
  params+=" +gl_es 1 +vid_preferbackend 3 +cl_capfps 0 +vid_fps 1"
fi
if [[ "$EE_DEVICE" == RG351V ]] || [[ "$EE_DEVICE" == RG351MP ]]; then
  params+=" +gl_es 1 +vid_preferbackend 3 +cl_capfps 0 +vid_fps 1"
fi

cd "${RUN_DIR}"
LD_PRELOAD=/usr/lib/libSDL2-2.0.so.0.14.0 /usr/bin/gzdoom ${params} >/tmp/logs/gzdoom.log 2>&1
