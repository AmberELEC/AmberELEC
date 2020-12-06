#!/bin/bash

. /etc/profile

BACKUP="/storage/roms/backup/upgrade"
if [ -d ${BACKUP} ]
then
  message_stream "Restoring Config Files" .02
  rsync -av ${BACKUP} /storage/.config

  message_stream "\n\nRestarting EmulationStation" .02
  clear >/dev/console
  systemctl restart emustation
else
  message_stream "No backup found, not restoring." .02
  sleep 3
  clear >/dev/console
fi
