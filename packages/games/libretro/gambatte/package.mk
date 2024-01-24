# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="gambatte"
PKG_VERSION="d0f2ec5b5c96cdfb2a56dc3b0758f75fefebb2cb"
PKG_SHA256="b55d0cee7fb0a8588e63fa52072464b52eb8bc6f864074e8c1f3dc151317338d"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/gambatte-libretro"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Gambatte is an open-source Game Boy Color emulator written for fun and made available in the hope that it will be useful."
PKG_TOOLCHAIN="make"

if [[ "${DEVICE}" == RG351P ]] || [[ "${DEVICE}" == RG351V ]]; then
  PKG_PATCH_DIRS="rumble"
fi

make_target() {
  make -f Makefile.libretro
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp gambatte_libretro.so ${INSTALL}/usr/lib/libretro/
}
