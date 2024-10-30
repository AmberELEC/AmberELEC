# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="quicknes"
PKG_VERSION="dbf19f73e3eb9701d1c7f5898f57c097e05c9fbd"
PKG_SHA256="3a2e3c564156a7e18b15b8ac04fc5aa10da3f44d8253a073cc42fdd74a1a48de"
PKG_LICENSE="LGPLv2.1+"
PKG_SITE="https://github.com/libretro/QuickNES_Core"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="The QuickNES core library, originally by Shay Green, heavily modified"
PKG_TOOLCHAIN="make"

make_target() {
  VERSION='GIT_VERSION ?= '
  VERSION+=${PKG_VERSION:0:7}
  sed -i "s/GIT_VERSION ?= \" \$(shell git describe --dirty --always --tags)\"/${VERSION}/g" ${PKG_BUILD}/Makefile
  make
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp quicknes_libretro.so ${INSTALL}/usr/lib/libretro/
}
