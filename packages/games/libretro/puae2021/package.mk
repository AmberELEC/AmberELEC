# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="puae2021"
PKG_VERSION="f50f4f2ae506a22529a9935c4b45f375401021c9"
PKG_SHA256="f2e6d7e56ce83755d0e48f84d734f8caa63c7c67b0ea0adb49b7e7788714f23f"
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
