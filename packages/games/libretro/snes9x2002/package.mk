# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="snes9x2002"
PKG_VERSION="540baad622d9833bba7e0696193cb06f5f02f564"
PKG_SHA256="07f0e54c61b2608480157a2259dfa7aba2ff3e746935b3b51068b0f69d67d289"
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
