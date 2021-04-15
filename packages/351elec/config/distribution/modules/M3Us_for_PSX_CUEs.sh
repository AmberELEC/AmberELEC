#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2020-present Fewtarius

. /etc/profile
source /usr/bin/env.sh
clear >/dev/console
systemctl stop emustation
message_stream "Making M3U's each PSX CUE and CCD file."
cd /storage/roms/psx/
for i in *.cue
do
        title=$(echo "$i" | sed s'/.cue//g;s/ (Disc..)//g;s/ Disc..*$//g;s/ (.*//g')

        echo "$i" >> "$title".m3u
done
for i in *.ccd
do
        title=$(echo "$i" | sed s'/.ccd//g;s/ (Disc..)//g;s/ Disc..*$//g;s/ (.*//g')

        echo "$i" >> "$title".m3u
done
clear >/dev/console
systemctl start emustation
