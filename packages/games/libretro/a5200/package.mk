# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2022-present 351ELEC (https://github.com/351ELEC)

PKG_NAME="a5200"
PKG_VERSION="7eee43299d0abe28828dee2b86f100b066391866"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/libretro/a5200"
PKG_URL="$PKG_SITE.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="libretro"
PKG_SHORTDESC="a5200 - Port of Atari 5200 emulator for GCW0"
PKG_LONGDESC="a5200 - Port of Atari 5200 emulator for GCW0"

PKG_IS_ADDON="no"
PKG_TOOLCHAIN="make"
PKG_AUTORECONF="no"

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp a5200_libretro.so $INSTALL/usr/lib/libretro/
}
