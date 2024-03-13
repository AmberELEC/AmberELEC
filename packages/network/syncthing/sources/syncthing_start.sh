#!/bin/sh

# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

. /etc/profile

syncthing generate --home=/storage/.config/syncthing --gui-user=root --gui-password=amberelec

STNODEFAULTFOLDER="1" syncthing -home=/storage/.config/syncthing    \
                                -gui-address="0.0.0.0:8384"         \
                                -no-upgrade                         \
                                -logflags=0                         \
                                -no-browser                         \
                                -no-restart                         \
                                &