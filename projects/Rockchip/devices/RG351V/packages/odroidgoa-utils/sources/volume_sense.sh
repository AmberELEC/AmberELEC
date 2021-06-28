
#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Fewtarius

# Source predefined functions and variables
. /etc/profile

RG351_DEVICE='/dev/input/by-path/platform-rg351-keys-event'
RG351_CONTROLLER_DEVICE='/dev/input/event3'

# type 1 (EV_KEY), code 114 (KEY_VOLUMEDOWN), value 1
# type 1 (EV_KEY), code 115 (KEY_VOLUMEUP), value 1

VOL='*(KEY_VOLUME*, value *'
VOL_UP='*UP), value *'
VOL_DOWN='*DOWN), value *'
V_FUNC='*(BTN_TR2), value *'
L3_FUNC='*(BTN_TL2), value *'
PRESS='*value 1'
RELEASE='*value 0'
REPEAT_PRESS="* value 2"
FUNC_PRESSED=no


(  evtest "${RG351_DEVICE}" &
   evtest "${RG351_CONTROLLER_DEVICE}" &
   wait 
) | while read line; do
    #echo "$line"
    case $line in
        (${VOL})
          COMMAND="/usr/bin/odroidgoa_utils.sh vol"
          UP="+"
          DOWN="-"
          REPEAT_MOD=5
       
          REPEAT_NUM=$(( ${REPEAT_NUM} + 1 ))
          #echo "REPEAT NUM: ${REPEAT_NUM}"
          if [[ "${FUNC_PRESSED}" == "yes" ]]; then
            COMMAND=./brightness
            UP="up"
            DOWN="down"
            REPEAT_MOD=2
          fi    
          if [[ "$line" == ${REPEAT_PRESS} && $(( ${REPEAT_NUM} % ${REPEAT_MOD} )) != "0" ]]; then
             continue
          fi
          if [[ "${line}" == ${VOL_UP} ]]; then
            ${COMMAND} ${UP}
          elif [[ "${line}" == ${VOL_DOWN} ]]; then
            ${COMMAND} ${DOWN}
          fi
        ;;
        (${V_FUNC} | ${L3_FUNC})
          #echo "$line"
          if [[ "$line" == ${REPEAT_PRESS} ]]; then
             continue
          fi
        #echo "func"
          REPEAT_NUM=0
          if [[ "${line}" == ${PRESS} ]]; then
            #echo "pressed"
            FUNC_PRESSED=yes
          elif [[ "${line}" == ${RELEASE} ]]; then
            #echo "released"
            FUNC_PRESSED=no
          #else
            #echo "line: '${line}'"
          fi
        ;;
    esac
done
