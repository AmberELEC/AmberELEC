# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="retrorun"
PKG_VERSION="32e1ee98af94dfd2bf726a5701dd461541dbdf10"
PKG_ARCH="aarch64"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/navy1978/retrorun-go2"
PKG_URL="$PKG_SITE.git"
PKG_DEPENDS_TARGET="toolchain libgo2 libdrm"
PKG_TOOLCHAIN="make"
GET_HANDLER_SUPPORT="git"

pre_make_target() {
  mkdir -p src/go2
  cp -f $SYSROOT_PREFIX/usr/include/go2/*.h src/go2
}

pre_configure_target() {
CFLAGS+=" -I$(get_build_dir libdrm)/include/drm"
CFLAGS+=" -I$(get_build_dir linux)/include/uapi"
CFLAGS+=" -I$(get_build_dir linux)/tools/include"

PKG_MAKE_OPTS_TARGET=" config=release ARCH="
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
  cp retrorun $INSTALL/usr/bin
  cp $PKG_DIR/retrorun.sh $INSTALL/usr/bin
}
