# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="beetle-pce"
PKG_VERSION="cdc1e2783847b6b98d17802d523505a3c2111d6b"
PKG_SHA256="7773fc3392bdd237ed7fd9fc02a7a99d189cff95d46cf4303e43b5d6f4b11a23"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/beetle-pce-libretro"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Standalone port of Mednafen PCE to libretro."
PKG_TOOLCHAIN="make"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp mednafen_pce_libretro.so ${INSTALL}/usr/lib/libretro/beetle_pce_libretro.so
}
