# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="stella"
PKG_VERSION="56e6bd69bc070f1d31e13610f1a7ebb1ca8bacbf"
PKG_SHA256="53291f7685ca4cd25450ed3177891dec370780051ce6d23a7d753da2a421db68"
PKG_LICENSE="GPL2"
PKG_SITE="https://github.com/stella-emu/stella"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Stella is a multi-platform Atari 2600 VCS emulator released under the GNU General Public License (GPL)."
PKG_TOOLCHAIN="make"

pre_configure_target() {
  PKG_MAKE_OPTS_TARGET=" -C ${PKG_BUILD}/src/os/libretro -f Makefile platform=emuelec-arm64"
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp ${PKG_BUILD}/src/os/libretro/stella_libretro.so ${INSTALL}/usr/lib/libretro/
}
