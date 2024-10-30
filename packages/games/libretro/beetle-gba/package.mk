# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="beetle-gba"
PKG_VERSION="6cee80685f735ea6c2373db2622a1f1ee9f39d39"
PKG_SHA256="33ef14eb0141e98323cc8c3e997f668df348fea7b7bf5a97766c2c91af075fa7"
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
