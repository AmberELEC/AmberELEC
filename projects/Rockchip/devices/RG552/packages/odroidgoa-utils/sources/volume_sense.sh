#!/bin/bash
set -e
set -o pipefail

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Fewtarius
#               2021-present pkegg

### Summary
#   This script listens to volume keys on the RG552 and adjusts volume
#   Fn + Volume up/down will adjust brightness
###


# Event examples for reference
# type 1 (EV_KEY), code 114 (KEY_VOLUMEDOWN), value 1
# type 1 (EV_KEY), code 115 (KEY_VOLUMEUP), value 1


RG351_DEVICE='/dev/input/by-path/platform-volume-keys-event'  # Device for volume key events

RG351_CONTROLLER_DEVICE='/dev/input/by-path/platform-odroidgo3-joypad-event-joystick' # Joystick events (for Fn key)

VOL_EVENT='*(KEY_VOLUME*, value *' # This matches all volume events

VOL_UP='*UP), value *'  # Differentiate 'up' volume event
VOL_DOWN='*DOWN), value *' #Differentiate 'down' volume event

V_FUNC_KEY_EVENT='*(BTN_TRIGGER_HAPPY4), value *' # Matches all RG552 Fn key events

# Matches if a button was pressed (1), released (0) or held down (2)
PRESS='*value 1'
RELEASE='*value 0'
REPEAT_PRESS="* value 2"

# Volume repeat
VOLUME_REPEAT_MOD=5

# Brightness repeat
BRIGHTNESS_REPEAT_MOD=5

# Variable to keep track of Fn being currently pressed
FUNC_PRESSED=no

CONTROLLER_DISCONNECTED="*error reading: No such device"

# Logic:
#  - Listen to both:
#    - 'rg351' events to get volume keys (not part of the joystick api)
#    - 'joystick' events - as the V's 'fn' key is mapped to the joystick
#  - Switch statement keeps high level cases to only 'volume' and 'V function key'
#      this is to avoid processing for other events or creating a lot of cases as this will be called
#      for all button pushes
#  - Using 'read' means the loop is idle when no button is pressed

# Wait for controller in case of restart, etc
while true; do
sleep 1
if [[ ! -e "${RG351_CONTROLLER_DEVICE}" ]]; then
  continue
else
  break
fi

done
(  
   evtest "${RG351_DEVICE}" &
   evtest "${RG351_CONTROLLER_DEVICE}" 2>&1 &
   wait 
) | while read line; do
    case $line in
        (${CONTROLLER_DISCONNECTED})
        echo "Reloading due to controller reattach..."
        exit 0
        ;;
        (${VOL_EVENT})

          # We don't care when you 'let go' ('release') the volume button
          if [[ "$line" == ${RELEASE} ]]; then
             REPEAT_NUM=0
             continue
          fi

          # Setup for 'brightness' if Fn pressed
          if [[ "${FUNC_PRESSED}" == "yes" ]]; then
            COMMAND=/usr/bin/brightness
            UP="up"
            DOWN="down"
            REPEAT_MOD=${BRIGHTNESS_REPEAT_MOD}
          # Default to 'volume' if Fn is not pressed
          else
            COMMAND="/usr/bin/odroidgoa_utils.sh vol"
            UP="+"
            DOWN="-"
            REPEAT_MOD=${VOLUME_REPEAT_MOD}
          fi
          
          REPEAT_NUM=$(( ${REPEAT_NUM} + 1 ))

          # This isn't time to evaluate repeat so just skip
          if [[ "$line" == ${REPEAT_PRESS} && $(( ${REPEAT_NUM} % ${REPEAT_MOD} )) != "0" ]]; then
             continue
          fi

          INCREMENT_AMOUNT=1
          if [[ "${REPEAT_NUM}" -gt "75" ]]; then
             INCREMENT_AMOUNT=5
          elif [[ "${REPEAT_NUM}" -gt "25" ]]; then
             INCREMENT_AMOUNT=2
          fi   
          # Run the commands to adjust volume/brightness
          if [[ "${line}" == ${VOL_UP} ]]; then
            ${COMMAND} ${UP} ${INCREMENT_AMOUNT} > /dev/null
          elif [[ "${line}" == ${VOL_DOWN} ]]; then
            ${COMMAND} ${DOWN} ${INCREMENT_AMOUNT} > /dev/null
          fi
        ;;

        (${V_FUNC_KEY_EVENT}) 

          # We don't care about 'Fn' key repeats - continue
          if [[ "$line" == ${REPEAT_PRESS} ]]; then
             continue
          fi

          #Reset the number of repeats when Fn is pressed/release
          #  as repeat speed is different between volume/brightness
          REPEAT_NUM=0

          if [[ "${line}" == ${PRESS} ]]; then
            FUNC_PRESSED=yes
          elif [[ "${line}" == ${RELEASE} ]]; then
            FUNC_PRESSED=no
          fi
        ;;
    esac
done
