#!/bin/bash

[ "$(cat /proc/mounts | grep /dev/sda)" ];

if [[ "$?" -eq 0 ]];
then
	PARTITIONS=($(cat /proc/mounts | grep /dev/sda | cut -d  ' ' -f1 | sed 's/\/dev\///g'))

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
				text_viewer -w -t "USB unmount of partition ${e} successfull!" -m "Partition ${e} of your USB drive has been successfully unmounted."
			else
				text_viewer -w -e -t "USB unmount of parttion ${e} failed!" -m "Sorry, your USB drive couldn't be unmouted."
			fi
			clear > /dev/console
		fi
	done
else
	PARTITIONS=($(ls /dev/sda? | sed 's/\/dev\///g'))
	
	for e in "${PARTITIONS[@]}";
	do	
		if [ ! -d "/media/${e}/" ]; then
			mkdir /media/${e}
		fi

		echo "trying to mount partition ${e}..." > /dev/console
		mount -t auto /dev/${e} /media/${e} -o rw

		if [[ "$?" -eq 0 ]];
		then
			text_viewer -w -t "USB mount of partition ${e} successfull!" -m "Partition ${e} of your USB drive has been successfully mounted to /media/${e}."
		else
			text_viewer -w -e -t "USB mount of partition ${e} failed!" -m "Sorry, mounting partition ${e} of your USB drive failed.\n\nNote: Only FAT, FAT32 or exFAT, ext2/3/4 filesystems are supported."
		fi
		clear > /dev/console
	done
fi
