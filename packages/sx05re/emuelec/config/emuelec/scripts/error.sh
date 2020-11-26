#!/usr/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Fewtarius

. /etc/profile
source /emuelec/scriptmodules/helpers.sh

message_stream () {
  local MESSAGE=$1
  local DELAY=$2
  LOADBUFFER=0
  for (( i=0; i<${#MESSAGE}; i++ ))
  do
    CHAR="${MESSAGE:$i:1}"
    if [ "${CHAR}" == "m" ] && [ "${LOADBUFFER}" -eq 1 ]
    then
      echo -ne "${BUFFER}${CHAR}" >/dev/console
      unset BUFFER
      LOADBUFFER=0
    elif [ "${CHAR}" == "\\" ] || [ "${LOADBUFFER}" -eq 1 ]
    then
      BUFFER="$BUFFER${CHAR}"
      LOADBUFFER=1
    else
      echo -n "${CHAR}" >/dev/console
    fi
    sleep $DELAY
  done
}

MEDITATION=$(echo $* | md5sum | awk '{print $1}')
ERROR="
\e[31m
###########################################################
# Software Failure. Check Log Files for more information. #
#           Guru Meditation #${MEDITATION:0:17}            #
###########################################################
\e[39m"
clear >/dev/console
message_stream "${ERROR}" 0
sleep 4
