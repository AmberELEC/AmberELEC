#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2020-present Fewtarius

. /etc/profile
source /usr/bin/env.sh
clear >/dev/console
systemctl stop emustation
message_stream "Making M3U's and setting as default file extension for PSX"
cd /storage/roms/psx/
# Making m3u files for cue's
for i in *.cue
do
        title=$(echo "$i" | sed s'/.cue//g;s/ (Disc..)//g;s/ Disc..*$//g;s/ (.*//g')

        echo "$i" >> "$title".m3u
done
cd /storage/roms/psx/
# Making m3u files for chd's
for i in *.chd
do
        title=$(echo "$i" | sed s'/.chd//g;s/ (Disc..)//g;s/ Disc..*$//g;s/ (.*//g')

        echo "$i" >> "$title".m3u
done
# Setting m3u as only enabled file extension for psx
sed -i 's/psx.*/psx.HiddenExt" value="bin;cue;img;mdf;pbp;toc;cbn;ccd;chd;zip;7z;iso" \/>/g' /storage/.config/emulationstation/es_settings.cfg
clear >/dev/console
systemctl start emustation
