# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Fewtarius

PKG_NAME="libretro-mupen64plus-nx"
PKG_VERSION="a6a6bfd56c8a8d6077182c280bf9eb33c7fba0e8"
PKG_SHA256="1c6cef039f6ad872d8cea332810fe5ba783ab59384580dfe200180b87e00aa49"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/mupen64plus-libretro-nx"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain nasm:host $OPENGLES"
PKG_SECTION="libretro"
PKG_SHORTDESC="mupen64plus NX"
PKG_LONGDESC="mupen64plus NX"
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="-lto"

pre_configure_target() {
  
if [[ "$DEVICE" =~ RG351 ]]; then 
  if [[ "$ARCH" == "arm" ]]; then
	CFLAGS="$CFLAGS -DLINUX -DEGL_API_FB"
	CPPFLAGS="$CPPFLAGS -DLINUX -DEGL_API_FB"
	PKG_MAKE_OPTS_TARGET=" platform=unix board=ODROIDGOA GLES=1 FORCE_GLES=1 HAVE_NEON=1 WITH_DYNAREC=arm"
  else 
	CFLAGS="$CFLAGS -DLINUX -DEGL_API_FB"
	CPPFLAGS="$CPPFLAGS -DLINUX -DEGL_API_FB"
	PKG_MAKE_OPTS_TARGET=" platform=unix board=ODROIDGOA GLES=1 FORCE_GLES=1 HAVE_NEON=0 WITH_DYNAREC=aarch64"
  fi
fi
  
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp mupen64plus_next_libretro.so $INSTALL/usr/lib/libretro/
}
