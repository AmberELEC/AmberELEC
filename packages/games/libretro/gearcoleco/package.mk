################################################################################
#
#  Copyright (C) 2021-present AmberELEC (https://github.com/AmberELEC)
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

PKG_NAME="gearcoleco"
PKG_VERSION="7d2824f8344ebce41d79fe8dd9cb55b33e8089a8"
PKG_SHA256="c25b19b4630b1c5914bd17374e52ccb8a247b12ba0734d0616dbc2bc9c84cde8"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/drhelius/Gearcoleco"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Gearcoleco is a very accurate cross-platform ColecoVision emulator written in C++ that runs on Windows, macOS, Linux, BSD, Raspberry Pi and RetroArch."
PKG_TOOLCHAIN="make"

make_target() {
  make -C platforms/libretro/
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp platforms/libretro/gearcoleco_libretro.so ${INSTALL}/usr/lib/libretro/
}
