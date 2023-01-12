# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="351files"
PKG_VERSION="a7bb75dafca5c3f8e50e0f456b7ec249a69e1346"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/Tardigrade-nx/351Files"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain SDL2 SDL2_image SDL2_gfx SDL2_ttf"
PKG_LONGDESC="A Single panel file Manager tailored for Anbernic 351 devices: RG351V/MP and RG351P/M. Can be easily adapted to any Linux-based device."

if [ "${DEVICE}" = "RG552" ]; then
  PKG_PATCH_DIRS="RG552"
fi

make_target() {
  make DEVICE=${DEVICE} RES_PATH=/usr/share/351files/res START_PATH=/storage/roms SDL2_CONFIG=${SYSROOT_PREFIX}/usr/bin/sdl2-config CC=${CXX}
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/bin
  mkdir -p ${INSTALL}/usr/share/351files
  cp 351Files ${INSTALL}/usr/bin/
  cp -rf res ${INSTALL}/usr/share/351files/
}

