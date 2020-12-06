#!/bin/bash

. /etc/profile

message_stream "Backing up your existing configuration" .02
emuelec-utils ee_backup backup script

message_stream "Updating RetroArch configuration" .02
rsync -av /usr/config/retroarch/* /storage/.config/retroarch/

message_stream "\n\nUpdating emulationstation" .02
cp /usr/config/emulationstation/es_systems.cfg /storage/.config/emulationstation
cp /usr/config/emulationstation/es_settings.cfg /storage/.config/emulationstation

message_stream "\n\nUpdating jslisten configuration" .02
cp /usr/config/emuelec/configs/jslisten.cfg /storage/.config/emuelec/configs/jslisten.cfg

message_stream "\n\nUpdating Setup Menu" .02
cp /usr/config/emuelec/scripts/modules/gamelist.xml /storage/.config/emuelec/scripts/modules/gamelist.xml

message_stream "\n\nRestarting EmulationStation" .02
clear >/dev/console
systemctl restart emustation
