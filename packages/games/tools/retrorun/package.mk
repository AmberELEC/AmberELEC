# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="retrorun"
PKG_VERSION="b29e4636d0323fdea32cb3dd3af61dcb4af47096"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/navy1978/retrorun-go-removed"
PKG_URL="$PKG_SITE.git"
PKG_DEPENDS_TARGET="toolchain libdrm libpng linux libevdev librga openal-soft"
PKG_TOOLCHAIN="make"

#PKG_MAKE_OPTS_TARGET=" INCLUDES=-I$SYSROOT_PREFIX/usr/include/libdrm -I$SYSROOT_PREFIX/usr/include "

pre_configure_target() {
  CFLAGS+=" -I$(get_build_dir libdrm)/include/drm"
  CFLAGS+=" -I$(get_build_dir linux)/include/uapi"
  CFLAGS+=" -I$(get_build_dir linux)/tools/include"
}

make_target() {
  make config=release ARCH=
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
  if [ "${ARCH}" != "aarch64" ]; then
    cp retrorun $INSTALL/usr/bin/retrorun32
  else
    cp retrorun $INSTALL/usr/bin
    cp $PKG_DIR/retrorun.sh $INSTALL/usr/bin
    #cp -vP $PKG_BUILD/../../build.${DISTRO}-${DEVICE}.arm/retrorun-*/.install_pkg/usr/bin/retrorun32 $INSTALL/usr/bin
    mkdir -p $INSTALL/usr/config/distribution/configs
    cp -vP $PKG_DIR/retrorun.cfg $INSTALL/usr/config/distribution/configs
  fi
}