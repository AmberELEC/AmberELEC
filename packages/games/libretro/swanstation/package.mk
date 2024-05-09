# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="swanstation"
PKG_VERSION="929958a1acaa075e32e108118b550e0449540cb6"
PKG_SHA256="fb8e0dc07c3e8b662af5f40137796a65e6e291fb752912092071b6e9d9555409"
PKG_ARCH="aarch64"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/libretro/swanstation"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain nasm:host ${OPENGLES}"
PKG_LONGDESC="SwanStation - PlayStation 1, aka. PSX Emulator"
PKG_TOOLCHAIN="cmake"

pre_configure_target() {
 PKG_CMAKE_OPTS_TARGET+=" -DCMAKE_BUILD_TYPE=Release -DBUILD_LIBRETRO_CORE=ON "
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp ${PKG_BUILD}/.${TARGET_NAME}/swanstation_libretro.so ${INSTALL}/usr/lib/libretro/
}
