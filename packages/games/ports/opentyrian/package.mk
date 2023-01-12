# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="opentyrian"
PKG_VERSION="50ba3629bf114d5615c17c56c03a04a9cbeb6d6f"
PKG_SHA256="9e5aa4e04bbad30a1517f06cf457c71ec3bf77e8eecd2c8ae38c67303e35d4f4"
PKG_LICENSE="GPL2"
PKG_SITE="https://github.com/opentyrian/opentyrian"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain SDL2 SDL2_net"
PKG_LONGDESC="An open-source port of the DOS shoot-em-up Tyrian."
PKG_TOOLCHAIN="make"

pre_configure_target() {
  CFLAGS+=" -I$(get_build_dir SDL2)/include"
  CFLAGS+=" -I$(get_build_dir SDL2_net)"
  export LDFLAGS="${LDFLAGS} -lSDL2 -lSDL2_net"
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
