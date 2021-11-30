#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Fewtarius

source /usr/bin/env.sh
source /etc/profile

jslisten set "killall retroarch32"

set_kill_keys "retroarch32"
export LD_LIBRARY_PATH="/usr/lib32"
/usr/bin/retroarch32 --appendconfig /usr/config/retroarch/retroarch32bit-append.cfg
/usr/bin/clear-retroarch.sh
