# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="stella"
PKG_VERSION="9fec8afac8b0771065b767a09d7e7b5f92ba356a"
PKG_SHA256="a86348738e5dc29a91809fdee72a96d9d33133b0c298359c2d8feb96b878e9b3"
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
