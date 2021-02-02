#!/usr/bin/bash
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Fewtarius

. /etc/profile
source /storage/.config/distribution/scriptmodules/helpers.sh

MEDITATION=$(echo $* | md5sum | awk '{print $1}')
MEDITATION=${MEDITATION^^}

ERROR="
\e[31m
###########################################################
# Software Failure. Check Log Files for more information. #
#           Guru Meditation #${MEDITATION:0:17}            #
###########################################################
\e[39m

"

clear >/dev/console
message_stream "${ERROR}" 0
if [ -n "$1" ]
then
  message_stream "$*" 0
else
  tail -n 15 /tmp/logs/es_launch_stderr.log >/dev/console
fi

sleep 10
clear >/dev/console
