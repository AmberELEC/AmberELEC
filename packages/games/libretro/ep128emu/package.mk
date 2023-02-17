# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="ep128emu"
PKG_VERSION="121c43024a42d0d6c3a4505ff960577eaa0f54e2"
PKG_SHA256="a67dc0135fd652c7c57bbf57c356b204ac06a857922535ef1dc8a676c0994622"
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
