#!/bin/sh

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)

.OS_VERSION1=$(cat /storage/.config/.OS_VERSION)
.OS_VERSION2=$(cat /usr/config/.OS_VERSION)

if [ "$.OS_VERSION1" != "$.OS_VERSION2" ]; then

rm -rf /usr/bin/*
cp -rf /usr/config/usr/bin/* /usr/bin

fi
