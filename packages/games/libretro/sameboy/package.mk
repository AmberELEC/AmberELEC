# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="sameboy"
PKG_VERSION="eaf211d257107a62c5f6a55085b5bae90625d9e4"
PKG_LICENSE="MIT"
PKG_SITE="https://github.com/LIJI32/SameBoy"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Gameboy and Gameboy Color emulator written in C"
PKG_TOOLCHAIN="make"
PKG_GIT_CLONE_BRANCH="libretro"

make_target() {
  make -C libretro BOOTROMS_DIR=${PKG_BUILD}/BootROMs/prebuilt
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp ${PKG_BUILD}/sameboy_libretro.so ${INSTALL}/usr/lib/libretro/
}
