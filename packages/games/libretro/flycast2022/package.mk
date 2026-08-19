# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="flycast2022"
PKG_VERSION="f254ccf92d2eda240c1d3ae9df6a29caf13c648a"
PKG_SHA256="7e3af1ce94d3db311609d35fde94dec99ded60314e83af59e9f8a01d9ea5b615"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/navy1978/flycast2022-lowend"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain ${OPENGLES}"
PKG_LONGDESC="Performance-oriented Flycast 2022 fork for low-power ARM handhelds"
PKG_TOOLCHAIN="make"

pre_configure_target() {
  sed -i 's/\-O[23]//' ${PKG_BUILD}/Makefile
  sed -i 's/CFLAGS   :=//' ${PKG_BUILD}/Makefile
  sed -i 's/CXXFLAGS   :=//' ${PKG_BUILD}/Makefile
  sed -i 's/LDFLAGS   :=//' ${PKG_BUILD}/Makefile
  sed -i 's/define CORE_OPTION_NAME "reicast"/define CORE_OPTION_NAME "flycast2022"/g' core/libretro/libretro_core_option_defines.h
  sed -i 's/"Flycast"/"Flycast 2022 Low-End"/g' core/libretro/libretro.cpp
  sed -i 's/RETRO_PIXEL_FORMAT_XRGB8888/RETRO_PIXEL_FORMAT_RGB565/g' core/libretro/libretro.cpp
  PKG_MAKE_OPTS_TARGET="GIT_VERSION=${PKG_VERSION:0:7}"
  export CFLAGS="${CFLAGS} -Wno-error=implicit-function-declaration"
}

pre_make_target() {
  export BUILD_SYSROOT=${SYSROOT_PREFIX}
  PKG_MAKE_OPTS_TARGET+=" ARCH=arm platform=arm64"
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp flycast_libretro.so ${INSTALL}/usr/lib/libretro/flycast2022_libretro.so
}
