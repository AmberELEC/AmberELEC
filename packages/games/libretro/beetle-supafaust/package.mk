# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="beetle-supafaust"
PKG_VERSION="e25f66765938d33f9ad5850e8d6cd597e55b7299"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/supafaust"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Super Nintendo (Super Famicom) emulator"
PKG_TOOLCHAIN="make"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp ${PKG_BUILD}/mednafen_supafaust_libretro.so ${INSTALL}/usr/lib/libretro/beetle_supafaust_libretro.so
}
