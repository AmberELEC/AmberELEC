# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2024-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="textviewer"
PKG_VERSION="98bd622102d953d6aeec7c90fb7f2669aa664025"
PKG_LICENSE="MIT"
PKG_SITE="https://github.com/AmberELEC/TvTextViewer"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain SDL2 alsa-lib ${OPENGLES}"
PKG_LONGDESC="Full-screen text viewer tool with gamepad controls"
PKG_TOOLCHAIN="make"

pre_configure_target() {
  sed -i "s|\`sdl2-config|\`${SYSROOT_PREFIX}/usr/bin/sdl2-config|g" Makefile
  sed -i "s|-lGLESv2|-lGLESv2 -lasound -Wl,-rpath-link,${SYSROOT_PREFIX}/usr/lib|g" Makefile

  sed -i "s|^CXXFLAGS[ \t]*[:\?]*=.*|& -I${SYSROOT_PREFIX}/usr/include --sysroot=${SYSROOT_PREFIX}|" Makefile

  sed -i "s|-o text_viewer|--sysroot=${SYSROOT_PREFIX} -L${SYSROOT_PREFIX}/usr/lib -o text_viewer|g" Makefile
  sed -i "s|-o \$(EXE)|--sysroot=${SYSROOT_PREFIX} -L${SYSROOT_PREFIX}/usr/lib -o \$(EXE)|g" Makefile
}

make_target() {
  make DEVICE=${DEVICE} CXX="${CXX} --sysroot=${SYSROOT_PREFIX} -I${SYSROOT_PREFIX}/usr/include"
}

makeinstall_target(){
  mkdir -p ${INSTALL}/usr/bin
  cp text_viewer ${INSTALL}/usr/bin
}