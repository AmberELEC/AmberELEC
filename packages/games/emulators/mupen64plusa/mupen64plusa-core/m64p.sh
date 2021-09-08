#!/bin/bash

if [[ ! -f "/storage/roms/gamedata/mupen64plusa/InputAutoCfg.ini" ]]; then
	mkdir -p /storage/roms/gamedata/mupen64plusa
	cp /usr/local/share/mupen64plus/InputAutoCfg.ini /storage/roms/gamedata/mupen64plusa/
fi

if [[ ! -f "/storage/.config/mupen64plusa/mupen64plus.cfg" ]]; then
	mkdir -p /storage/.config/mupen64plusa
	cp /usr/local/share/mupen64plus/mupen64plus.cfg /storage/.config/mupen64plusa/
fi

case $1 in
	"mupen64plusa_glide64mk2")
		/usr/local/bin/mupen64plus --configdir /storage/.config/mupen64plusa --gfx mupen64plus-video-glide64mk2 "$2"
	;;
	"mupen64plusa_rice")
		/usr/local/bin/mupen64plus --configdir /storage/.config/mupen64plusa --gfx mupen64plus-video-rice "$2"
	;;
	*)
		/usr/local/bin/mupen64plus --configdir /storage/.config/mupen64plusa --gfx mupen64plus-video-rice "$2"
	;;
esac
