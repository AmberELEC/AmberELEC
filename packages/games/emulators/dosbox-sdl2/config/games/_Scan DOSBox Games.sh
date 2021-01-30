#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2020-present Sylvia van Os (https://github.com/TheLastProject)
# Copyright (C) 2020-present Fewtarius

echo -e $(date -u)" - Script started.\n" >> /tmp/logs/dosbox_scan.log

EE_DEVICE=$(cat /ee_arch)

source /usr/bin/env.sh
source /etc/profile
rp_registerAllModules

joy2keyStart
clear >/dev/console

#rm "/storage/.config/dosbox/games/*.conf"

function create_launcher() {
    message_stream "\nAdding $2..." 0
    launcher_name="$1 ($2)"
    cp /storage/.config/dosbox/dosbox-SDL2.conf "/storage/.config/dosbox/games/$launcher_name.conf"
    cat <<EOF >> "/storage/.config/dosbox/games/$launcher_name.conf"
mount c /storage/roms/pc/$(basename $data_dir)
c:
$2
exit
EOF
}

message_stream "Scanning for games...\n" 0

OIFS="$IFS"
IFS=$'\n'
for data_dir in $(find /storage/roms/pc/ -type d -name "*")
do
  echo "Testing (dir) $data_dir"
  if [ -d "$data_dir" ]; then
        for executable in $(find "$data_dir" -iname "*.exe")
        do
            echo "Testing (exe) $executable"
            executable_case="$(basename "$executable" | tr '[:lower:]' '[:upper:]')"
            echo "Case $executable"
            case "$executable_case" in
                  "SETUP.EXE"    | "INSTALL.EXE"  | "INSTALLER.EXE" | \
                  "APOGEE.BAT"   | "CATALOG.EXE"  | "DEALERS.EXE"   | \
                  "SWCBBS.EXE"   | "FILE0001.EXE" | "FILE0001.EXE"  | \
                  "HELPME.EXE"   | "DOS4GW.EXE"   | "NETARENA.EXE"  | \
                  "NETIPX.EXE"   | "NETMODEM.EXE" | "NETTERM.EXE"   | \
                  "ORDER.EXE"    | "DOSINST.EXE"  | "PM2WINST.EXE"  | \
                  "README.EXE"   | "MMD.EXE"      | "PMDL.EXE"      | "RAP-HELP.EXE" | \
                  "XRFILE01.EXE" | "XRFILE02.EXE" | "XRFILE03.EXE"  | \
                  "XRFILE04.EXE" | "FADER.EXE"    | "SETSOUND.EXE"  | \
                  "DRIVER.EXE"   | "EMUSET.EXE"   | "GRAVUTIL.EXE"  | "GUSEMU.EXE"   | \
                  "INSTGRPS.EXE" | "LOADER.EXE"   | "LOADBOS.EXE"   | "MEGAEM.EXE"   | \
                  "MIDIFIER.EXE" | "PLAYFILE.EXE" | "PLAYMIDI.EXE"  | \
                  "ULTRAJOY.EXE" | "ULTRAMID.EXE" | "ULTRAMIX.EXE"  | \
                  "ULTRINIT.EXE" | "OMF21.EXE"    | "LOADSBOS.EXE" )
                  ;;
                *)
			create_launcher "$(basename "$data_dir")" "$(basename "$executable")"
                ;;
            esac
        done
    fi
done
message_stream "Restarting EmulationStation...\n" 0
echo echo "Restarting EmulationStation..." >> /tmp/logs/dosbox_scan.log
systemctl restart emustation
clear >/dev/console
