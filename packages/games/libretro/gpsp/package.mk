# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="gpsp"
PKG_VERSION="5b6e751f4abf368509146cd143c949c1946ac1ae"
PKG_SHA256="3145b3397d2cbfbad1637cf8a737120c14661127c59cd2735ff249b1aaec14fb"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/gpsp"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="gameplaySP is a Gameboy Advance emulator for Playstation Portable"
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+pic"

pre_configure_target() {
  sed -i 's|^LDFLAGS :=|LDFLAGS := -shared -fuse-ld=mold |g' Makefile 2>/dev/null || true
  sed -i 's|^LDFLAGS +=|LDFLAGS += -shared -fuse-ld=mold |g' Makefile 2>/dev/null || true
  sed -i 's|^SHARED :=.*|SHARED := -shared -fuse-ld=mold|g' Makefile 2>/dev/null || true
}

make_target() {
  local my_cc="${CC}"
  local my_cxx="${CXX}"

  if [ -n "${CCACHE_DIR}" ] && [ -x "${TOOLCHAIN}/bin/ccache" ]; then
    my_cc="${TOOLCHAIN}/bin/ccache ${CC}"
    my_cxx="${TOOLCHAIN}/bin/ccache ${CXX}"
  fi

  make platform=arm64 \
       CC="${my_cc}" \
       CXX="${my_cxx}" \
       SHARED="-shared -fuse-ld=mold" \
       LDFLAGS="${LDFLAGS} -shared -fuse-ld=mold" \
       ${MAKEFLAGS}
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp gpsp_libretro.so ${INSTALL}/usr/lib/libretro/
}
