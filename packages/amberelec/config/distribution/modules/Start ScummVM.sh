#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present AmberELEC

source /usr/bin/env.sh
source /etc/profile

jslisten set "killall scummvm"

/usr/bin/scummvm.sh sa
