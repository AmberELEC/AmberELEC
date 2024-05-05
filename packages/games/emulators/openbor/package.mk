# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2021-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="openbor"
PKG_VERSION="09e281bb36502e23b7616638484e0bb82b3ba0cc"
PKG_SITE="https://github.com/DCurrent/openbor"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain SDL2 libogg libvorbisidec libvpx libpng"
PKG_LONGDESC="OpenBOR is the ultimate 2D side scrolling engine for beat em' ups, shooters, and more!"
PKG_TOOLCHAIN="make"

pre_configure_target() {
  export CFLAGS="${CFLAGS} -Wno-error=enum-int-mismatch"
  PKG_MAKE_OPTS_TARGET="BUILD_LINUX_${ARCH}=1 NO_STRIP=1 -C ${PKG_BUILD}/engine SDKPATH=${SYSROOT_PREFIX} PREFIX=${TARGET_NAME}"
  cd ${PKG_BUILD}
  sed -i 's/\-O[23]//' engine/Makefile
  sed -i 's|source/gfxlib/2xSaI.o||' engine/Makefile
  sed -i 's|source/gfxlib/hq2x.o||' engine/Makefile
  sed -i 's|savedata.fullscreen = 0;|savedata.fullscreen = 1;|g' engine/openbor.c
}

pre_make_target() {
  cd ${PKG_BUILD}/engine
  chmod +x version.sh
  ./version.sh
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/bin
  cp OpenBOR ${INSTALL}/usr/bin/OpenBOR
  cp ${PKG_DIR}/scripts/*.sh ${INSTALL}/usr/bin
  chmod +x ${INSTALL}/usr/bin/*
} 
