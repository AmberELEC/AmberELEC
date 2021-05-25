#!/usr/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2021-present 351ELEC (https://github.com/351ELEC/351ELEC)

. /etc/profile

EE_DEVICE=$(cat /storage/.config/.OS_ARCH)
RUN_DIR="/storage/roms/doom"
CONFIG="/storage/.config/distribution/lzdoom/lzdoom.ini"
SAVE_DIR="/storage/roms/gamedata/lzdoom"

mkdir -p ${SAVE_DIR}

params=" -config ${CONFIG} -savedir ${SAVE_DIR}"

if [[ "$EE_DEVICE" == RG351P ]]; then
  params+=" -width 480 -height 320"
fi
if [[ "$EE_DEVICE" == RG351V ]]; then
  params+=" -width 640 -height 480"
fi

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

cd "${RUN_DIR}"
/usr/bin/lzdoom ${params} >/tmp/logs/lzdoom.log 2>&1