# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="dosbox-pure"
PKG_VERSION="7f6e8fb7385fa446d1444d671063268520bf9b54"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/schellingb/dosbox-pure"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A port of DOSBox to libretro"
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+pic"

pre_patch() {
  find $(echo "${PKG_BUILD}" | cut -f1 -d\ ) -type f -exec dos2unix -q {} \;
}

pre_configure_target() {
  sed -i 's|^LDFLAGS :=|LDFLAGS := -shared -fuse-ld=mold |g' Makefile 2>/dev/null || true
  sed -i 's|^LDFLAGS +=|LDFLAGS += -shared -fuse-ld=mold |g' Makefile 2>/dev/null || true
  sed -i 's|^SHARED :=.*|SHARED := -shared -fuse-ld=mold|g' Makefile 2>/dev/null || true
}

make_target() {
  local my_cxx="${CXX}"

  if [ -n "${CCACHE_DIR}" ] && [ -x "${TOOLCHAIN}/bin/ccache" ]; then
    my_cxx="${TOOLCHAIN}/bin/ccache ${CXX}"
  fi

  make platform=emuelec-hh \
       CC="${my_cxx}" \
       CXX="${my_cxx}" \
       LDFLAGS="${LDFLAGS} -shared -fuse-ld=mold" \
       EXTRA_LDFLAGS="${LDFLAGS} -shared -fuse-ld=mold" \
       SHARED="-shared -fuse-ld=mold" \
       ${MAKEFLAGS}
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp dosbox_pure_libretro.so ${INSTALL}/usr/lib/libretro/
}
