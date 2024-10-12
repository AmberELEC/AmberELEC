# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="doublecherrygb"
PKG_VERSION="8df76ba2540a00ac426dc0db4d5d4fdc43b439a6"
PKG_SHA256="cb2fe5afc1cdc535cb25df4cc5fe0ed1933fae9da32f7309b5b9d22e1b38b257"
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