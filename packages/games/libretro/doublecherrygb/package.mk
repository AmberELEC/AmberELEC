# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="doublecherrygb"
PKG_VERSION="2be011ae5d5141d76c48bee15043ed6cea3d595a"
PKG_SHA256="628bbfcc911c2eb57293985656750d2c7a7126404307cca2844494607cd90381"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/TimOelrichs/doublecherryGB-libretro"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="libretro gameboy core with up to 16 players support"
PKG_TOOLCHAIN="make"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp DoubleCherryGB_libretro.so ${INSTALL}/usr/lib/libretro/
}