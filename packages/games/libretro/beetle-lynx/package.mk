# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="beetle-lynx"
PKG_VERSION="fc1288ccc0a4c6c07d690e0f0f5e883b43c20ba4"
PKG_SHA256="fda851d729340e7247db122496af3218a49df1c6ebd6f91050aa22c02cae2510"
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
