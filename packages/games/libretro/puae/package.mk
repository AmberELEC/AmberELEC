# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="puae"
PKG_VERSION="106b98d50dab4b5648067096f0ba54acbf713fd3"
PKG_SHA256="b66a3ead90086299104a3fecb70aca3bf7af467a5091a36bdc7017278140d032"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/libretro/libretro-uae"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="WIP libretro port of UAE (P-UAE and libco) Expect bugs"
PKG_TOOLCHAIN="make"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp puae_libretro.so ${INSTALL}/usr/lib/libretro/
}
