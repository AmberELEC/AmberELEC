# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="ep128emu"
PKG_VERSION="6af5d03de220e6effcd0ffcd99e0fb8e8c77cc9e"
PKG_SHA256="0804127ebc3e7129bdc1833d3644595b95970a8b4830efdd9b05afbfb57381cd"
PKG_ARCH="aarch64"
PKG_SITE="https://github.com/libretro/ep128emu-core"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Libretro core version of ep128emu"
PKG_TOOLCHAIN="make"

PKG_MAKE_OPTS_TARGET="-C . platform=unix"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp ${PKG_BUILD}/ep128emu_core_libretro.so ${INSTALL}/usr/lib/libretro/
}
