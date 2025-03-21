# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="retrorun"
PKG_VERSION="3aed8d8f7e4c1723e97b0d501d797d1149a4acbb"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/navy1978/retrorun"
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
