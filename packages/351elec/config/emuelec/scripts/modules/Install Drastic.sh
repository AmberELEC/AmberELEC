#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2020-present Fewtarius

source /emuelec/scripts/env.sh
source /etc/profile

message_stream "Installing Drastic..." .02
/usr/config/emulationstation/scripts/drastic/dldrastic.sh
if [ $? == 0 ]
then
  message_stream "Restarting EmulationStation" .02
  systemctl restart emustation.service
else
  message_stream "Unable to install.  Make sure you are connected to WIFI." 0.2
  sleep 3
fi
clear >/dev/console
