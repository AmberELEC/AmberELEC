# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="retrorun"
PKG_VERSION="6573d6fa9aacd5de23775988c7267a2fe879e03d"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/AmberELEC/retrorun"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain libdrm libpng linux libevdev librga openal-soft"
PKG_TOOLCHAIN="make"

pre_configure_target() {
  CFLAGS+=" -I$(get_build_dir libdrm)/include/drm"
  CFLAGS+=" -I$(get_build_dir linux)/include/uapi"
  CFLAGS+=" -I$(get_build_dir linux)/tools/include"
}

make_target() {
  make config=release ARCH= verbose=1
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/bin
  cp retrorun ${INSTALL}/usr/bin
  cp $PKG_DIR/retrorun.sh ${INSTALL}/usr/bin
  mkdir -p ${INSTALL}/usr/config/distribution/configs
  cp -vP ${PKG_DIR}/retrorun.cfg ${INSTALL}/usr/config/distribution/configs
}
