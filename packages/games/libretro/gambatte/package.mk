# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="gambatte"
PKG_VERSION="76c875138f6ffe1b1cf983b49758004cd53785ce"
PKG_SHA256="ce80cf909563ad0a94715f6be058fe553a06a78252c328c11448a334631582be"
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
