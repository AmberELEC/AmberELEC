#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present AmberELEC (https://github.com/AmberELEC)

. /etc/profile

ROM="${1##*/}"
PLATFORM="build"
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

# Show FPS
get_setting "show_fps"
if [ "${EES}" == "auto" ] || [ "${EES}" == "disabled" ] || [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
        SHOWFPS='0'
else
        SHOWFPS='1'
fi

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
params+=" +gl_es 1 +vid_preferbackend 2 +cl_capfps 0 +cl_nomeleeblur 1 +vid_fps $SHOWFPS"

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
  /usr/bin/raze ${params} >/tmp/logs/raze.log 2>&1
fi
