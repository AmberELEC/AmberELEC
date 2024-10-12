# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="uzem"
PKG_VERSION="bb06756a289f569810aac74691d6d585f9e70885"
PKG_SHA256="02e5dac6e0407d8ed0e3983531530da0208ebbe06554b0d3249182c1060dbd4a"
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
