# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="beetle-wswan"
PKG_VERSION="c9b3777471c74090df096c2ef65d2fc3ab40e018"
PKG_SHA256="29cf28e60422e9b3126e938dec3b04998859d9f49d6457b9f92b885636a026a5"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/beetle-wswan-libretro"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="libretro implementation of Mednafen wswan"
PKG_TOOLCHAIN="make"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp mednafen_wswan_libretro.so ${INSTALL}/usr/lib/libretro/beetle_wswan_libretro.so
}
