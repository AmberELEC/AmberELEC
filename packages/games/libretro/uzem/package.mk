# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="uzem"
PKG_VERSION="08e39e19167727c89fb995e3fa70dde252e6aab0"
PKG_SHA256="a0c84adb7db92826c4cf1c2175972e9d04932d7e88462351669f8ada37cb21bd"
PKG_LICENSE="MIT"
PKG_SITE="https://github.com/libretro/libretro-uzem"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_PATCH_DIRS="libretro"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A retro-minimalist game console engine for the ATMega644"
PKG_TOOLCHAIN="make"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp uzem_libretro.so ${INSTALL}/usr/lib/libretro/
}
