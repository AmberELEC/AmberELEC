#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2020-present Sylvia van Os (https://github.com/TheLastProject)

EE_DEVICE=$(cat /ee_arch)

source /emuelec/scripts/env.sh
rp_registerAllModules

joy2keyStart
ear >/dev/console

function create_launcher() {
    launcher_name="$1 ($2)"

    dos_dirname="${1:0:6}~1"

    mkdir -p "/storage/.config/dosbox/games/$launcher_name"
    cp /storage/.config/dosbox/dosbox-SDL2.conf "/storage/.config/dosbox/games/$launcher_name"
    cat <<EOF >>/storage/.config/dosbox/games/$launcher_name/dosbox-SDL2.conf
mount c /storage/roms/pc/$(basename $data_dir)
c:
$2
exit
EOF
    touch "/storage/.config/dosbox/games/$launcher_name/$launcher_name.bat"
}

message_stream "Scanning for games...\n" 0
for data_dir in /storage/roms/pc/*; do
    if [ -d "$data_dir" ]; then
        for executable in $(find "$data_dir" -iname "*.exe"); do
            executable_case="$(basename $executable | tr '[:lower:]' '[:upper:]')"
            case "$executable_case" in
                  "SETUP.EXE" | "INSTALL.EXE" | "INSTALLER.EXE" | \
                  "APOGEE.BAT" | "CATALOG.EXE" | "DEALERS.EXE" |  \
                  "SWCBBS.EXE" | "FILE0001.EXE" | "FILE0001.EXE" | \
                  "HELPME.EXE" | "DOS4GW.EXE" | "NETARENA.EXE" |   \
                  "NETIPX.EXE" | "NETMODEM.EXE" | "NETTERM.EXE" |  \
                  "ORDER.EXE" | "DOSINST.EXE" | "PM2WINST.EXE" |   \
                  "README.EXE" | "MMD.COM" | "PMDL.COM" | "RAP-HELP.EXE" | \
                  "XRFILE01.EXE" | "XRFILE02.EXE" | "XRFILE03.EXE" | \
                  "XRFILE04.EXE" | "FADER.EXE" | "SETSOUND.EXE" | \
                  "DRIVER.EXE" | "EMUSET.EXE" | "GRAVUTIL.EXE" | "GUSEMU.EXE" | \
                  "INSTGRPS.EXE" | "LOADER.EXE" | "LOADBOS.EXE" | "MEGAEM.EXE" | \
                  "MIDIFIER.EXE" | "PLAYFILE.EXE" | "PLAYMIDI.EXE" | \
                  "ULTRAJOY.EXE" | "ULTRAMID.EXE" | "ULTRAMIX.EXE" | \
                  "ULTRINIT.EXE" )
                  ;;
                *)
	 	  message_stream "Adding games...\n" 0
                  create_launcher "$(basename $data_dir)" "$(basename $executable)"
                  ;;
            esac
        done
    fi
done
message_stream "Restarting EmulationStation...\n" 0
systemctl restart emustation
clear >/dev/console
