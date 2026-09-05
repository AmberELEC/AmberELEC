# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="a5200"
PKG_VERSION="40c6f2f1ad4a3145b328d5baaf010fae6c7e752b"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/libretro/a5200"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="a5200 - Port of Atari 5200 emulator for GCW0"
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+pic"

pre_configure_target() {
  sed -i 's|^LDFLAGS :=|LDFLAGS := -fuse-ld=mold |g' Makefile* 2>/dev/null || true
  sed -i 's|^LDFLAGS +=|LDFLAGS += -fuse-ld=mold |g' Makefile* 2>/dev/null || true
  sed -i 's|^SHARED :=.*|SHARED := -shared -fuse-ld=mold|g' Makefile* 2>/dev/null || true
}

make_target() {
  local my_cc="${CC}"
  local my_cxx="${CXX}"

  if [ -n "${CCACHE_DIR}" ] && [ -x "${TOOLCHAIN}/bin/ccache" ]; then
    my_cc="${TOOLCHAIN}/bin/ccache ${CC}"
    my_cxx="${TOOLCHAIN}/bin/ccache ${CXX}"
  fi

  make platform=unix \
       CC="${my_cc}" \
       CXX="${my_cxx}" \
       SHARED="-shared -fuse-ld=mold" \
       LDFLAGS="${LDFLAGS} -shared -fuse-ld=mold" \
       ${MAKEFLAGS}
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp a5200_libretro.so ${INSTALL}/usr/lib/libretro/
}
