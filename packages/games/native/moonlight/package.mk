# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Fewtarius

PKG_NAME="moonlight"
PKG_VERSION="5b6639c8a76c4bbb5e0b4bcfe41b8df136608885"
PKG_ARCH="any"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/irtimmer/moonlight-embedded"
PKG_URL="$PKG_SITE.git"
PKG_DEPENDS_TARGET="toolchain opus libevdev alsa enet"
PKG_SHORTDESC="Moonlight Embedded is an open source implementation of NVIDIA's GameStream, as used by the NVIDIA Shield, but built for Linux."
PKG_TOOLCHAIN="cmake"
GET_HANDLER_SUPPORT="git"

