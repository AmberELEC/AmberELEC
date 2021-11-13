#!/usr/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present 351ELEC (https://github.com/351ELEC)

. /etc/profile

EE_DEVICE=$(cat /storage/.config/.OS_ARCH)
RUN_DIR="/storage/roms/build"
CONFIG="/storage/.config/distribution/raze/raze.ini"
SAVE_DIR="/storage/roms/gamedata/raze"

if [ ! -L "/storage/.config/raze" ]
then
  ln -sf "/storage/.config/distribution/raze" "/storage/.config/raze"
fi

if [ ! -f "/storage/.config/distribution/raze/raze.ini" ]
then
  cp -rf /usr/config/distribution/raze/raze.ini /storage/.config/distribution/raze/
fi

mkdir -p ${SAVE_DIR}

params=" -config ${CONFIG} -savedir ${SAVE_DIR}"
params+=" +gl_es 1 +vid_preferbackend 3 +cl_capfps 0 +cl_nomeleeblur 1 +vid_fps 1"

EXT=${1#*.}

if [ ${EXT} == "build" ]; then
  dos2unix "${1}"
  while IFS== read -r key value; do
    if [ "$key" == "PATH" ]; then
      RUN_DIR+="/$value"
    fi
    if [ "$key" == "GRP" ]; then
      params+=" -gamegrp $value"
    fi
    done < "${1}"
fi

if [[ ! "RUN_DIR" == "/storage/roms/build" ]]; then
  cd "${RUN_DIR}"
  LD_PRELOAD=/usr/lib/libSDL2-2.0.so.0.14.0 /usr/bin/raze ${params} >/tmp/logs/raze.log 2>&1
fi
