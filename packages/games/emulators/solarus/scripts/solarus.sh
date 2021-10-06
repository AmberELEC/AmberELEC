#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Shanti Gilbert (https://github.com/shantigilbert)

[[ ! -d "/storage/roms/gamedata/solarus/" ]] && mkdir -p "/storage/roms/gamedata/solarus/"

DEVICE=$(cat /storage/.config/.OS_ARCH)

if [[ "$DEVICE" == RG351MP ]]; then
  solarus-run -fullscreen=yes -joypad-deadzone=32767 -quit-combo=12+13 "${1}"
else
  solarus-run -fullscreen=yes -joypad-deadzone=32767 -quit-combo=7+6 "${1}"
fi

exit 0
