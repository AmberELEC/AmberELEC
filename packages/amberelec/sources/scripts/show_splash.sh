#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024-present AmberELEC (https://github.com/AmberELEC)

. /etc/profile

DEVICE=$(tr -d '\0' < /sys/firmware/devicetree/base/model)

if [ "$DEVICE" == "Anbernic RG351P" ]; then
  magick /usr/config/splash/splash-480.png bgra:/dev/fb0
elif [ "$DEVICE" == "Anbernic RG552" ]; then
  ply-image /usr/config/splash/splash-1920.png
else
  magick /usr/config/splash/splash-640.png bgra:/dev/fb0
fi

if [ ${1} == "autosave" ]; then
echo -en '\e[0;0H\e[37mAutosaving running game and shutting down the device...\e[0m' >/dev/console
