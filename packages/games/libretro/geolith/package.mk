# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="geolith"
PKG_VERSION="d8f7a87376ab614d464d46ee408d29b2dec163ff"
PKG_LICENSE="BSD-3c"
PKG_SITE="https://github.com/libretro/geolith-libretro"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Highly accurate emulator for the Neo Geo AES and MVS Cartridge Systems"
PKG_TOOLCHAIN="make"

make_target() {
  sed -i 's/\-O[23]//' libretro/Makefile
  make -C libretro
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp ${PKG_BUILD}/libretro/geolith_libretro.so ${INSTALL}/usr/lib/libretro
}