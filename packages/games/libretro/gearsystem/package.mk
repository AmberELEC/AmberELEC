# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="gearsystem"
PKG_VERSION="6b1b8d15e43096288346f05fdf9baa9f91360aaf"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/drhelius/Gearsystem"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Gearsystem is a Sega Master System / Game Gear / SG-1000 emulator written in C++"
PKG_TOOLCHAIN="make"

make_target() {
  make -C platforms/libretro/
}


makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp platforms/libretro/gearsystem_libretro.so ${INSTALL}/usr/lib/libretro/
}
