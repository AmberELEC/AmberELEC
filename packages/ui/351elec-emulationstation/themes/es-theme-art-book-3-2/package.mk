# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020 Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2020 351ELEC team (https://github.com/fewtarius/351ELEC)

PKG_NAME="es-theme-art-book-3-2"
PKG_REV="1"
PKG_VERSION="5b27f5548c7a4ec23408d7e6fddd3983b894838d"
PKG_ARCH="any"
PKG_LICENSE="CUSTOM"
PKG_SITE="https://github.com/anthonycaccese/es-theme-art-book-3-2"
PKG_URL="$PKG_SITE.git"
GET_HANDLER_SUPPORT="git"
PKG_SHORTDESC="ArtBook"
PKG_LONGDESC="Art Book - 351ELEC default theme for RG351P/M"
PKG_TOOLCHAIN="manual"

if [ "${DEVICE}" = "RG351P" ]; then
  makeinstall_target() {
    mkdir -p $INSTALL/usr/config/emulationstation/themes/$PKG_NAME
    cp -rf * $INSTALL/usr/config/emulationstation/themes/$PKG_NAME
  }
fi
