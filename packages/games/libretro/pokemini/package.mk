# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="pokemini"
PKG_VERSION="9ba2c2d98bef98794095f3ef50e22f1a3cbc6166"
PKG_SHA256="7dd450e5e26c9b66ce0811ec4eac125e71b6752951bdbf3851d0312d268c09c2"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/libretro/pokemini"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Obscure nintendo handheld emulator (functional,no color files or savestates currently)"
PKG_TOOLCHAIN="make"

if [[ "$DEVICE" == RG351P ]] || [[ "$DEVICE" == RG351V ]]; then
  PKG_PATCH_DIRS="rumble"
fi

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp pokemini_libretro.so $INSTALL/usr/lib/libretro/
}
