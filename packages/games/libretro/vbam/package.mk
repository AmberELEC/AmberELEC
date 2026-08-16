# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="vbam"
PKG_VERSION="e8b2875d6cad10fc3c7c9f57bb5f1acc324d7c10"
PKG_SHA256="5fb643271c028b65627ac4b391ab7aa9178e17bd2d5583c40d2c38646878b0fa"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/vbam-libretro"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="VBA-M is a [Super] Game Boy [Color / Advance] emulator for Windows, Linux & Mac."
PKG_TOOLCHAIN="make"

make_target() {
  make -C ../src/libretro -f Makefile
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp ../src/libretro/vbam_libretro.so ${INSTALL}/usr/lib/libretro/
}
