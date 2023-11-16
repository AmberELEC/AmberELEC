# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="snes9x"
PKG_VERSION="ec4ebfc8f3819a9522fcb8e53eed985090017b1b"
PKG_SHA256="0599dc74a5bac048134a3aaac3625d8e9a6fe7765a8388396353b70ac13a2607"
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
