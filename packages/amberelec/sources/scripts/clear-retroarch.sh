#!/bin/bash
##
## 2021-10-20 (konsumschaf)
##
## Script to remove all unwanted lines from retroarch.cfg
## retroarch.cfg can not include any lines that are set in
## setsettings.py as there is a bug in retroarch: if there is
## an (even empty) override.cfg the settings from appendconfig
## are reverted to the ones in retroarch.cfg
##
## Config Files
RACONF="/storage/.config/retroarch/retroarch.cfg"

sed -i '
        # delete lines
        /ai_service_enable =/d;
        /ai_service_target_lang =/d;
        /ai_service_url =/d;
        /aspect_ratio_index =/d;
        /cheevos_token =/d;
        /cheevos_auto_screenshot =/d;
        /cheevos_badges_enable =/d;
        /cheevos_challenge_indicators =/d;
        /cheevos_enable =/d;
        /cheevos_hardcore_mode_enable =/d;
        /cheevos_leaderboards_enable =/d;
        /cheevos_password =/d;
        /cheevos_richpresence_enable =/d;
        /cheevos_start_active =/d;
        /cheevos_test_unofficial =/d;
        /cheevos_unlock_sound_enable =/d;
        /cheevos_username =/d;
        /cheevos_verbose_enable =/d;
        /custom_viewport_height/d;
        /custom_viewport_width/d;
        /custom_viewport_x/d;
        /custom_viewport_y/d;
        /fps_show/d;
        /input_libretro_device_p1/d;
        /input_overlay/d;
        /input_overlay_enable/d;
        /input_overlay_hide_in_menu/d;
        /input_overlay_opacity/d;
        /input_overlay_show_inputs/d;
        /netplay =/d;
        /netplay_client_swap_input/d;
        /netplay_client_swap_input/d;
        /netplay_delay_frames/d;
        /netplay_ip_address/d;
        /netplay_ip_port/d;
        /netplay_ip_port/d;
        /netplay_mitm_server/d;
        /netplay_mode/d;
        /netplay_nickname/d;
        /netplay_public_announce/d;
        /netplay_server_ip/d;
        /netplay_spectator_mode_enable/d;
        /netplay_use_mitm_server/d;
        /record_driver =/d;
        /rewind_enable =/d;
        /run_ahead_enabled =/d;
        /run_ahead_frames =/d;
        /run_ahead_secondary_instance =/d;
        /savestate_auto_index =/d;
        /savestate_auto_load =/d;
        /savestate_auto_save =/d;
        /savestate_directory =/d;
        /savestate_max_keep =/d;
        /savestates_in_content_dir =/d;
        /state_slot =/d;
        /video_ctx_scaling =/d;
        /video_filter =/d;
        /video_scale_integer =/d;
        /video_scale_integer_overscale =/d;
        /video_shader =/d;
        /video_shader_enable =/d;
        /video_smooth =/d;

        # replace lines
        s/wifi_driver = "connmanctl"/wifi_driver = "null"/g;
        s/vrr_runloop_enable = "true"/vrr_runloop_enable = "false"/g;
        s/builtin_imageviewer_enable = "true"/builtin_imageviewer_enable = "false"/g;

        ' ${RACONF}

