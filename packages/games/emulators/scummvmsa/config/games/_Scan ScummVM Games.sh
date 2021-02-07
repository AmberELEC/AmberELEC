#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2020-present Fewtarius

EE_DEVICE=$(cat /ee_arch)

source /usr/bin/env.sh
. /etc/profile

rp_registerAllModules

joy2keyStart
ear >/dev/console
message_stream "Scanning for games...\n" 0
bash /usr/bin/scummvm.start add
message_stream "Adding games...\n" 0
bash /usr/bin/scummvm.start create
message_stream "Restarting EmulationStation...\n" 0
systemctl restart emustation
clear >/dev/console
