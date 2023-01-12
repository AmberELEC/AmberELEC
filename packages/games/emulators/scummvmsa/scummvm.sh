#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

# Source predefined functions and variables
. /etc/profile

CONFIG_DIR="/storage/.config/scummvm"
ROMSPATH="/storage/roms/scummvm"
BIOSPATH="/storage/roms/bios"
GAME=$2
RATMPCONF="/storage/.config/retroarch/retroarch.cfg"
RA_APPEND_CONF="/tmp/raappend.cfg"

if [[ ! -f "${CONFIG_DIR}/.scummvm_20220519" ]]; then
  rm -rf ${CONFIG_DIR}
  rm -rf ${BIOSPATH}/scummvm.ini
fi

if [ ! -d "${CONFIG_DIR}" ]; then
 mkdir -p ${CONFIG_DIR}
 cp -rf /usr/config/scummvm/* ${CONFIG_DIR}/
 touch ${CONFIG_DIR}/.scummvm_20220519
fi

case $1 in
  "sa")
    GAME=$(cat "${GAME}")
    eval /usr/bin/scummvm --fullscreen --joystick=0 ${GAME}
  ;;

  "libretro")
    if [[ ! -f "${BIOSPATH}/scummvm.ini" ]]; then
      cp ${CONFIG_DIR}/scummvm.ini ${BIOSPATH}/scummvm.ini
    fi
    sed -i 's/themepath=.*//g' ${BIOSPATH}/scummvm.ini
    sed -i 's/extrapath=.*//g' ${BIOSPATH}/scummvm.ini
    sed -i 's/browser_lastpath=.*//g' ${BIOSPATH}/scummvm.ini
    sed -i 's/guitheme=.*//g' ${BIOSPATH}/scummvm.ini
    sed -i '2,2s/^/themepath=\/roms\/bios\/scummvm\/theme\n/' ${BIOSPATH}/scummvm.ini
    sed -i '2,2s/^/extrapath=\/roms\/bios\/scummvm\/extra\n/' ${BIOSPATH}/scummvm.ini
    sed -i '2,2s/^/browser_lastpath=\/roms\/bios\/scummvm\/extra\n/' ${BIOSPATH}/scummvm.ini
    sed -i '2,2s/^/guitheme=scummremastered\n/' ${BIOSPATH}/scummvm.ini
    GAME=$(cat "${GAME}" | awk 'BEGIN {FS="\""}; {print $2}')
    cd "${GAME}"
    /usr/bin/retroarch -L /tmp/cores/scummvm_libretro.so --config ${RATMPCONF} --appendconfig ${RA_APPEND_CONF} .
  ;;

esac

