#!/bin/bash
###################################################################
#
#  SPDX-License-Identifier: LGPL-3.0-or-later
#  Copyright (C) 2020:
#      - Claudio de Oliveira (https://github.com/claudiojfo/)
#      - 351ELEC team        (https://github.com/fewtarius/351ELEC)
#
###################################################################


GAMES_PARTITION="/storage/roms"
BACKUP_DIR_NAME="_351ELEC_Symlink_Configs"
BACKUP_TARGETS_FILE="symlink_targets.cfg"
KNOW_FILE_TYPES=(".txt" ".ini" ".cfg" ".conf" ".xml")
UNKNOW_FT_SET_2=".cfg"
REMOVE_START="/storage/"
README_FILE="read_me_before_you_copy_this_to_another_card.txt"
BACKUP_TO="$GAMES_PARTITION/$BACKUP_DIR_NAME"


. /etc/profile
#just for debug
#message_stream () { 
#	echo -e $1 
#}
############

if [ ! -d "$BACKUP_TO" ]; then
	message_stream "\n\e[31mFIRST TIME ON THIS CARD!\e[0m" .02
	message_stream "\nINSTALLING THE SYMLINK CONFIGS FOLDER:\n$BACKUP_TO" .02
	mkdir -p $BACKUP_TO
fi

if [ ! -d "$BACKUP_TO" ]; then
	message_stream "\n\nERROR:\nSYMLINK CONFIGS FOLDER CREATION FAILED." .02
	sleep 2
	clear
	exit 1
fi

cd ${BACKUP_TO}

if [ ! -f "$BACKUP_TARGETS_FILE" ]; then
	echo \
"# Before you uncomment some lines below, or add 
# new ones, keep it in mind:
# - The GAMES partition is not auto-mount, it won't
# be present at the boot, so you can't use the
# /storage/.config it self as symlink target.
# - The idea for this alternative's to keep 2 or 3
# strategic setting files stored in the GAMES partition
# and easily accessible from windows explorer.
# - Use only files or folders that are strictly 
# necessary. There is already a backup system in 
# 351ELEC to store all your settings.
# - Absolutely no warranty, you are on your own! Even
# so, if you blow up everything, yo can use the backup
# that is made every time you run the Symlink script.

# Example (remove the # to uncomment)
#/storage/.config/retroarch/retroarch.cfg

# ...or entire folder (don't use both)
#/storage/.config/retroarch

# Another examples
#/storage/.config/emuelec/configs/emuelec.conf
#/storage/.config/ppsspp/PSP
#/storage/.config/profile.d
#/storage/shaders

# After editing this file, run the script again.

" > "$BACKUP_TARGETS_FILE"
fi

if [ ! -f "$BACKUP_TARGETS_FILE" ]; then
	message_stream "\n\nERROR: DEFAULT SYMLINK CONFIGS FAILED." .02
	sleep 2
	clear
	exit 1
fi

echo -e \
"This folder is supposed to be a safety help but
sometimes it can be your own poison.

First time you run the Symlink Configs script, all
symlink targets are forwarded here, trough symlinks.
Applications will start saving the settings directly
to here.
Default symlink targets file: $BACKUP_TARGETS_FILE

Every time you run the Symlink Configs script, a
compressed folder with all the 'symlink targets'
are saved here.

If you copy this folder to a new card, you will
need to run the Symlink Configs to install the
symlinks, the current settings/defaults are compressed
and saved here, then it will be overwritten by the
ones in this folder.

If you don't want this happen to some configuration,
simply delete it from here before running the script.
Once symlinks are installed, you should not delete
anything here.

Note: that the day will come when configurations
saved here will be incompatible with new versions.

Enjoy,\nClaudio de Oliveira" > "$README_FILE"

pbta=(); pbts=""

while read bti; do
	bti_ns="$(echo -e "${bti}" | sed -e 's/^[[:space:]]*//')"
	if [ ! -z "$bti_ns" ] ; then
		if [[ ${bti_ns:0:1} != "#" ]] ; then
			if [[ -d "$bti_ns" || -f "$bti_ns" || -h "$bti_ns" ]] ; then
				pbta+=("$bti_ns")
				pbts+=" $bti_ns"
			else
				message_stream "\n\nTARGER ERROR:\n$bti_ns" .02
			fi
		fi
	fi
done < "$BACKUP_TARGETS_FILE"


if [ ${#pbta[@]} -gt 0 ] ; then
    bakupfile="backup-$(date '+%Y-%m-%d_%H.%M.%S').tar.gz"
    message_stream "\n\n\e[31mCOMPRESSING:\e[0m\n$BACKUP_TO/$bakupfile" .02
    tar -zcvf $bakupfile $pbts &>/dev/null
    
    flrem=${#REMOVE_START}
	for tci in "${pbta[@]}"; do
		if [ ! -h "$tci" ] ; then
			flname=$tci
			flnamelen=${#flname}
			if [ "$flnamelen" -ge "$flrem" ]; then
				if [[ ${flname:0:$flrem} == "$REMOVE_START" ]] ; then
					flnamelen=$((flnamelen-flrem))
					flname=${flname:$flrem:$flnamelen}
				fi
			fi
			for cfchar in "/" "." ; do
				if [[ ${flname:0:1} == "$cfchar" ]] ; then
					flnamelen=$((flnamelen-1))
					flname=${flname:1:$flnamelen}
				fi
			done
			if [ -d "$bti_ns" ] ; then
				addft=1
				for kft in "${KNOW_FILE_TYPES[@]}"; do
					kftlen=${#kft}
					if [[ "$kft" == "${flname:$((flnamelen-kftlen)):$kftlen}" ]] ; then
						addft=0
						break
					fi
				done
				if [ $addft -eq 1 ] ; then
					flname="$flname$UNKNOW_FT_SET_2"
				fi
			fi
			flname=${flname//\//_}
			
			message_stream "\n\e[31mINSTALLING:\e[0m $flname" .02
			if [[ -d "$flname" || -f "$flname" ]] ; then
				mv -f "$tci" "${tci}_bk_$(date '+%Y-%m-%d_%H.%M.%S')"
			else
				mv -f "$tci" "$flname"
			fi
			ln -s "$BACKUP_TO/$flname" "$tci"
			
		fi
	done
    
else
	message_stream "\n\nLEAVING:\nNO SYMLINK TARGERS TO PROCESS :/" .02
	message_stream "\n\n\e[31mEDIT THE FILE:\e[0m\n$BACKUP_DIR_NAME/\e[31m$BACKUP_TARGETS_FILE\e[0m\nYOU FIND IT IN THE \e[31mGAMES\e[0m PARTITION." .02
	message_stream "\nAND THEN RUN THIS AGAIN.\n\n" .02
	sleep 10
	clear
	exit 0
fi

message_stream "\n\nDONE!" .02
sleep 2
clear

