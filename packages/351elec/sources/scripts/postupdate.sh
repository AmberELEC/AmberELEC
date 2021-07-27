#!/bin/bash
##
## This script should only run after an update
##
## Config Files
CONF="/storage/.config/distribution/configs/distribution.conf"
RACONF="/storage/.config/retroarch/retroarch.cfg"

## 2021-07-27 (konsumschaf)
## Copy es_features.cfg over on every update
if [ -f /usr/config/emulationstation/es_features.cfg ]; then
	cp /usr/config/emulationstation/es_features.cfg /storage/.emulationstation/.
fi

## 2021-07-24 (konsumschaf)
## Remove all settings from retroarch.cfg that are set in setsettings.sh
## Retroarch uses the settings in retroarch.cfg if there is an override file that misses them
sed -i '/video_scale_integer =/d' ${RACONF}
sed -i '/video_ctx_scaling =/d' ${RACONF}
sed -i '/video_shader =/d' ${RACONF}
sed -i '/video_shader_enable =/d' ${RACONF}
sed -i '/video_smooth =/d' ${RACONF}
sed -i '/aspect_ratio_index =/d' ${RACONF}
sed -i '/rewind_enable =/d' ${RACONF}
sed -i '/run_ahead_enabled =/d' ${RACONF}
sed -i '/run_ahead_frames =/d' ${RACONF}
sed -i '/run_ahead_secondary_instance =/d' ${RACONF}
sed -i "/state_slot =/d" ${RACONF}
sed -i '/savestate_auto_save =/d' ${RACONF}
sed -i '/savestate_auto_load =/d' ${RACONF}
sed -i '/savestates_in_content_dir =/d' ${RACONF}
sed -i '/savestate_directory =/d' ${RACONF}
sed -i '/cheevos_enable =/d' ${RACONF}
sed -i '/cheevos_username =/d' ${RACONF}
sed -i '/cheevos_password =/d' ${RACONF}
sed -i '/cheevos_hardcore_mode_enable =/d' ${RACONF}
sed -i '/cheevos_leaderboards_enable =/d' ${RACONF}
sed -i '/cheevos_verbose_enable =/d' ${RACONF}
sed -i '/cheevos_auto_screenshot =/d' ${RACONF}
sed -i '/ai_service_mode =/d' ${RACONF}
sed -i '/ai_service_enable =/d' ${RACONF}
sed -i '/ai_service_source_lang =/d' ${RACONF}
sed -i '/ai_service_url =/d' ${RACONF}
sed -i "/input_libretro_device_p1/d" ${RACONF}
sed -i "/fps_show/d" ${RACONF}
sed -i "/netplay =/d" ${RACONF}
sed -i "/netplay_ip_port/d" ${RACONF}
sed -i "/netplay_delay_frames/d" ${RACONF}
sed -i "/netplay_nickname/d" ${RACONF}
sed -i "/netplay_client_swap_input/d" ${RACONF}
sed -i "/netplay_ip_port/d" ${RACONF}
sed -i "/netplay_server_ip/d" ${RACONF}
sed -i "/netplay_client_swap_input/d" ${RACONF}
sed -i "/netplay_spectator_mode_enable/d" ${RACONF}
sed -i "/netplay_use_mitm_server/d" ${RACONF}
sed -i "/netplay_ip_address/d" ${RACONF}
sed -i "/netplay_mitm_server/d" ${RACONF}
sed -i "/netplay_mode/d" ${RACONF}
sed -i "/input_player1_analog_dpad_mode/d" ${RACONF}
# bezels
sed -i "/input_overlay_enable/d" ${RACONF}
sed -i "/input_overlay/d" ${RACONF}
sed -i "/input_overlay_hide_in_menu/d" ${RACONF}
sed -i "/input_overlay_opacity/d" ${RACONF}
sed -i "/input_overlay_show_inputs/d" ${RACONF}
sed -i "/custom_viewport_x/d" ${RACONF}
sed -i "/custom_viewport_y/d" ${RACONF}
sed -i "/custom_viewport_width/d" ${RACONF}
sed -i "/custom_viewport_height/d" ${RACONF}


## 2021-07-02 (konsumschaf)
## Change the settings for global.retroachievements.leaderboards
if grep -q "global.retroachievements.leaderboards=0" ${CONF}; then
	sed -i "/global.retroachievements.leaderboards/d" ${CONF}
	echo "global.retroachievements.leaderboards=disabled" >> ${CONF}
elif grep -q "global.retroachievements.leaderboards=1" ${CONF}; then
	sed -i "/global.retroachievements.leaderboards/d" ${CONF}
	echo "global.retroachievements.leaderboards=enabled" >> ${CONF}
fi

## 2021-05-27
## Enable D-Pad to analogue at boot until we create a proper toggle
sed -i "/## Enable D-Pad to analogue at boot until we create a proper toggle/d" /storage/.config/distribution/configs/distribution.conf
sed -i "/global.analogue/d" /storage/.config/distribution/configs/distribution.conf
echo '## Enable D-Pad to analogue at boot until we create a proper toggle' >> /storage/.config/distribution/configs/distribution.conf
echo 'global.analogue=1' >> /storage/.config/distribution/configs/distribution.conf

## 2021-05-17:
## Remove mednafen core files from /tmp/cores
if [ "$(ls /tmp/cores/mednafen_* | wc -l)" -ge "1" ]; then
	rm /tmp/cores/mednafen_*
fi

## 2021-05-17:
## Remove package solarus if still installed
if [ -x /storage/.config/packages/solarus/uninstall.sh ]; then
	/usr/bin/351elec-es-packages remove solarus
fi

## 2021-05-12:
## After PCSX-ReARMed core update
## Cleanup the PCSX-ReARMed core remap-files, they are not needed anymore
if [ -f /storage/.config/remappings/PCSX-ReARMed/PCSX-ReARMed.rmp ]; then
	rm /storage/.config/remappings/PCSX-ReARMed/PCSX-ReARMed.rmp
fi

if [ -f /storage/roms/gamedata/remappings/PCSX-ReARMed/PCSX-ReARMed.rmp ]; then
	rm /storage/roms/gamedata/remappings/PCSX-ReARMed/PCSX-ReARMed.rmp
fi

## 2021-05-15:
## MC needs the config
if [ -z $(ls -A /storage/.config/mc/) ]; then
	rsync -a /usr/config/mc/* /storage/.config/mc
fi

## 2021-05-15:
## Remove retrorun package if still installed
if [ -x /storage/.config/packages/retrorun/uninstall.sh ]; then
	/usr/bin/351elec-es-packages remove retrorun
fi

## Moved over from /usr/bin/autostart.sh
## Migrate old emuoptions.conf if it exist
if [ -e "/storage/.config/distribution/configs/emuoptions.conf" ]
then
	echo "# -------------------------------" >> /storage/.config/distribution/configs/distribution.conf
	cat /storage/.config/distribution/configs/emuoptions.conf >> /storage/.config/distribution/configs/distribution.conf
	echo "# -------------------------------" >> /storage/.config/distribution/configs/distribution.conf
	mv /storage/.config/distribution/configs/emuoptions.conf /storage/.config/distribution/configs/emuoptions.conf.bak
fi

## Moved over from /usr/bin/autostart.sh
## Save old es_systems.cfg in case it is still needed
if [ -f /storage/.config/emulationstation/es_systems.cfg ]; then
	mv /storage/.config/emulationstation/es_systems.cfg\
	   /storage/.config/emulationstation/es_systems.oldcfg-rename-to:es_systems_custom.cfg-if-needed
fi

## Moved over from /usr/bin/autostart.sh
## Copy after new installation / missing logo.png
if [ "$(cat /usr/config/.OS_ARCH)" == "RG351P" ]; then
	cp -f /usr/config/splash/splash-480l.png /storage/.config/emulationstation/resources/logo.png
elif [ "$(cat /usr/config/.OS_ARCH)" == "RG351V" ]; then
	cp -f /usr/config/splash/splash-640.png /storage/.config/emulationstation/resources/logo.png
fi


## Just to know when the last update took place
echo Last Update: `date -Iminutes` > /storage/.lastupdate

