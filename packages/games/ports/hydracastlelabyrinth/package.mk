# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="hydracastlelabyrinth"
PKG_VERSION="229369c222f8604530f5e06f795b4505ef21d439"
PKG_SHA256="c56c7df8b2c582c747044841a89487f11516f7d0be2487826908e257b6496143"
PKG_LICENSE="GPL2"
PKG_SITE="https://github.com/ptitSeb/hydracastlelabyrinth"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain SDL2"
PKG_LONGDESC="A port to Linux (and OpenPandora / DragonBox Pyra / ODroid / PocketCHIP / GameShell / AmigaOS4 / MorphOS / Emscripten) of Hydra Castle Labyrinth (a "metroidvania" kind of game). Status: Working."
PKG_TOOLCHAIN="cmake-make"

pre_configure_target() {
  export CFLAGS="${CFLAGS} -fcommon"
  PKG_CMAKE_OPTS_TARGET=" -DUSE_SDL2=ON -DSDL2_INCLUDE_DIRS=${SYSROOT_PREFIX}/usr/include/SDL2 -DSDL2_LIBRARIES=${SYSROOT_PREFIX}/usr/lib"
  LDFLAGS="${LDFLAGS} -lSDL2"
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/local/bin
  cp ${PKG_BUILD}/.${TARGET_NAME}/hcl ${INSTALL}/usr/local/bin
  mkdir -p ${INSTALL}/usr/config/ports/hcl
  cp -rf ${PKG_BUILD}/data ${INSTALL}/usr/config/ports/hcl/
}
