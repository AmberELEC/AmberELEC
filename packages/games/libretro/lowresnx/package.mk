# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="lowresnx"
PKG_VERSION="c824ec163a1945cc48e4319054c7eb1024667497"
#PKG_ARCH="aarch64"
PKG_SITE="https://github.com/timoinutilis/lowres-nx"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A simulated retro game console, which can be programmed in the classic BASIC language"
PKG_TOOLCHAIN="make"

PKG_MAKE_OPTS_TARGET="-C platform/LibRetro"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp ${PKG_BUILD}/platform/LibRetro/lowresnx_libretro.so ${INSTALL}/usr/lib/libretro/
}
