#!/bin/bash

if [[ ! -f "/storage/roms/gamedata/mupen64plus/InitAutoCfg.ini" ]]; then
	mkdir -p /storage/roms/gamedata/mupen64plus
	cp /usr/local/share/mupen64plus/InputAutoCfg.ini /storage/roms/gamedata/mupen64plus/
fi

if [[ ! -f "/storage/.corfig/mupen64plus/mupen64plus.cfg" ]]; then
	mkdir -p /storage/.config/mupen64plus
	cp /usr/local/share/mupen64plus/mupen64plus.cfg /storage/.config/mupen64plus/
fi

/usr/local/bin/mupen64plus --gfx mupen64plus-video-$1 "$2"