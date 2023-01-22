# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="beetle-pcfx"
PKG_VERSION="45fa33f020e245f7681fc061b63064ec5bbf73c1"
PKG_SHA256="8c8dc8250d51248855b6b5bf17d6b2d0889d8ba71b18cc05f53bb222ea6bb86f"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/beetle-pcfx-libretro"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="libretro implementation of Mednafen PC-FX."
PKG_TOOLCHAIN="make"

make_target() {
  if [ "${ARCH}" == "i386" -o "${ARCH}" == "x86_64" ]; then
    make platform=unix CC=${CC} CXX=${CXX} AR=${AR}
  else
    make platform=armv CC=${CC} CXX=${CXX} AR=${AR}
  fi
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp mednafen_pcfx_libretro.so ${INSTALL}/usr/lib/libretro/beetle_pcfx_libretro.so
}
