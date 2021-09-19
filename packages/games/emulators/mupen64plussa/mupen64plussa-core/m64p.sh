#!/bin/bash

if [[ ! -f "/storage/roms/gamedata/mupen64plussa/InputAutoCfg.ini" ]]; then
	mkdir -p /storage/roms/gamedata/mupen64plussa
	cp /usr/local/share/mupen64plus/InputAutoCfg.ini /storage/roms/gamedata/mupen64plussa/
fi

if [[ ! -f "/storage/.config/mupen64plussa/mupen64plus.cfg" ]]; then
	mkdir -p /storage/.config/mupen64plussa
	cp /usr/local/share/mupen64plus/mupen64plus.cfg /storage/.config/mupen64plussa/
fi

case $1 in
	"m64p_gl64mk2")
		/usr/local/bin/mupen64plus --configdir /storage/.config/mupen64plussa --gfx mupen64plus-video-glide64mk2 "$2"
	;;
	"m64p_rice")
		/usr/local/bin/mupen64plus --configdir /storage/.config/mupen64plussa --gfx mupen64plus-video-rice "$2"
	;;
	*)
		/usr/local/bin/mupen64plus --configdir /storage/.config/mupen64plussa --gfx mupen64plus-video-rice "$2"
	;;
esac
