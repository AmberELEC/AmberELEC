# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="libretro-database"
PKG_VERSION="3e565a4ab4303c5cf50d143ebb81159d8cee640a"
PKG_SHA256="7db876d32e7f526d1ad28223d1b8840e8ad98f2bd270eecdfd7df02e93ee9ff3"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/libretro/libretro-database"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Repository containing cheatcode files, content data files, etc."
PKG_TOOLCHAIN="make"

configure_target() {
  cd ${PKG_BUILD}
}

makeinstall_target() {
  make install INSTALLDIR="${INSTALL}/usr/share/libretro-database"
}
