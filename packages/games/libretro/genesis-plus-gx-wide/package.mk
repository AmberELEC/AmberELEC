# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="genesis-plus-gx-wide"
PKG_VERSION="b7d314220d755537aebb7bc1750ac21f764365c4"
PKG_SHA256="ffbf0ad2c669e03f4400e789a88c4b0c7546115425bfe2ace46bd1070a7774f2"
PKG_LICENSE="Non-commercial"
PKG_SITE="https://github.com/libretro/Genesis-Plus-GX-Wide"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Genesis Plus GX is an open-source & portable Sega Mega Drive / Genesis emulator, now also emulating SG-1000, Master System, Game Gear and Sega/Mega CD hardware."
PKG_TOOLCHAIN="make"

make_target() {
  if [ "${ARCH}" == "arm" ]; then
    CFLAGS="${CFLAGS} -DALIGN_LONG"
  fi
  make -f Makefile.libretro
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp genesis_plus_gx_wide_libretro.so ${INSTALL}/usr/lib/libretro/genesis_plus_gx_wide_libretro.so
}
