#!/bin/bash
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Fewtarius

# Simple script to watc the battery capacity and
# turn the power LED red when it reaches 25%

while true
do
  CAP=$(cat /sys/class/power_supply/battery/capacity)
  if (( ${CAP} <= 25 ))
  then
    echo 1 >/sys/class/gpio/gpio77/value
  fi
  sleep 30
done

