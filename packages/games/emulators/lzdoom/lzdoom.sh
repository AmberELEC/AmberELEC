#!/usr/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present 351ELEC (https://github.com/351ELEC/351ELEC)

. /etc/profile

EE_DEVICE=$(cat /storage/.config/.OS_ARCH)
RUN_DIR="/storage/roms/doom"
CONFIG="/storage/.config/distribution/lzdoom/lzdoom.ini"
SAVE_DIR="/storage/roms/gamedata/lzdoom"

if [ ! -L "/storage/.config/lzdoom" ]
then
  ln -sf "/storage/.config/distribution/lzdoom" "/storage/.config/lzdoom"
fi

if [ ! -f "/storage/.config/distribution/lzdoom/lzdoom.ini" ]
then
  cp -rf /usr/config/distribution/lzdoom/lzdoom.ini /storage/.config/distribution/lzdoom/
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
  params+=" -width 360 -height 240 +vid_fps 1 +cl_capfps 0 +vid_renderer 0 +vid_glswfb 0"
fi
if [[ "$EE_DEVICE" == RG351V ]] || [[ "$EE_DEVICE" == RG351MP ]]; then
  params+=" -width 320 -height 240 +vid_fps 1 +cl_capfps 0 +vid_renderer 0 +vid_glswfb 0"
fi

cd "${RUN_DIR}"
LD_PRELOAD=/usr/lib/libSDL2-2.0.so.0.14.0 /usr/bin/lzdoom ${params} >/tmp/logs/lzdoom.log 2>&1
