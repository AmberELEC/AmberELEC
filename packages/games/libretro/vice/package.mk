# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="vice"
PKG_VERSION="d884b8125905551e2832b5eee524db74defc2e00"
PKG_SHA256="bcb9e014b58baff468c4782e89eece494833b4cc4a3c8096889042a972fddfa2"
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
