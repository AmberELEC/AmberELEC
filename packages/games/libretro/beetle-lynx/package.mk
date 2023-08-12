# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="beetle-lynx"
PKG_VERSION="fab3ac02d5622eb53a707bd392cc037282e9d8b4"
PKG_SHA256="7b03eecd23a25c9bc2aeef3e311c7ee6a76603eb5132f2b9cdbd2971e9199adc"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/beetle-lynx-libretro"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="libretro implementation of Mednafen Lynx"
PKG_TOOLCHAIN="make"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp mednafen_lynx_libretro.so ${INSTALL}/usr/lib/libretro/beetle_lynx_libretro.so
}
