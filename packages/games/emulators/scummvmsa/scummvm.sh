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

if [[ ! -f "${CONFIG_DIR}/.scummvm_20220412" ]]; then
  rm -rf ${CONFIG_DIR}
fi

create_svm(){
  /usr/bin/scummvm --list-targets | tail -n +4 | cut -d " " -f 1 | \
  while read line
  do
    id=($line);
    filename=$(grep -A7 "\[$id\]" ${CONFIG_DIR}/scummvm.ini | \
      awk 'BEGIN {FS="="}; /description/ {printf $2}' | \
      sed -e 's# (.*)# ('${id}')#g' -e "s#'##g" -e "s#: # - #g" \
    )
    # there's a very specific set of circumstances where the above
    # regex will return an empty string with no game. This stops it
    # from creating an empty .scummvm file
    if [[ -z "$filename" ]]; then
      continue
    fi
    SVMPATH="$(grep -A7 "\[$id\]" ${CONFIG_DIR}/scummvm.ini | awk 'BEGIN {FS="="}; /path/ {print $2}')"
    echo '--path="'${SVMPATH}'" '${id} >"${ROMSPATH}/${filename}.scummvm"
  done
}

if [ ! -d "${CONFIG_DIR}" ]; then
 mkdir -p ${CONFIG_DIR}
 cp -rf /usr/config/scummvm/* ${CONFIG_DIR}/
 touch ${CONFIG_DIR}/.scummvm_20220412
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
    GAME=$(cat "${GAME}" | awk 'BEGIN {FS="\""}; {print $2}')
    cd "${GAME}"
    /usr/bin/retroarch -L /tmp/cores/scummvm_libretro.so --config ${RATMPCONF} .
  ;;

  "add")
    /usr/bin/scummvm --add --path="${ROMSPATH}" --recursive
    mkdir -p ${BIOSPATH}
    cp ${CONFIG_DIR}/scummvm.ini ${BIOSPATH}/scummvm.ini
  ;;

  "create")
    create_svm
  ;;

esac
