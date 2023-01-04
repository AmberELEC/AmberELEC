# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="wasm4"
PKG_VERSION="4cd1d4702e96a5a0dbeb88c38177830d38b11c71"
#PKG_ARCH="aarch64"
PKG_SITE="https://github.com/aduros/wasm4"
PKG_URL="$PKG_SITE.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="libretro"
PKG_SHORTDESC="WASM-4 is a low-level fantasy game console for building small games with WebAssembly"
PKG_TOOLCHAIN="cmake-make"

PKG_CMAKE_OPTS_TARGET="-DLIBRETRO=on -DCMAKE_BUILD_TYPE=Release"

pre_configure_target() {
  PKG_CMAKE_SCRIPT="$PKG_BUILD/runtimes/native/CMakeLists.txt"
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp $PKG_BUILD/wasm4_libretro.so $INSTALL/usr/lib/libretro/
}
