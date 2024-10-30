# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="beetle-ngp"
PKG_VERSION="139fe34c8dfc5585d6ee1793a7902bca79d544de"
PKG_SHA256="5f0122405b18e0a95f4a5da2ef2f57b4bf1895a691370e65cc19fd5854a50412"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/beetle-ngp-libretro"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="libretro implementation of Mednafen Neo Geo Pocket."
PKG_TOOLCHAIN="make"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp mednafen_ngp_libretro.so ${INSTALL}/usr/lib/libretro/beetle_ngp_libretro.so
}
