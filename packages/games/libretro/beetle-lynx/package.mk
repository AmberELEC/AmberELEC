# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="beetle-lynx"
PKG_VERSION="d982616da671c3dd9c9271dd9d95c5c7d1393191"
PKG_SHA256="7e44d90ed7e3dbe1f923b5c7ac5e6e6aea060341dfe775ac2c71547928a3e4fc"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/beetle-lynx-libretro"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="libretro implementation of Mednafen Lynx"
PKG_TOOLCHAIN="make"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp mednafen_lynx_libretro.so ${INSTALL}/usr/lib/libretro/beetle_lynx_libretro.so
}
