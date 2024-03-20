#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024-present AmberELEC (https://github.com/AmberELEC)

. /etc/profile

DEVICE=$(cat /sys/firmware/devicetree/base/model)

if [ "$DEVICE" == "Anbernic RG351V" ] || [ "$DEVICE" == "Anbernic RG351MP" ] || [ "$DEVICE" == "PowKiddy Magicx XU10" ]; then
  magick /usr/config/splash/splash-640.png bgra:/dev/fb0
elif [ "$DEVICE" == "Anbernic RG552" ]; then
  ply-image /usr/config/splash/splash-1920.png
else
  magick /usr/config/splash/splash-480.png bgra:/dev/fb0
fi
