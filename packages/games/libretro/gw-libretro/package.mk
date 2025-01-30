# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="gw-libretro"
PKG_VERSION="435e5cfd4bf6aea03a84259e9b8dba3daf3ff5bd"
PKG_SHA256="610f613aedb6182b00bd4231e53d4350977b97e28f6f551cec138ef810cbb761"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/libretro/gw-libretro"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A libretro core for Game & Watch simulators "
PKG_TOOLCHAIN="make"

make_target() {
  make -f Makefile.libretro
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp gw_libretro.so ${INSTALL}/usr/lib/libretro/
}
