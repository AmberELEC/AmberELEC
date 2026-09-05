# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="scummvm"
PKG_VERSION="58f8f79224d3c9a0b99dd78fc41f8d69fd6ced89"
PKG_SHA256="c753d6d51c81da8c08dbf348eb6f60f9465175c5127cab70208fd6567042e79a"
PKG_LICENSE="GPL2"
PKG_SITE="https://github.com/scummvm/scummvm"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="ScummVM is a program which allows you to run certain classic graphical point-and-click adventure games, provided you already have their data files."
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+pic"

pre_configure_target() {
  sed -i 's|^LDFLAGS :=|LDFLAGS := -fuse-ld=mold |g' ${PKG_BUILD}/backends/platform/libretro/Makefile* 2>/dev/null || true
  sed -i 's|^LDFLAGS +=|LDFLAGS += -fuse-ld=mold |g' ${PKG_BUILD}/backends/platform/libretro/Makefile* 2>/dev/null || true
  sed -i 's|^SHARED :=.*|SHARED := -shared -fuse-ld=mold|g' ${PKG_BUILD}/backends/platform/libretro/Makefile* 2>/dev/null || true
}

make_target() {
  local my_cc="${CC}"
  local my_cxx="${CXX}"

  if [ -n "${CCACHE_DIR}" ] && [ -x "${TOOLCHAIN}/bin/ccache" ]; then
    my_cc="${TOOLCHAIN}/bin/ccache ${CC}"
    my_cxx="${TOOLCHAIN}/bin/ccache ${CXX}"
  fi

  make -C ${PKG_BUILD}/backends/platform/libretro all \
       CC="${my_cc}" \
       CXX="${my_cxx}" \
       SHARED="-shared -fuse-ld=mold" \
       LDFLAGS="${LDFLAGS} -shared -fuse-ld=mold" \
       ${MAKEFLAGS}
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp ${PKG_BUILD}/backends/platform/libretro/scummvm_libretro.so ${INSTALL}/usr/lib/libretro/
  mkdir -p ${INSTALL}/usr/share/scummvm
  unzip -o ${PKG_BUILD}/backends/platform/libretro/scummvm.zip -d ${INSTALL}/usr/share/
}
