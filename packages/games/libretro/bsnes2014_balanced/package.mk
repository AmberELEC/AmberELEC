# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2023-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="bsnes2014_balanced"
PKG_VERSION="78dc66f8c09dc0117d55ee4249186674385386e5"
PKG_SHA256="8ff114549a964af928c472d0bb67e9cba5841bd1be87e2ee4f8bf89d185af089"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/libretro/bsnes2014"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Libretro fork of bsnes. As close to upstream as possible."
PKG_TOOLCHAIN="make"

pre_configure_target() {
  sed -i 's/\-O[23]/-Ofast/' ${PKG_BUILD}/Makefile
  sed -i 's/CFLAGS :=//' ${PKG_BUILD}/Makefile
  sed -i 's/CXXFLAGS :=//' ${PKG_BUILD}/Makefile
}

make_target() {
  make PROFILE=balanced
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp -f bsnes2014_balanced_libretro.so ${INSTALL}/usr/lib/libretro
}
