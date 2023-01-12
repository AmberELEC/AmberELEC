# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="jstest-sdl"
PKG_VERSION="bdf1465c978204725c086c5a56bbcc0a7f7dda48"
PKG_LICENSE="MIT"
PKG_SITE="https://github.com/dhwz/jstest-sdl"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain SDL2 ncurses"
PKG_LONGDESC="Simple SDL joystick test application for the console"
PKG_TOOLCHAIN="make"

pre_configure_target() {
  sed -i "s|sdl2-config|${SYSROOT_PREFIX}/usr/bin/sdl2-config|g" Makefile
}

makeinstall_target(){
  mkdir -p ${INSTALL}/usr/bin
  cp jstest-sdl ${INSTALL}/usr/bin
}
