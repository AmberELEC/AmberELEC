#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Fewtarius

source /usr/bin/env.sh
source /etc/profile

jslisten set "killall PPSSPPSDL"

cp -rf /storage/.config/SDL-GameControllerDB/gamecontrollerdb.txt /storage/roms/gamedata/ppsspp/assets/gamecontrollerdb.txt

/usr/bin/PPSSPPSDL
