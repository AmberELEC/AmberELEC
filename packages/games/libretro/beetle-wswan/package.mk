# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="beetle-wswan"
PKG_VERSION="4e73cf52d5223105a8ac175f4332d609364fb5f9"
PKG_SHA256="8a8742b339981a23b0da6e7b8074c3a84a5ce305e0ec55a600f1e780e77d38b2"
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
