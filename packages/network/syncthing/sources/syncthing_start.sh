#!/bin/sh

# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

. /etc/profile

STNODEFAULTFOLDER="1" syncthing -home=/storage/             \
                                -gui-address="0.0.0.0:8384" \
                                -logflags=0                 \
                                -no-browser                 \
                                -no-restart                 \
                                &

