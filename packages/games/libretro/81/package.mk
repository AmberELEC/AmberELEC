# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="81"
PKG_VERSION="525d5c18f1ff3fc54c37e083a475225d9179d59d"
PKG_SHA256="e4611e88159e3a77efe3b029f9edfa40127e98cb8af0e1a9d320cc4d3d137708"
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
