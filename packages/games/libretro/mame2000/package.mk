# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="mame2000"
PKG_VERSION="0208517404e841fce0c094f1a2776a0e1c6c101d"
PKG_SHA256="7981c04b3efb9a3c4d31cb05c56745b729da0aea01f0b2543ee9e25a2c53aced"
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