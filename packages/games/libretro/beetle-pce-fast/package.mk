# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="beetle-pce-fast"
PKG_VERSION="ac1c49539a4b18449b3118835c52d606545bb87a"
PKG_SHA256="8725ed148933f563b94a30272afbe4a36391b29af5cd80d0f873ac15a448bc65"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/beetle-pce-fast-libretro"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Standalone port of Mednafen PCE Fast to libretro."
PKG_TOOLCHAIN="make"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp mednafen_pce_fast_libretro.so ${INSTALL}/usr/lib/libretro/beetle_pce_fast_libretro.so
}
