# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2023-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="beetle_snes"
PKG_VERSION="f7bfa217cf7150779902c3a998f7624d92a5f17d"
PKG_SHA256="a299383932e35d5030145e14c7fbab57ba6e1fa81e00c866b1bdcbc70bfac1c6"
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
