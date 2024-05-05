#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024-present tech4bot (https://github.com/tech4bot)
# Copyright (C) 2024-present AmberELEC (https://github.com/AmberELEC)
#
# Led light icons from <a href="https://www.flaticon.com/free-icons/led-light"
# title="led-light_6348035">Led light icons created by Freepik - Flaticon</a>


export SDL_GAMECONTROLLERCONFIG_FILE="/storage/.config/SDL-GameControllerDB/gamecontrollerdb.txt"
source /usr/bin/env.sh
export TERM=xterm-color
export DIALOGRC=/etc/amberelec.dialogrc
echo -e '\033[?25h\033[?16;224;238c' > /dev/console
clear > /dev/console

gptokeyb joyleds.sh -c /usr/config/gptokeyb/settime.gptk &

userQuit() {
 kill -9 $(pidof gptokeyb)
 echo -e '\033[?25l' > /dev/console
 clear > /dev/console
 exit 0
}

MainMenu() {
 local dialog_options=( 1 "Always ON" 2 "Always OFF" 3 "Joysticks Movement" 4 "Quit" )

 while true; do
  show_dialog=(dialog \
  --title " Main menu " \
  --clear \
  --no-cancel \
  --menu "Please select the configuration for your Joysticks LEDs." 0 0 1)

  choices=$("${show_dialog[@]}" "${dialog_options[@]}" 2>&1 > /dev/console) || userQuit

  for choice in $choices; do
    case $choice in
    1) JoyOn ;;
    2) JoyOff ;;
    3) JoyMov ;;
    4) userQuit ;;
   esac
  done
 done
}

JoyOn() {
  echo 1 > /storage/.config/joyleds.cfg
  systemctl restart joyled
  userQuit
}

JoyOff() {
  echo 2 > /storage/.config/joyleds.cfg
  echo 0 > /sys/class/leds/left_joystick/brightness
  echo 0 > /sys/class/leds/right_joystick/brightness
  systemctl restart joyled
  userQuit
}

JoyMov() {
  echo 0 > /storage/.config/joyleds.cfg
  echo 0 > /sys/class/leds/left_joystick/brightness
  echo 0 > /sys/class/leds/right_joystick/brightness
  systemctl restart joyled
  userQuit
}

MainMenu
userQuit