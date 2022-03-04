################################################################################
#
#  Copyright (C) 2020      351ELEC team (https://github.com/fewtarius/351ELEC)
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
################################################################################

PKG_NAME="gearboy"
PKG_VERSION="8427845c60eb99974fdce3535e7f80828fbf6818"
PKG_SHA256="08c384979c820361cf4eaefb648e88d5816866574167f15c5188d95e3920d7b0"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/drhelius/Gearboy"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="libretro"
PKG_SHORTDESC="Game Boy / Gameboy Color emulator for iOS, Mac, Raspberry Pi, Windows and Linux"
PKG_LONGDESC="Game Boy / Gameboy Color emulator for iOS, Mac, Raspberry Pi, Windows and Linux"

PKG_IS_ADDON="no"
PKG_TOOLCHAIN="make"
PKG_AUTORECONF="no"

make_target() {
  make -C platforms/libretro/
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp platforms/libretro/gearboy_libretro.so $INSTALL/usr/lib/libretro/
}
