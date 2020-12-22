#!/bin/bash
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Fewtarius

# Simple script to watc the battery capacity and
# turn the power LED red when it reaches 25%

while true
do
  CAP=$(cat /sys/class/power_supply/battery/capacity)
  STAT=$(cat /sys/class/power_supply/battery/status)
  if [ "${STAT}" == "Discharging" ]
  then
    echo out >/sys/class/gpio/gpio77/direction
  else
    echo in >/sys/class/gpio/gpio77/direction
  fi
  if (( ${CAP} <= 25 ))
  then
    echo 1 >/sys/class/gpio/gpio77/value
  else
    echo 0 >/sys/class/gpio/gpio77/value
  fi
  sleep 30
done

