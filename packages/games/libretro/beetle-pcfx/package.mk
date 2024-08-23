# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="beetle-pcfx"
PKG_VERSION="94541ff5bf9c474aa2923fed3afc4297678c9ede"
PKG_SHA256="3ba829a7472e0c34fd5cc53ee3d35bb2db6def70547919514933084919a9aae3"
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
