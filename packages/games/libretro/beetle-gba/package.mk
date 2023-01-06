# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="beetle-gba"
PKG_VERSION="38182572571a48cb58057cde64b915237c4e2d58"
PKG_SHA256="e4eaf64e9160b501cadf983a46b8a2a98c8b590a13ca9082793d9a11e17fdcaf"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/beetle-gba-libretro"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="libretro implementation of Mednafen VBA/GBA. (Game Boy Advance)"
PKG_TOOLCHAIN="make"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp mednafen_gba_libretro.so ${INSTALL}/usr/lib/libretro/beetle_gba_libretro.so
}
