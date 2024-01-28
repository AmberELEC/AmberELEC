# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="beetle-pce"
PKG_VERSION="981ba264da3b6d67ea519e93dd231e5738d8b0f5"
PKG_SHA256="68a1b54fd3b1efc02f9219caba5ebf11c74c41908860c377c0a425acc86a0ea8"
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
