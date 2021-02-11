#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2020-present Fewtarius

. /etc/profile
jslisten set "killall DinguxCommander"
source /usr/bin/env.sh
joy2keyStart

mkdir -p /tmp/bin ||:

cp -f /usr/bin/DinguxCommander /tmp/bin

## Bugs out with 2.0.12. Temporary patch until it can be fixed.
patchelf --replace-needed libSDL2-2.0.so.0 libSDL2-2.0.so.0.10.0 /tmp/bin/DinguxCommander

/tmp/bin/DinguxCommander

rm -f /tmp/bin/DinguxCommander
