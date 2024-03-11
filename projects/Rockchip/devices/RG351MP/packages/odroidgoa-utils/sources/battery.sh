#!/bin/bash
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Fewtarius

# Simple script to watc the battery capacity and
# turn the power LED red when it reaches 25%

# Search for files containing "led" in their name
if ls "/roms"/*led* >/dev/null 2>&1; then
  r3xs_green="red"
  r3xs_red="green"
  r3xs_yellow="purple"
fi

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
    purple)
      echo out >/sys/class/gpio/gpio77/direction
      echo 0 >/sys/class/gpio/gpio77/value
      echo 1 >/sys/class/gpio/gpio77/value
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
        set_led "${r3xs_yellow:-yellow}"
        sleep .5
        set_led "${r3xs_red:-red}"
        sleep .5
      done
      continue
    elif (( ${CAP} <= 20 ))
    then
      set_led "${r3xs_red:-red}"
    elif (( ${CAP} <= 30 ))
    then
      set_led "${r3xs_yellow:-yellow}"
    else
      set_led "${r3xs_green:-green}"
    fi
  elif (( ${CAP} >= 95 ))
  then
    set_led "${r3xs_green:-green}"
  fi
  sleep 15
done
