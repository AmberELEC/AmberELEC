# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="hydracastlelabyrinth"
PKG_VERSION="6140a3a94448af04f73534019798e91f09f089c5"
PKG_SHA256="dc13925255fb83f8cf00f01819ff1cdb0128cfb29f72d6658c549d8f8f208b0c"
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
