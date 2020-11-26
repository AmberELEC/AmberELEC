#!/bin/sh

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present SumavisionQ5 (https://github.com/SumavisionQ5)
# Modifications by Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2020-present Fewtarius

. /etc/profile


ROMNAME="$1"

if [ "$ROMNAME" == "intro" ] || [ "$ROMNAME" == "exit" ]; then
        SPLASH="/storage/.config/splash/splash-1080.png"
else

  MYGAME=${ROMNAME^^}
  MYBOOT="

        ### WELCOME TO \e[31m351\e[39mELEC - VERSION $(cat /storage/.config/EE_VERSION) ###
        1024000 BYTE RAM SYSTEM  $(awk '/MemFree/ {printf $2}' /proc/meminfo) BYTES FREE

"

  MYREADY="
READY."

  MYSTART="
LOAD \"${ROMNAME##*/}\""

  MYLOADING="

LOADING ${MYGAME##*/}
READY.
"
  clear >/dev/console;
  message_stream "${MYBOOT}" 0
  spinny_cursor "STARTING UP... " 6
  message_stream "${MYREADY}" 0
  message_stream "${MYSTART}" .02
  message_stream "${MYLOADING}" 0
  message_stream "RUN" .05
  exit 0
fi

MODE=`cat /sys/class/display/mode`;
case "$MODE" in
                480*)
                        SIZE=" -x 800 -y 480 "
                ;;
                576*)
                        SIZE=" -x 768 -y 576"
                ;;
                720*)
                        SIZE=" -x 1280 -y 720 "
                ;;
                *)
                        SIZE=" -x 1920 -y 1080"
                ;;
esac

[[ "${PLATFORM}" != "intro" ]] && VIDEO=0 || VIDEO=$(get_ee_setting ee_bootvideo.enabled)

if [[ -f "/storage/.config/emuelec/configs/novideo" ]] && [[ ${VIDEO} != "1" ]]; then
        if [ "$PLATFORM" != "intro" ]; then
                ffplay -fs -autoexit ${SIZE} "${SPLASH}" > /dev/null 2>&1
        fi
else
# Show intro video
        SPLASH=${VIDEOSPLASH}
        set_audio alsa
        #[ -e /storage/.config/asound.conf ] && mv /storage/.config/asound.conf /storage/.config/asound.confs
        ffplay -fs -autoexit ${SIZE} "$SPLASH" > /dev/null 2>&1
        touch "/storage/.config/emuelec/configs/novideo"
        #[ -e /storage/.config/asound.confs ] && mv /storage/.config/asound.confs /storage/.config/asound.conf
fi

# Wait for the time specified in ee_splash_delay setting in emuelec.conf
SPLASHTIME=$(get_ee_setting ee_splash.delay)
[ ! -z "$SPLASHTIME" ] && sleep $SPLASHTIME
