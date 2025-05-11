# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2019-present asakous (https://github.com/asakous)

PKG_NAME="quasi88"
PKG_VERSION="42be798db5585f62b4bd34ce49dd1e8063c9d7c1"
PKG_LICENSE="BSD3"
PKG_SITE="https://github.com/libretro/quasi88-libretro"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A port of QUASI88, a PC-8800 series emulator by Showzoh Fukunaga, to the libretro API"
PKG_TOOLCHAIN="make"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp quasi88_libretro.so ${INSTALL}/usr/lib/libretro/
}
