#!/bin/bash

ROMNAME="$1"
ROMFILE=${ROMNAME##*/}
EXTENSION="${ROMNAME##*.}"
BASEROMNAME=${ROMFILE//.${EXTENSION}}
GAMEFOLDER="${ROMNAME//${ROMFILE}}"
ROMS_DIR="/storage/roms"
STATES_DIR="$GAMEFOLDER/states"
BIOS_DIR="$ROMS_DIR/bios"
RUN_DIR="/tmp/piemu"

mkdir -p "$STATES_DIR"

rm -rf $RUN_DIR
mkdir -p $RUN_DIR

# Check whether it's a pfi or pex file

cd $RUN_DIR

if [[ EXTENSION == "pfi" ]]; then
	cp $ROMNAME $RUN_DIR
	mv "$RUN_DIR/$ROMFILE" "piece.pfi"
fi

if [[ "$EXTENSION" == "pex" ]]; then
	if [[ -f "$GAMEFOLDER/$BASEROMNAME.pfs" ]]; then
		cd $GAMEFOLDER
		dos2unix "$GAMEFOLDER/$BASEROMNAME.pfs"
		cat "$GAMEFOLDER/$BASEROMNAME.pfs" | xargs -I % cp % $RUN_DIR
		cd $RUN_DIR
		/usr/bin/mkpfi "$BIOS_DIR/all.bin"
		cat "$GAMEFOLDER/$BASEROMNAME.pfs" | xargs -I  % /usr/bin/pfar piece.pfi -a %
	else
		cp $ROMNAME $RUN_DIR
		/usr/bin/mkpfi "$BIOS_DIR/all.bin"
		/usr/bin/pfar piece.pfi -a "$ROMFILE"
		if [[ -f "$GAMEFOLDER/$BASEROMNAME.sav" ]]; then
			cp "$GAMEFOLDER/$BASEROMNAME.sav" $RUN_DIR
			/usr/bin/pfar piece.pfi -a "$ROMFILE.sav"
		fi
	fi
fi

if [[ "$EXTENSION" == "pfs" ]]; then
	cd $GAMEFOLDER
	xargs -a $ROMNAME cp -t $RUN_DIR
	cd $RUN_DIR
	/usr/bin/mkpfi "$BIOS_DIR/all.bin"
	cat $ROMNAME | xargs -I  % /usr/bin/pfar piece.pfi -a %
fi

/usr/bin/piemu