# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="beetle-supergrafx"
PKG_VERSION="bd50eae63ef38f4ff6d61e8f3a782fdac6a3eeb3"
PKG_SHA256="e194b968e853b9787bc71eb2a7010be9f2a248d8990fee6a59c855c1be531b0f"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/beetle-supergrafx-libretro"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Standalone port of Mednafen PCE Fast to libretro."
PKG_TOOLCHAIN="make"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp mednafen_supergrafx_libretro.so ${INSTALL}/usr/lib/libretro/beetle_supergrafx_libretro.so
}
