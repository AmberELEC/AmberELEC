#!/bin/bash

# Create symlink to game .pak in proper location
ln -s "${1}" /storage/openbor/Paks/Game.pak

# Run retroarch PSP core and start OpenBOR engine
/usr/bin/retroarch -L /tmp/cores/ppsspp_libretro.so /storage/openbor/EBOOT.PBP

# Remove symlink to game .pak when done
rm /storage/openbor/Paks/Game.pak
