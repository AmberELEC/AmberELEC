# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="flycast2022"
PKG_VERSION="1ca39aea8599a5cacaff41a1ba44ed849b6f96ef"
PKG_SHA256="abe47f6ddf0d0e5beb88c09e2fb4e4d586ba507d2c32ee5ab0bd82aee6d3d0d5"
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
}

pre_make_target() {
  export BUILD_SYSROOT=${SYSROOT_PREFIX}
  PKG_MAKE_OPTS_TARGET+=" ARCH=arm platform=arm64"
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp flycast_libretro.so ${INSTALL}/usr/lib/libretro/flycast2022_libretro.so
}
