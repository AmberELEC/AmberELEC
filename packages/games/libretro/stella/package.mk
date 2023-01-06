# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="stella"
PKG_VERSION="265a090cc18bb11fa4ca66560dde143bb1088cc7"
PKG_SHA256="50f0a40864279f0d679c2dbe745b85cc07f0582291b46916d7f583d92674b19a"
PKG_LICENSE="GPL2"
PKG_SITE="https://github.com/stella-emu/stella"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Stella is a multi-platform Atari 2600 VCS emulator released under the GNU General Public License (GPL)."
PKG_TOOLCHAIN="make"

pre_configure_target() {
  PKG_MAKE_OPTS_TARGET=" -C $PKG_BUILD/src/os/libretro -f Makefile platform=emuelec-arm64"
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp $PKG_BUILD/src/os/libretro/stella_libretro.so $INSTALL/usr/lib/libretro/
}
