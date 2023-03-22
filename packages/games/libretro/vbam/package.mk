# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="vbam"
PKG_VERSION="640ce45325694d1dc574e90c95c55bc464368d7e"
PKG_SHA256="a813978dd749378813dbf4a68d821ba529ca1f031ddb8a2d695472b8e9847bde"
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
