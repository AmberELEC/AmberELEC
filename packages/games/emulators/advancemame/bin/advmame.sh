#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present AmberELEC (https://github.com/AmberELEC)

. /etc/profile

CONFIG_DIR="/storage/.advance"

if [ ! -d "$CONFIG_DIR" ]; then
 mkdir -p $CONFIG_DIR
 cp -rf /usr/share/advance/* $CONFIG_DIR/
fi

if [ ! -f "$CONFIG_DIR/advmame.rc" ]; then
 cp -rf /usr/share/advance/advmame.rc $CONFIG_DIR/
fi

if [[ "$1" = *"roms/arcade"* ]]; then
 sed -i "s|/roms/mame|/roms/arcade|g" $CONFIG_DIR/advmame.rc
else
 sed -i "s|/roms/arcade|/roms/mame|g" $CONFIG_DIR/advmame.rc
fi

sed -i '/device_video_modeline/d' $CONFIG_DIR/advmame.rc

ARG=$(echo basename $1 | sed 's/\.[^.]*$//')
ARG="$(echo $1 | sed 's=.*/==;s/\.[^.]*$//')"

/usr/bin/advmame $ARG
