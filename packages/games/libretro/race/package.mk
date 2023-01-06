# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="race"
PKG_VERSION="cb002043c65276dac592ed0214ae8a6bba82e2b1"
PKG_SHA256="0f00e2cf57b84ceb2ea7e819b49c8afd01bae8e09a64188c5783ea7b8b03cd50"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/RACE"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="This is the RACE NGPC emulator modified by theelf to run on the PSP."
PKG_TOOLCHAIN="make"

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp race_libretro.so $INSTALL/usr/lib/libretro/
}