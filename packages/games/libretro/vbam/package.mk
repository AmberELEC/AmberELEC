# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="vbam"
PKG_VERSION="a2378f05f600a5a9cf450c60a87976b80d6a895a"
PKG_SHA256="c779acec7b5cc7f3d95b3489077ad372da738c0e02eb4bbaaa74c950ded5d68b"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/vbam-libretro"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="VBA-M is a [Super] Game Boy [Color / Advance] emulator for Windows, Linux & Mac."
PKG_TOOLCHAIN="make"

make_target() {
  make -C ../src/libretro -f Makefile
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp ../src/libretro/vbam_libretro.so ${INSTALL}/usr/lib/libretro/
}
