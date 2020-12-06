# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020 Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2020 351ELEC team (https://github.com/fewtarius/351ELEC)

PKG_NAME="ppsspp-ini"
PKG_VERSION="main"
#PKG_SHA256=""
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="CUSTOM"
PKG_SITE="https://github.com/jserodio/rg351p-ppsspp-settings"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="PPSSPPSDL"
PKG_SHORTDESC="PPSSPP INIs"
PKG_LONGDESC="A collection of PPSSPP INIs."
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  mkdir -p $INSTALL/usr/config/ppsspp/PSP/SYSTEM
  cp inis/351ELEC/*ini $INSTALL/usr/config/ppsspp/PSP/SYSTEM
}
