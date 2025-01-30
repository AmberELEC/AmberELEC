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
PKG_VERSION="ccbb6cdff77d90536811c892c32180652cb12123"
PKG_SHA256="0441d15d7cdda1b05797ae58b84c3432b9c8e6ddf38fb73bfa9e4a3c3e0126de"
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
