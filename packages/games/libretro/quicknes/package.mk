# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="quicknes"
PKG_VERSION="1b88a09f1c386ff9ee46bb371583ae04c5cb5dd0"
PKG_SHA256="c25fcaac32ee2263451705d737a95c2a607b96325a2eec6186e3d02b5b1e8ca6"
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
