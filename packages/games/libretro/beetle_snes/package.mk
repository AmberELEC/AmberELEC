# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2023-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="beetle_snes"
PKG_VERSION="08e5a8cc719859180891544517816093f4dbd40a"
PKG_SHA256="6d6d1506a7358ff643aa90491fbae645b9e64244bcaaf2cb3851bfa0f14cc068"
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
