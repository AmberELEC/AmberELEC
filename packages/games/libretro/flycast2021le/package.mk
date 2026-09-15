# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="flycast2021le"
PKG_VERSION="827b8b519d69b71684d31c123190976269fd7bc7"
PKG_SHA256="9d26bc35372ddc1cd087ff4bc0902c2d8c97663cd1bb5cfb56a75488553655de"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/navy1978/flycast2022-lowend"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain ${OPENGLES}"
PKG_LONGDESC="Performance-oriented Flycast 2021 fork for low-power ARM handhelds"
PKG_TOOLCHAIN="make"

pre_configure_target() {
  sed -i 's/\-O[23]//' ${PKG_BUILD}/Makefile
  sed -i 's/^CFLAGS[[:space:]]*:=[[:space:]]*//' ${PKG_BUILD}/Makefile
  sed -i 's/^CXXFLAGS[[:space:]]*:=[[:space:]]*//' ${PKG_BUILD}/Makefile
  sed -i 's/^LDFLAGS[[:space:]]*:=[[:space:]]*//' ${PKG_BUILD}/Makefile
  sed -i 's/define CORE_OPTION_NAME "reicast"/define CORE_OPTION_NAME "flycast2021"/g' core/libretro/libretro_core_option_defines.h
  sed -i 's/"Flycast"/"Flycast 2021 LE"/g' core/libretro/libretro.cpp
  sed -i 's/RETRO_PIXEL_FORMAT_XRGB8888/RETRO_PIXEL_FORMAT_RGB565/g' core/libretro/libretro.cpp
  export CFLAGS="${CFLAGS} -Wno-error=implicit-function-declaration"
}

make_target() {
  local my_cc="${CC}"
  local my_cxx="${CXX}"

  if [ -n "${CCACHE_DIR}" ] && [ -x "${TOOLCHAIN}/bin/ccache" ]; then
    my_cc="${TOOLCHAIN}/bin/ccache ${CC}"
    my_cxx="${TOOLCHAIN}/bin/ccache ${CXX}"
  fi

  export BUILD_SYSROOT="${SYSROOT_PREFIX}"

  make ARCH=arm \
       platform=arm64 \
       GIT_VERSION="${PKG_VERSION:0:7}" \
       CC="${my_cc}" \
       CXX="${my_cxx}" \
       SHARED="-shared" \
       LDFLAGS="${LDFLAGS}" \
       ${MAKEFLAGS}
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp flycast_libretro.so ${INSTALL}/usr/lib/libretro/flycast2021le_libretro.so
}
