#!/bin/sh

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

cp -f /usr/config/SDL-GameControllerDB/gamecontrollerdb.txt /storage/.config/SDL-GameControllerDB/gamecontrollerdb.txt

ARG=${1//[\\]/}
export SDL_AUDIODRIVER=alsa          
nice -n -19 PPSSPPSDL --fullscreen "$ARG"
