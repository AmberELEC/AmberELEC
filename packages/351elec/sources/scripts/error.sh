# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Fewtarius

. /etc/profile
source /emuelec/scriptmodules/helpers.sh

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
  message_stream "\n\e[31mERROR: $1\n" 0
  message_stream "DETAIL:\n$2" 0
  cat <<EOF > /tmp/logs/error.log
$1
$2
EOF
  sleep 5
fi
sleep 3
clear >/dev/console
