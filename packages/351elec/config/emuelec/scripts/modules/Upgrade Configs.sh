#!/bin/bash

. /etc/profile

message_stream "Backing up your existing configuration" .02
emuelec-utils ee_backup backup script

BACKUP="/storage/roms/backup/upgrade"
mkdir ${BACKUP}
message_stream "Updating RetroArch configuration" .02
rsync -av /storage/.config/retroarch/ ${BACKUP}
rsync -av /usr/config/retroarch/* /storage/.config/retroarch/

message_stream "\n\nUpdating emulationstation" .02
rsync -av /usr/config/emulationstation/es_systems.cfg /usr/config/emulationstation/es_settings.cfg ${BACKUP}
cp /usr/config/emulationstation/es_systems.cfg /storage/.config/emulationstation
cp /usr/config/emulationstation/es_settings.cfg /storage/.config/emulationstation

message_stream "\n\nUpdating jslisten configuration" .02
rsync -av /storage/.config/emuelec/configs/jslisten.cfg ${BACKUP}
cp /usr/config/emuelec/configs/jslisten.cfg /storage/.config/emuelec/configs/jslisten.cfg

message_stream "\n\nUpdating Setup Menu" .02
rsync -av /storage/.config/emuelec/scripts/modules/gamelist.xml ${BACKUP}
cp /usr/config/emuelec/scripts/modules/gamelist.xml /storage/.config/emuelec/scripts/modules/gamelist.xml

message_stream "\n\nRestarting EmulationStation" .02
clear >/dev/console
systemctl restart emustation
