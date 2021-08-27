#!/bin/bash

if [[ ! -f "/storage/roms/gamedata/mupen64plus/InitAutoCfg.ini" ]]; then
	mkdir -p /storage/roms/gamedata/mupen64plus
	cp /storage/.config/mupen64plus/InitAutoCfg.ini /storage/roms/gamedata/mupen64plus/
fi

/usr/local/bin/mupen64plus --gfx mupen64plus-video-$1 "$2"