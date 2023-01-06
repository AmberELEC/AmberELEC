# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="beetle-ngp"
PKG_VERSION="00c7cb8ea97ad9a372307405d8abf34e401fec8a"
PKG_SHA256="c7b24f77606c81818af335377ebedb09da344546c19092e3afe47954c8a4f2f2"
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
