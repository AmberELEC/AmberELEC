# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="beetle-ngp"
PKG_VERSION="673c3d924ff33d71c6a342b170eff5359244df1f"
PKG_SHA256="0026c53bfa3a689be293ef228b83e108049c5952435344a921a353c946092638"
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
