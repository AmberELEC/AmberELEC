################################################################################
#
#  Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)
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
PKG_VERSION="c495e6a66f2082d9100d9980554403f4e81641bf"
PKG_SHA256="fa46aaf80452a6fbb4f3c90b4ca9fb58d07ccb6c412461d6c4943b715298516b"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/drhelius/Gearboy"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Game Boy / Gameboy Color emulator for iOS, Mac, Raspberry Pi, Windows and Linux"
PKG_TOOLCHAIN="make"

make_target() {
  make -C platforms/libretro/
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp platforms/libretro/gearboy_libretro.so ${INSTALL}/usr/lib/libretro/
}
