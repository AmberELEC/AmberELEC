# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2023-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="beetle_snes"
PKG_VERSION="d770563fc3c4bd9abb522952cefb4aa923ba0b91"
PKG_SHA256="838693257f9c8924c62ec6d88891fbeca310ac2fd7b8efa3d96775c3b34d4040"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/beetle-bsnes-libretro"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Standalone port of Mednafen bSNES to libretro, itself a fork of bsnes 0.59."
PKG_TOOLCHAIN="make"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp mednafen_snes_libretro.so ${INSTALL}/usr/lib/libretro/beetle_snes_libretro.so
}
