# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="beetle-lynx"
PKG_VERSION="f88769ec9fdf02e7cd7bfa2e9b81627bbc537eb2"
PKG_SHA256="f6eff64a71bace02dd1f7017276c0112aa22279b6317f7faeafc1091fa0b8c6b"
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
