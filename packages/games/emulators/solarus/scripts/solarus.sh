#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Shanti Gilbert (https://github.com/shantigilbert)

[[ ! -d "/storage/roms/gamedata/solarus/" ]] && mkdir -p "/storage/roms/gamedata/solarus/"
solarus-run -fullscreen=yes -joypad-deadzone=32767 -quit-combo=6+7 ${1}

exit 0
