# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="stella"
PKG_VERSION="09be43c5060b7f23eeb413aa3d7a7021e9a6566c"
PKG_SHA256="2fb908c9ed73e7c21c211db92a60f07533f825cb5fc260b69c9782f903f435b6"
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
