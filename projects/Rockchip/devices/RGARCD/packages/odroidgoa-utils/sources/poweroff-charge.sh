#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-or-later
# The SD bring-up loader has no charging/recovery boot mode.
exec /usr/bin/systemctl --force poweroff
