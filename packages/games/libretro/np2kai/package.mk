# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="np2kai"
PKG_VERSION="2ca8e7ebc4e56c006aee38312782069fccbd910e"
PKG_SHA256="3f2d9b7e60d27f0089a400760a9e54c5fe1a5c7e547f47656d9df42a9194d1e4"
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
