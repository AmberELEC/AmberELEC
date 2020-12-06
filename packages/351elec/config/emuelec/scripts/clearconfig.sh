#!/bin/sh

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

BACKUPFILE="/storage/roms/backup/351ELEC_BACKUP.zip"
mkdir -p "/storage/roms/backup/"

case $1 in
"EMUS")
  systemctl stop emustation
  /emuelec/scripts/ee_backup.sh b no
  find /storage -mindepth 1 \( ! -regex '^/storage/.config/emulationstation/themes.*' -a ! -regex '^/storage/.update.*' -a ! -regex '^/storage/download.*' -a ! -regex '^/storage/roms.*' \) -delete
  mkdir /storage/.config/
  sync
  systemctl reboot
  ;;
"ALL")
  systemctl stop emustation
  find /storage -mindepth 1 \( ! -regex '^/storage/.update.*' -a ! -regex '^/storage/roms.*' \) -delete
  mkdir /storage/.config/
  sync
  systemctl reboot
  ;;
esac
