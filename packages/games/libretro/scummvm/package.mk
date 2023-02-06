# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="scummvm"
PKG_VERSION="60a40ed6f499c91657f3e22f278ed3feca556564"
PKG_SHA256="1a878d37d6613de2ad10be404b9d938c3748f88f5100fdd4314f9bbc5f785eb8"
PKG_LICENSE="GPL2"
PKG_SITE="https://github.com/scummvm/scummvm"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="ScummVM is a program which allows you to run certain classic graphical point-and-click adventure games, provided you already have their data files."

pre_configure_target() {
  cd ..
  rm -rf .${TARGET_NAME}
  cd ${PKG_BUILD}/backends/platform
  rm -rf libretro
  git clone https://github.com/diablodiab/scummvm-libretro-backend libretro
}

configure_target() {
  :
}

make_target() {
  make -C ${PKG_BUILD}/backends/platform/libretro/build
  cd ${PKG_BUILD}/backends/platform/libretro/aux-data
  ./bundle_aux_data.bash
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp ${PKG_BUILD}/backends/platform/libretro/build/scummvm_libretro.so ${INSTALL}/usr/lib/libretro/
  mkdir -p ${INSTALL}/usr/share/scummvm
  unzip ${PKG_BUILD}/backends/platform/libretro/aux-data/scummvm.zip -d ${INSTALL}/usr/share/
}
