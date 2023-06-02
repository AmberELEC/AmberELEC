# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2023-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="uw8"
PKG_VERSION="5bc069d7971ca53d2b7594d46854994b6c7e78df"
PKG_SITE="https://github.com/libretro/uw8-libretro"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A libretro port of the microw8 fantasy console based on wasm3"
PKG_TOOLCHAIN="make"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp ${PKG_BUILD}/uw8_libretro.so ${INSTALL}/usr/lib/libretro/
}
