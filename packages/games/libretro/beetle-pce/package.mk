# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="beetle-pce"
PKG_VERSION="96a654ae2b2df1cc12dc7f1f2d1822db562aa51f"
PKG_SHA256="856e269a13b4d16d37c34d7ae069ea97a9ac152cfb268e346d6cbbf8ee826e9b"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/beetle-pce-libretro"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Standalone port of Mednafen PCE to libretro."
PKG_TOOLCHAIN="make"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp mednafen_pce_libretro.so ${INSTALL}/usr/lib/libretro/beetle_pce_libretro.so
}
