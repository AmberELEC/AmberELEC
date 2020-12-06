#!/bin/sh

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

export SDL_AUDIODRIVER=alsa          
nice -n -19 /usr/bin/stella "${1}"
