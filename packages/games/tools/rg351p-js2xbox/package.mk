# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="rg351p-js2xbox"
PKG_VERSION="5010b9b3734ea5741e359236a2b1a19f0d240bde"
PKG_ARCH="aarch64"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/christianhaitian/RG351P_virtual-gamepad"
PKG_URL="$PKG_SITE.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_TOOLCHAIN="make"
GET_HANDLER_SUPPORT="git"

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
  cp rg351p-js2xbox $INSTALL/usr/bin
}

