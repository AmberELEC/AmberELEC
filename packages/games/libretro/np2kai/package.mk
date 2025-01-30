# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="np2kai"
PKG_VERSION="701092ac05e0714e7a6242f27a50f6090a6dcf16"
PKG_SHA256="e00ad51c525b76aadf914683723952caca5635f7f537ca451f8dc7573fa882f3"
PKG_LICENSE="MIT"
PKG_SITE="https://github.com/AZO234/NP2kai"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Neko Project II kai"
PKG_TOOLCHAIN="make"

make_target() {
  VERSION="${PKG_VERSION:0:7}"
  cd ${PKG_BUILD}/sdl
  make NP2KAI_VERSION=${VERSION} NP2KAI_HASH=${VERSION}
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp ${PKG_BUILD}/sdl/np2kai_libretro.so ${INSTALL}/usr/lib/libretro/
}
