# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="opentyrian"
PKG_VERSION="1c34d1bddac8c8f2de834229d04b5a729525c944"
PKG_SHA256="00c271211dee4579453bc07d171f9b5989876181def39f62576a7c449ddf9d3b"
PKG_LICENSE="GPL2"
PKG_SITE="https://github.com/opentyrian/opentyrian"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain SDL2 SDL2_net"
PKG_LONGDESC="An open-source port of the DOS shoot-em-up Tyrian."
PKG_TOOLCHAIN="make"

post_patch() {
  sed -i '1i #include <stdlib.h>' ${PKG_BUILD}/src/animlib.c
}

pre_configure_target() {
  export SDL_CONFIG="${SYSROOT_PREFIX}/usr/bin/sdl2-config"
}

make_target() {
  make \
    CC="${CC}" \
    CFLAGS="${CFLAGS} -I${SYSROOT_PREFIX}/usr/include/SDL2" \
    LDFLAGS="${LDFLAGS} -L${SYSROOT_PREFIX}/usr/lib" \
    LDLIBS="-lSDL2_net -lSDL2 -lm" \
    WITH_NETWORK=true
}

makeinstall_target() {
  cd ${PKG_BUILD}
  rm -f tyrian21.zip
  rm -rf tyrian21
  wget -O tyrian21.zip https://www.camanis.net/tyrian/tyrian21.zip
  unzip ${PKG_BUILD}/tyrian21.zip

  mkdir -p ${INSTALL}/usr/local/bin
  cp opentyrian ${INSTALL}/usr/local/bin

  mkdir -p ${INSTALL}/usr/config/opentyrian
  cp -r ${PKG_DIR}/config/* ${INSTALL}/usr/config/opentyrian

  mkdir -p ${INSTALL}/usr/config/ports/opentyrian
  cp -rf ${PKG_BUILD}/tyrian21/* ${INSTALL}/usr/config/ports/opentyrian
}
