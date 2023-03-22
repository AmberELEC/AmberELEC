# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="beetle-ngp"
PKG_VERSION="65460e3a9ad529f6901caf669abbda11f437ab55"
PKG_SHA256="2d866f6be840b5cbcf6c4159b860d8cb0dffd00c540d230c98de48941d12c38e"
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
