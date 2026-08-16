# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="mame2015"
PKG_VERSION="283e04b03c121db9be12632d6bad2fc3e8707248"
PKG_SHA256="8529bb074b1814c6577f928d852f4d443c4cdf1cd2a455c742f9ff2b339f8160"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/mame2015-libretro"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Late 2014/Early 2015 version of MAME (0.160-ish) for libretro. Compatible with MAME 0.160 romsets."
PKG_TOOLCHAIN="make"

PKG_MAKE_OPTS_TARGET="GIT_VERSION=${PKG_VERSION:0:7} platform=unix_armv"

pre_make_target() {
  export REALCC=${CC}
  export CC=${CXX}
  export LD=${CXX}
}

pre_configure_target() {
  sed -i 's/CCOMFLAGS += -mstructure-size-boundary=32//g' Makefile
  sed -i 's/-DSDLMAME_NO64BITIO//g' Makefile
  sed -i 's/LDFLAGS += -Wl,--fix-cortex-a8 -Wl,--no-as-needed//g' Makefile
  sed -i 's/"0.160"/"0.160 "/g' src/osd/retro/libretro.c
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp mame2015_libretro.so ${INSTALL}/usr/lib/libretro/
}
