#!/bin/bash
##
## Generates bezel.cfg for 351ELEC
## by konsumschaf 2021
##

usage () {
    cat << EOF
Usage
$0  [-g] [-s] [-n #] -r "name of the rom" -p "name of the png for the bezel"
-g = grid ON
-s = shadow ON
-r = ROM name for this bezel
-p = Bezel picture.png
-n = number of the config if empty it will be .cfg
EOF

    exit
}


shadow=0
grid=0
overlays=0
number=0
firstOverlay="grid.png"
secondOverlay="shadow.png"

while getopts ":sgr:p:n:" arg; do
    case $arg in
        s)
            shadow=1
            overlays=$((${overlays}+1))
            firstOverlay="shadow.png"
            secondOverlay="grid.png"
        ;;
        g)
            grid=1
            overlays=$((${overlays}+1))
        ;;
        r)
            romname=${OPTARG}
        ;;
        p)
            picture=${OPTARG}
        ;;
        n)
            number=${OPTARG}
        ;;

    esac
done

if [ "${romname}" == "" ] || [ "${picture}" == "" ]; then
    usage
fi

romname="${romname%.*}"

if [ ${number} -gt 0 ]; then
    cfgnumber=".${number}"
fi

configname="${romname}""${cfgnumber}"".cfg"

cat <<EOF >"${configname}"
overlays = 1
# The Bezel
overlay0_overlay = "$picture"
overlay0_full_screen = true
overlay0_normalized = true
# How many Overlays are active on top of the bezel
overlay0_descs = ${overlays}
# First Overlay for the bezel
overlay0_desc0_overlay = "${firstOverlay}"
overlay0_desc0 = "nul,0.5,0.5,rect,0.5,0.5"
# Second Overlay for the bezel
overlay0_desc1_overlay = "${secondOverlay}"
overlay0_desc1 = "nul,0.5,0.5,rect,0.5,0.5"
EOF