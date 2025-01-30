# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="snes9x2002"
PKG_VERSION="a0709ec7dcd6de2fbebb43106bd757b649e3b7cf"
PKG_SHA256="58abd84309d0fafacccd94920aa4b99eeb935c4157971487c1052b6104de2412"
PKG_LICENSE="Non-commercial"
PKG_SITE="https://github.com/libretro/snes9x2002"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Snes9x 2002. Port of SNES9x 1.39 for libretro (was previously called PocketSNES). Heavily optimized for ARM."
PKG_TOOLCHAIN="make"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp snes9x2002_libretro.so ${INSTALL}/usr/lib/libretro/
}
