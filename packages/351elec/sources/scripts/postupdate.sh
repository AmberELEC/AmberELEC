#!/bin/bash
## 
## This script should only run after an update
## 


## 2021-05-12:
## After PCSX-ReARMed core update
## Cleanup the PCSX-ReARMed core remap-files, they are not needed anymore
if [ -f /storage/.config/remappings/PCSX-ReARMed/PCSX-ReARMed.rmp ]; then
	rm /storage/.config/remappings/PCSX-ReARMed/PCSX-ReARMed.rmp
fi

if [ -f /storage/roms/gamedata/remappings/PCSX-ReARMed/PCSX-ReARMed.rmp ]; then
        rm /storage/roms/gamedata/remappings/PCSX-ReARMed/PCSX-ReARMed.rmp
fi

## MC needs the config
if [ -z $(ls -A /storage/.config/mc/) ]; then
	rsync -a /usr/config/mc/* /storage/.config/mc
fi


## Just to know when the last update took place
echo Last Update: `date -Iminutes` > /storage/.lastupdate

