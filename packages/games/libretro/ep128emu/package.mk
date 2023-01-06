# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="ep128emu"
PKG_VERSION="3e9554dd5011ac30e81fcae3a624a9ef3394f2cf"
PKG_SHA256="51c67854f3bd6f4bd23284a95ed1fb284c6b46d727294a6b1a0db4d07e9bc6ce"
PKG_ARCH="aarch64"
PKG_SITE="https://github.com/libretro/ep128emu-core"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Libretro core version of ep128emu"
PKG_TOOLCHAIN="make"

PKG_MAKE_OPTS_TARGET="-C . platform=unix"

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp $PKG_BUILD/ep128emu_core_libretro.so $INSTALL/usr/lib/libretro/
}
