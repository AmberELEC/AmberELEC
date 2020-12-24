#!/bin/bash
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Fewtarius

# Simple script to watc the battery capacity and
# turn the power LED red when it reaches 25%

function set_led() {
  case $1 in
    red)
      echo out >/sys/class/gpio/gpio77/direction
      echo 1 >/sys/class/gpio/gpio77/value
    ;;
    green)
      echo out >/sys/class/gpio/gpio77/direction
      echo 0 >/sys/class/gpio/gpio77/value
    ;;
    yellow)
      echo in >/sys/class/gpio/gpio77/direction
    ;;
  esac
}


while true
do
  CAP=$(cat /sys/class/power_supply/battery/capacity)
  STAT=$(cat /sys/class/power_supply/battery/status)
  if [ ${STAT} == "Discharging" ]
  then
    if (( ${CAP} <= 10 ))
    then
      for ctr in $(seq 1 1 5)
      do
        set_led yellow
        sleep .5
        set_led red
        sleep .5
      done
      continue
    elif (( ${CAP} <= 20 ))
    then
      set_led red
    elif (( ${CAP} <= 30 ))
    then
      set_led yellow
    else
      set_led green
    fi
  elif (( ${CAP} >= 95 ))
  then
    set_led green
  fi
  sleep 15
done
