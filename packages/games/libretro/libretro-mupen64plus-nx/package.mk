# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Fewtarius

PKG_NAME="libretro-mupen64plus-nx"
PKG_VERSION="1b80c7616da42df6365f731e801a38e2db9aea29"
#PKG_SHA256=""
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
  
if [ "$DEVICE" == "RG351P" ]; then 
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
