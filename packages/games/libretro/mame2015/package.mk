# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="mame2015"
PKG_VERSION="2599c8aeaf84f62fe16ea00daa460a19298c121c"
PKG_SHA256="8f9a295f5d280130101c473e9754ec68ccbf45a1c1fe72d3405183ee6270b50d"
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
