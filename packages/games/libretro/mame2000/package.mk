# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="mame2000"
PKG_VERSION="905808fbcc3adf8c610c1c60f0e41ce4b35db1c5"
PKG_SHA256="7386a469086b7da90565e97f52e6ef02264a54262c82983dd1948ddef9bd4e63"
PKG_LICENSE="MAME"
PKG_SITE="https://github.com/libretro/mame2000-libretro"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="MAME - Multiple Arcade Machine Emulator"
PKG_TOOLCHAIN="make"

make_target() {
  make WANT_LIBCO=0
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp mame2000_libretro.so ${INSTALL}/usr/lib/libretro/
}