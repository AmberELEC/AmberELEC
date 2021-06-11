# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)
# Maintenance 2021-present 351ELEC (https://github.com/351ELEC)

PKG_NAME="duckstation"
PKG_VERSION="1.0"
PKG_ARCH="aarch64"
PKG_URL="https://www.duckstation.org/libretro/duckstation_libretro_linux_aarch64.zip"
PKG_SECTION="libretro"
PKG_SHORTDESC="DuckStation - PlayStation 1, aka. PSX Emulator"
PKG_TOOLCHAIN="manual"

pre_unpack() {
  unzip sources/duckstation/duckstation-1.0.zip -d $PKG_BUILD
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro/
  cp $PKG_BUILD/duckstation_libretro.so $INSTALL/usr/lib/libretro/
}
