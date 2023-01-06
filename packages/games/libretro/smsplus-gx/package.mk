# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="smsplus-gx"
PKG_VERSION="60af17ddb2231ba98f4ed1203e2a2f58d08ea088"
PKG_SHA256="98cea00a0865e4e68b4dfd24b38d370f47839505d119232afe65c5df9feff2cf"
PKG_LICENSE="Non-commercial"
PKG_SITE="https://github.com/libretro/smsplus-gx"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="SMS Plus is an open-source Sega Master System and Game Gear emulator written by Charles MacDonald."
PKG_TOOLCHAIN="make"

make_target() {
  if [ "${ARCH}" == "arm" ]; then
    CFLAGS="${CFLAGS} -DALIGN_LONG"
  fi
  make -f Makefile.libretro
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp smsplus_libretro.so ${INSTALL}/usr/lib/libretro/
}
