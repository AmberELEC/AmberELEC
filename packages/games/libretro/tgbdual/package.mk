# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="tgbdual"
PKG_VERSION="8d305769eebd67266c284558f9d3a30498894d3d"
PKG_SHA256="c9286b91fd7840902075601749507e08f9e734aae5a9ccc37805324a348295c5"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/tgbdual-libretro"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="TGB Dual is an open source (GPLv2) GB/GBC emulator with game link cable support."
PKG_TOOLCHAIN="make"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp tgbdual_libretro.so ${INSTALL}/usr/lib/libretro/
}
