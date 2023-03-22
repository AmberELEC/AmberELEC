# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="snes9x"
PKG_VERSION="ad89b7ac7ff04810b5e5cfb92bca8a222269234d"
PKG_SHA256="6be0349ed09daee9fd7ec6e7848e625af44e1823146896577ea3f6177d6abdc9"
PKG_LICENSE="Non-commercial"
PKG_SITE="https://github.com/libretro/snes9x"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Snes9x - Portable Super Nintendo Entertainment System (TM) emulator"
PKG_TOOLCHAIN="make"

make_target() {
  if [ "${ARCH}" == "arm" ]; then
    CXXFLAGS="${CXXFLAGS} -DARM"
  fi
  
  make -C libretro
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp libretro/snes9x_libretro.so ${INSTALL}/usr/lib/libretro/
}
