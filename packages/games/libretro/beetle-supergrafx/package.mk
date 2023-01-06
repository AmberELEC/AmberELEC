# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="beetle-supergrafx"
PKG_VERSION="7c435d6d83ce54eb2782df75c05acd9f4eac6f34"
PKG_SHA256="d85f8aed67f58a0ea89f960cd7868ed97d0893365627923d2edcbd52a7ae3b47"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/beetle-supergrafx-libretro"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Standalone port of Mednafen PCE Fast to libretro."
PKG_TOOLCHAIN="make"

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp mednafen_supergrafx_libretro.so $INSTALL/usr/lib/libretro/beetle_supergrafx_libretro.so
}
