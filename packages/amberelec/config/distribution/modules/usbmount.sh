#!/bin/bash

SUCCESS=""
ERROR=""

[ "$(cat /proc/mounts | grep '/dev/sd[a-z]')" ];

if [[ "$?" -eq 0 ]];
then
	PARTITIONS=($(cat /proc/mounts | grep '/dev/sd[a-z]' | cut -d  ' ' -f1 | sed 's/\/dev\///g'))

	for e in "${PARTITIONS[@]}";
	do
		if [ "$(cat /proc/mounts | grep /dev/${e})" ];
		then
			echo "trying to unmount partition ${e}..." > /dev/console
			umount /dev/${e}

			if [[ "$?" -eq 0 ]];
			then
				if [ -d "/media/${e}/" ]; then
					rmdir /media/${e}
				fi
				SUCCESS+="Partition ${e} has been successfully unmounted.\n"
			else
				ERROR+="Partition ${e} could not be unmounted.\n"
			fi
			clear > /dev/console
		fi
	done
	if [[ ${#ERROR} -eq 0 ]];
	then
		text_viewer -w -t "USB unmount of partitions successful!" -m "${SUCCESS}"
	else
		text_viewer -w -e -t "USB unmount of partitions failed!" -m "${ERROR}\n${SUCCESS}"
	fi
else
	PARTITIONS=($(ls /dev/sd[a-z]? | sed 's/\/dev\///g'))
	
	for e in "${PARTITIONS[@]}";
	do	
		if [ ! -d "/media/${e}/" ]; then
			mkdir /media/${e}
		fi

		echo "trying to mount partition ${e}..." > /dev/console
		mount -t auto /dev/${e} /media/${e} -o rw

		if [[ "$?" -eq 0 ]];
		then
			SUCCESS+="Partition ${e} has been mounted to /media/${e}.\n"
		else
			ERROR+="Could not mount partition /dev/${e}.\n"
		fi
		clear > /dev/console
	done
	if [[ ${#ERROR} -eq 0 ]];
	then
		text_viewer -w -t "USB mount of partitions successful!" -m "${SUCCESS}"
	else
		text_viewer -w -e -t "USB mount of partitions failed!" -m "${SUCCESS}\n\n${ERROR}\n\nNote: Only FAT, FAT32, exFAT, and ext2/3/4 filesystems are supported."
	fi
fi
