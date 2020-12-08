#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2020-present Sylvia van Os (https://github.com/TheLastProject)

echo -e $(date -u)" - Script started.\n" >> /tmp/logs/dosbox_scan.log

EE_DEVICE=$(cat /ee_arch)

source /emuelec/scripts/env.sh
rp_registerAllModules

joy2keyStart
ear >/dev/console

#rm "/storage/.config/dosbox/games/*.conf"

function create_launcher() {
    launcher_name="$1 ($2)"

    #dos_dirname="${1:0:6}~1"

    #mkdir -p "/storage/.config/dosbox/games/$launcher_name"
    cp /storage/.config/dosbox/dosbox-SDL2.conf "/storage/.config/dosbox/games/$launcher_name.conf"
		echo "/storage/.config/dosbox/games/$launcher_name.conf" >> /tmp/logs/dosbox_scan.log
    echo "mount c /storage/roms/pc/$(basename $data_dir)" >> "/storage/.config/dosbox/games/$launcher_name.conf"
		echo "Appended 'mount c /storage/roms/pc/$(basename $data_dir)' to /storage/.config/dosbox/games/$launcher_name.conf" >> /tmp/logs/dosbox_scan.log
    echo "c:" >> "/storage/.config/dosbox/games/$launcher_name.conf"
		echo "Appended 'c:' to /storage/.config/dosbox/games/$launcher_name.conf" >> /tmp/logs/dosbox_scan.log
    echo "$2" >> "/storage/.config/dosbox/games/$launcher_name.conf"
		echo "Appended '$2' to /storage/.config/dosbox/games/$launcher_name.conf" >> /tmp/logs/dosbox_scan.log
    echo "exit" >> "/storage/.config/dosbox/games/$launcher_name.conf"
		echo "Appended 'exit' to /storage/.config/dosbox/games/$launcher_name.conf" >> /tmp/logs/dosbox_scan.log
	
    #touch "/storage/.config/dosbox/games/$launcher_name/$launcher_name.bat"
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
                  "README.EXE" | "MMD.EXE" | "PMDL.EXE" | "RAP-HELP.EXE" | \
                  "XRFILE01.EXE" | "XRFILE02.EXE" | "XRFILE03.EXE" | \
                  "XRFILE04.EXE" | "FADER.EXE" | "SETSOUND.EXE" | \
                  "DRIVER.EXE" | "EMUSET.EXE" | "GRAVUTIL.EXE" | "GUSEMU.EXE" | \
                  "INSTGRPS.EXE" | "LOADER.EXE" | "LOADBOS.EXE" | "MEGAEM.EXE" | \
                  "MIDIFIER.EXE" | "PLAYFILE.EXE" | "PLAYMIDI.EXE" | \
                  "ULTRAJOY.EXE" | "ULTRAMID.EXE" | "ULTRAMIX.EXE" | \
                  "ULTRINIT.EXE" | "OMF21.EXE" | "LOADSBOS.EXE" )
                  ;;
                *)
				message_stream "Adding games...\n" 0
				echo -e "Game found in $data_dir\nbasename= $basename\ndata_dir= $data_dir\nexecutable= $executable\nexecutable_case= $executable_case\n" >> /tmp/logs/dosbox_scan.log
                create_launcher "$(basename $data_dir)" "$(basename $executable)"
				echo -e "Created $(basename $data_dir), $(basename $executable)\n" >> /tmp/logs/dosbox_scan.log
                ;;
            esac
        done
    fi
done
message_stream "Restarting EmulationStation...\n" 0
echo echo "Restarting EmulationStation..." >> /tmp/logs/dosbox_scan.log
systemctl restart emustation
clear >/dev/console

#OMF.EXE Has it own configs