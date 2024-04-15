# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2024-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="textviewer"
PKG_VERSION="98bd622102d953d6aeec7c90fb7f2669aa664025"
PKG_LICENSE="MIT"
PKG_SITE="https://github.com/AmberELEC/TvTextViewer"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Full-screen text viewer tool with gamepad controls"
PKG_TOOLCHAIN="make"

pre_configure_target() {
  sed -i "s|\`sdl2-config|\`${SYSROOT_PREFIX}/usr/bin/sdl2-config|g" Makefile
}

make_target() {
  make DEVICE=${DEVICE}
}

makeinstall_target(){
  mkdir -p ${INSTALL}/usr/bin
  cp text_viewer ${INSTALL}/usr/bin
}
