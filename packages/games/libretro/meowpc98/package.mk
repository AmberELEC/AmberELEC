# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="meowpc98"
PKG_VERSION="dc905d4e10470ff65a38e8b9e1a75b43b9b12149"
PKG_SHA256="1d0e528fdccaa533a54529975a1b298f63fb52c338a8208dd34a6f7f35b20039"
PKG_LICENSE="Unknown"
PKG_SITE="https://github.com/libretro/libretro-meowPC98"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Neko Project 2 (PC98 emulator) port for libretro/RetroArch"
PKG_TOOLCHAIN="make"

make_target() {
  make -C libretro -f Makefile.libretro
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp libretro/nekop2_libretro.so ${INSTALL}/usr/lib/libretro/
}
