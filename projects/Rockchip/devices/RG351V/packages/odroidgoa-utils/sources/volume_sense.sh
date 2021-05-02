#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Fewtarius

# Source predefined functions and variables
. /etc/profile

DEVICE='/dev/input/by-path/platform-rg351-keys-event'

# type 1 (EV_KEY), code 114 (KEY_VOLUMEDOWN), value 1
# type 1 (EV_KEY), code 115 (KEY_VOLUMEUP), value 1

VOL_UP='*(KEY_VOLUMEUP), value 1*'
VOL_DN='*(KEY_VOLUMEDOWN), value 1*'

evtest "${DEVICE}" | while read line; do
    case $line in
	(${VOL_UP})
	/usr/bin/odroidgoa_utils.sh vol +
	;;
	(${VOL_DN})
	/usr/bin/odroidgoa_utils.sh vol -
	;;
    esac
done
