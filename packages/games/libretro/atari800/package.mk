# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="atari800"
PKG_VERSION="50141a6bf1a069abd86dd8c53aa4031f3f7cfbd1"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/libretro/libretro-atari800"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="atari800 3.1.0 for libretro/libco WIP"
PKG_TOOLCHAIN="auto"


PKG_MAKE_OPTS_TARGET="platform=emuelec GIT_VERSION=${PKG_VERSION:0:7}"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp atari800_libretro.so ${INSTALL}/usr/lib/libretro/
}
