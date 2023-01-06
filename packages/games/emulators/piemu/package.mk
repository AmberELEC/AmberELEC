# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="piemu"
PKG_VERSION="0785214f13746bdfd709b1909f007e213b470ba1"
PKG_LICENSE="ZLIB"
PKG_SITE="https://github.com/yonkuma/piemu"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain SDL2"
PKG_LONGDESC="Piemu Standalone"
PKG_TOOLCHAIN="cmake-make"

pre_configure_target() {
  PKG_CMAKE_OPTS_TARGET=" -DSDL2_INCLUDE_DIRS=${SYSROOT_PREFIX}/usr/include/SDL2 -DSDL2_LIBRARIES=${SYSROOT_PREFIX}/usr/lib"
    LDFLAGS="${LDFLAGS} -lSDL2"
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/bin
  cp ${PKG_BUILD}/.aarch64-libreelec-linux-gnueabi/piemu ${INSTALL}/usr/bin
  chmod 755 ${INSTALL}/usr/bin/piemu
  cp ${PKG_BUILD}/.aarch64-libreelec-linux-gnueabi/tools/mkpfi ${INSTALL}/usr/bin
  chmod 755 ${INSTALL}/usr/bin/mkpfi
  cp ${PKG_BUILD}/.aarch64-libreelec-linux-gnueabi/tools/pfar ${INSTALL}/usr/bin
  chmod 755 ${INSTALL}/usr/bin/pfar
  cp ${PKG_DIR}/bin/piemu.sh ${INSTALL}/usr/bin
  chmod 755 ${INSTALL}/usr/bin/piemu.sh
}
