# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="ep128emu"
PKG_VERSION="0747110b5a98b4c36dc8784780f5ae436a94a1bd"
PKG_SHA256="5e559d10354522d6eb5934a8ca3a25d2ba6f82efd3d1efec47ff6b0176f181cb"
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
