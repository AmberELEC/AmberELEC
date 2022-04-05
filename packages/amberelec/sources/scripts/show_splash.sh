#!/bin/sh

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present SumavisionQ5 (https://github.com/SumavisionQ5)
# Modifications by Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2020-present Fewtarius

. /etc/profile


ROMNAME="$1"

vres="$(fbset 2>/dev/null | awk '/geometry/ { print $3 }')"
hres="$(fbset 2>/dev/null | awk '/geometry/ { print $2 }')"

if [ "$ROMNAME" == "shutdown" ]
then
  if [ "${hres}" = "640" ]
  then
    cols="29"
    rows="13"
  else
    cols="26"
    rows="12"
  fi
  clear >/dev/console
  echo -ne "\033[${rows};${cols}H" >/dev/console
  message_stream "GAME OVER" .05
  sleep .5
  exit 0
fi

if [ "$ROMNAME" == "intro" ] || [ "$ROMNAME" == "exit" ]
then
  if [[ "$(cat /usr/config/.OS_ARCH)" =~ RG351 ]]
  then
    if [ "$(cat /sys/firmware/devicetree/base/model)" == "Anbernic RG351V" ] || [ "$(cat /sys/firmware/devicetree/base/model)" == "Anbernic RG351MP" ]; then
      SPLASH="/usr/config/splash/splash-640.png"
    if [ "$(cat /sys/firmware/devicetree/base/model)" == "Anbernic RG552" ]; then
      SPLASH="/usr/config/splash/splash-1920l.png"
    else
      SPLASH="/usr/config/splash/splash-480l.png"
    fi
  else
    SPLASH="/usr/config/splash/splash-1080.png"
  fi
else
  if [ "$(get_ee_setting ee_splash.enabled)" == "0" ]
  then
    exit 0
  fi
  if [ "${hres}" = "640" ]
  then
    cols="12"
  else
    cols="10"
  fi
  MYGAME=${ROMNAME^^}
  MYBOOT="

\e[1;${cols}H ########## WELCOME TO \e[31m351\e[39mELEC ##########
\e[2;${cols}H  $(awk '/MemTotal/ {printf substr($2,1,3)}' /proc/meminfo)M BYTES AVAILABLE   $(awk '/MemFree/ {printf substr($2,1,3)}' /proc/meminfo)M BYTES FREE

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
  echo -ne "${MYBOOT}" > /dev/console
  spinny_cursor "STARTING UP... " 15
  message_stream "${MYREADY}" .02
  message_stream "${MYSTART}" .02
  message_stream "${MYLOADING}" .02
  message_stream "RUN" .05
  exit 0
fi

[[ "${PLATFORM}" != "intro" ]] && VIDEO=0 || VIDEO=$(get_ee_setting ee_bootvideo.enabled)

if [[ -f "/storage/.config/distribution/configs/novideo" ]] && [[ ${VIDEO} != "1" ]]
then
        if [ "$PLATFORM" != "intro" ]; then
                /usr/bin/mpv "${SPLASH}" > /dev/null 2>&1 &
        fi
else
	# Show intro video
        SPLASH=${VIDEOSPLASH}
        set_audio alsa
        /usr/bin/mpv "$SPLASH" > /dev/null 2>&1
        touch "/storage/.config/distribution/configs/novideo"
fi

# Wait for the time specified in ee_splash_delay setting in distribution.conf
SPLASHTIME=$(get_ee_setting ee_splash.delay)
[ ! -z "$SPLASHTIME" ] && sleep $SPLASHTIME
