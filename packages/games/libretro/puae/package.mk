# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="puae"
PKG_VERSION="fad7beb42c90a1a04829d465bed951a69cd36f8b"
PKG_SHA256="eab622ea0d1017d4db5c19eba696b52a419e6d861292f2bea0e0fb9bff9ffb9f"
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
