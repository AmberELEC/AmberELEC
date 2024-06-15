# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="puae2021"
PKG_VERSION="075d8e30877e45e2c8a7790f5f70fd0569f96870"
PKG_SHA256="e60e153c9c60d1fa6805b3202cd6e45a93ab9ebde0d6d9392f5fcb222ca40e87"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/libretro/libretro-uae"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="WIP libretro port of UAE (P-UAE and libco) Expect bugs"
PKG_TOOLCHAIN="make"
PKG_GIT_CLONE_BRANCH="2.6.1"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp puae2021_libretro.so ${INSTALL}/usr/lib/libretro/
}
