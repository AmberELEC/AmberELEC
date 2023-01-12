# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="crocods"
PKG_VERSION="f1b4b91291ba1e8e7c0be02269cd0d75c7fa71b9"
PKG_SHA256="ff66ab18e6765aabdbde29eeaff4ee7acbe47f8433ca3f8b60ab015fdbd191e0"
PKG_LICENSE="MIT"
PKG_SITE="https://github.com/libretro/libretro-crocods"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Amstrad CPC emulator"
PKG_TOOLCHAIN="make"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp crocods_libretro.so ${INSTALL}/usr/lib/libretro/
}
