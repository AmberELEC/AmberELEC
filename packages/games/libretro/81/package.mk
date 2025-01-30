# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="81"
PKG_VERSION="ffc99f27f092addc9ddd34dd0e3a3d4d1c053cbf"
PKG_SHA256="3db0e494cbd2afcc511cd7ba0e5eda104871301e26a74254bf4a08356d567181"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/libretro/81-libretro"
PKG_URL="https://github.com/libretro/81-libretro/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A port of the EightyOne ZX81 Emulator to libretro"
PKG_TOOLCHAIN="make"

make_target() {
  make -f Makefile.libretro
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp 81_libretro.so ${INSTALL}/usr/lib/libretro/
}
