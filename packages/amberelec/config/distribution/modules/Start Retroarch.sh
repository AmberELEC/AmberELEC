#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Fewtarius

source /usr/bin/env.sh
source /etc/profile

jslisten set "killall retroarch"

/usr/bin/retroarch
/usr/bin/clear-retroarch.sh
