#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

source /emuelec/scripts/env.sh
source "$scriptdir/scriptmodules/supplementary/esthemes.sh"
rp_registerAllModules

echo "Installing Drastic."
/usr/config/emulationstation/scripts/drastic/dldrastic.sh
systemctl restart emulationstation.service
