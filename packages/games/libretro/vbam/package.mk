# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="vbam"
PKG_VERSION="b5a4788747fa46afe681080db758f4a827ff7274"
PKG_SHA256="645e9f1ebc7bbca5c54221ea8dca10672bb2991820420692abc1e034da949e1f"
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
