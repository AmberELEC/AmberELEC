# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="vice"
PKG_VERSION="099ddc95da816d78b22f361dce081e5e2019ad5a"
PKG_SHA256="ddc5e66b868ef3f77e87db6c2aa62cff6f18e5020c8b2c4a73dc35696af677a5"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/vice-libretro"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Versatile Commodore 8-bit Emulator version 3.0"
PKG_TOOLCHAIN="make"

make_target() {
  if [ "${ARCH}" == "arm" ]; then
    CFLAGS="${CFLAGS} -DARM -DALIGN_DWORD -mstructure-size-boundary=32 -mthumb-interwork -falign-functions=16 -marm"
  fi
  if [ ! -d "built" ]
  then
    mkdir built
  fi
  for EMUTYPE in x128 x64sc x64dtv xscpu64 xplus4 xvic xcbm5x0 xcbm2 xpet x64
  do
    make clean
    make EMUTYPE=${EMUTYPE}
    mv vice_*_libretro.so built
  done
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp built/vice_x128_libretro.so ${INSTALL}/usr/lib/libretro/
  cp built/vice_x64_libretro.so ${INSTALL}/usr/lib/libretro/
  cp built/vice_xplus4_libretro.so ${INSTALL}/usr/lib/libretro/
  cp built/vice_xvic_libretro.so ${INSTALL}/usr/lib/libretro/
}
