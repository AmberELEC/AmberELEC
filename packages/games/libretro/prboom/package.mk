# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="prboom"
PKG_VERSION="9d412db570d3291829b308e6d1ac17f04acdda17"
PKG_SHA256="b35d22a0a0e4e969cb7d40c52967fa58304e0deccf0c410da3384144527f6dbf"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/libretro-prboom"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="libretro implementation of Doom"
PKG_TOOLCHAIN="make"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp prboom_libretro.so ${INSTALL}/usr/lib/libretro/prboom_libretro.so
}
