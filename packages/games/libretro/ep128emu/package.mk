# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="ep128emu"
PKG_VERSION="ad9a9db0e28389bcdf351adfd9bd313903bb3ad9"
PKG_SHA256="d77a024f11935e921db3b59cc50eee9625ff6bc273ea40cb7062182215a8a256"
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
