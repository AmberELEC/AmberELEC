#!/bin/bash

. /etc/profile

message_stream "Updating RetroArch configuration".02
rsync -av /usr/config/retroarch/* /storage/.config/retroarch/

message_stream "Updating emulationstation" .02
cp /usr/config/emulationstation/es_systems.cfg /storage/.config/emulationstation
cp /usr/config/emulationstation/es_settings.cfg /storage/.config/emulationstation

message_stream "Updating jslisten configuration" .02
cp /usr/config/emuelec/configs/jslisten.cfg /storage/.config/emuelec/configs/jslisten.cfg

message_stream "Updating Setup Menu" .02
cp /usr/config/emuelec/scripts/modules/gamelist.xml /storage/.config/emuelec/scripts/modules/gamelist.xml

message_stream "Restarting EmulationStation" .02
systemctl restart emustation
