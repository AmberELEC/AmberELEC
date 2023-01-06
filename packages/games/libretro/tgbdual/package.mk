# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="tgbdual"
PKG_VERSION="a6f3018e6a23030afc1873845ee54d4b2d8ec9d3"
PKG_SHA256="5df48cf8a8091cb68b5f21e90671cf27afaf2d0fcf35431093cccff0e4e95c7f"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/tgbdual-libretro"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="TGB Dual is an open source (GPLv2) GB/GBC emulator with game link cable support."
PKG_TOOLCHAIN="make"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp tgbdual_libretro.so ${INSTALL}/usr/lib/libretro/
}
