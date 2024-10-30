# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="melonds"
PKG_VERSION="7a3c11ff970cd36ca806961fae6db94b30dd5401"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/libretro/melonds"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain ${OPENGLES}"
PKG_SHORTDESC="MelonDS - Nintendo DS emulator for libretro"
PKG_TOOLCHAIN="make"

make_target() {
  make -C ${PKG_BUILD} platform=RK3399
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp ${PKG_BUILD}/melonds_libretro.so ${INSTALL}/usr/lib/libretro/
}
