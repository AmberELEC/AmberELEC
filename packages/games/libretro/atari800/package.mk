# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="atari800"
PKG_VERSION="cd721790a0aa0e0772810949abcf5bd699c15371"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/libretro/libretro-atari800"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="atari800 3.1.0 for libretro/libco WIP"
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+pic"

PKG_MAKE_OPTS_TARGET="platform=emuelec GIT_VERSION=${PKG_VERSION:0:7}"

pre_configure_target() {
  sed -i 's|^LDFLAGS :=|LDFLAGS := -fuse-ld=mold |g' Makefile* 2>/dev/null || true
  sed -i 's|^LDFLAGS +=|LDFLAGS += -fuse-ld=mold |g' Makefile* 2>/dev/null || true
  sed -i 's|^SHARED :=|SHARED := -fuse-ld=mold |g' Makefile* 2>/dev/null || true
}

make_target() {
  local my_cc="${CC}"
  local my_cxx="${CXX}"

  if [ -n "${CCACHE_DIR}" ] && [ -x "${TOOLCHAIN}/bin/ccache" ]; then
    my_cc="${TOOLCHAIN}/bin/ccache ${CC}"
    my_cxx="${TOOLCHAIN}/bin/ccache ${CXX}"
  fi

  make ${PKG_MAKE_OPTS_TARGET} \
       CC="${my_cc}" \
       CXX="${my_cxx}" \
       LDFLAGS="${LDFLAGS} -fuse-ld=mold" \
       SHARED="-shared -fuse-ld=mold" \
       ${MAKEFLAGS}
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp atari800_libretro.so ${INSTALL}/usr/lib/libretro/
}
