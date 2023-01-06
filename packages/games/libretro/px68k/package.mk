# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="px68k"
PKG_VERSION="84a982f966a015bb6e9bae5f3fd756c3a3fa3369"
PKG_SHA256="8e277f232eee561cdebef2c9155774949217824d5ddac65f6a0f081860233936"
PKG_LICENSE="Unknown"
PKG_SITE="https://github.com/libretro/px68k-libretro"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Portable SHARP X68000 Emulator for PSP, Android and other platforms"
PKG_TOOLCHAIN="make"

if [[ "$DEVICE" == RG351P ]] || [[ "$DEVICE" == RG351V ]]; then
  PKG_PATCH_DIRS="rumble"
fi

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp px68k_libretro.so $INSTALL/usr/lib/libretro/
}
