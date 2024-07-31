# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="snes9x2005_plus"
PKG_VERSION="285220ed696ec661ce5c42856e033a1586fda967"
PKG_SHA256="2718e309b81a93ee2884bcc0c468907007e07e3990382b5e4e57d32ab7a82f2b"
PKG_LICENSE="Non-commercial"
PKG_SITE="https://github.com/libretro/snes9x2005"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Snes9x 2005 Plus. Port of SNES9x 1.43 for libretro (was previously called CAT SFC) with enabled BLARRG APU."
PKG_TOOLCHAIN="make"

PKG_MAKE_OPTS_TARGET="USE_BLARGG_APU=1 platform=armv8-hardfloat-neon"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp snes9x2005_plus_libretro.so ${INSTALL}/usr/lib/libretro/
}
