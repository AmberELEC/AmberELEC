# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2021-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="openbor"
PKG_VERSION="7eedd8991191e00334aeb4de1518d8c74d875468"
PKG_SITE="https://github.com/DCurrent/openbor"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain SDL2 libogg libvorbisidec libvpx libpng"
PKG_LONGDESC="OpenBOR is the ultimate 2D side scrolling engine for beat em' ups, shooters, and more!"
PKG_TOOLCHAIN="make"

PKG_MAKE_OPTS_TARGET="BUILD_LINUX_${ARCH}=1 PREFIX=${TARGET_NAME}- SDKPATH=${SYSROOT_PREFIX} STRIP=${STRIP}"

pre_configure_target() {
  export CFLAGS="${CFLAGS} -Wno-error=enum-int-mismatch"
  cd ${PKG_BUILD}

  sed -i 's/\-O[23]//' engine/Makefile
  sed -i 's|source/gfxlib/2xSaI.o||' engine/Makefile
  sed -i 's|source/gfxlib/hq2x.o||' engine/Makefile
  sed -i 's|savedata.fullscreen = 0;|savedata.fullscreen = 1;|g' engine/openbor.c

  sed -i 's|^\t@\$(STRIP)|\tcp \$(TARGET) \$(TARGET_FINAL)|g' engine/Makefile
  sed -i 's|^\t\$(STRIP)|\tcp \$(TARGET) \$(TARGET_FINAL)|g' engine/Makefile

  sed -i 's|-I/usr/include/SDL2||g' engine/Makefile
  sed -i 's|-I/usr/include||g' engine/Makefile
  sed -i 's|-I/usr/local/include||g' engine/Makefile
  sed -i 's|-I/usr/X11R6/include||g' engine/Makefile
  sed -i 's|-L/usr/lib||g' engine/Makefile
  sed -i 's|-L/usr/local/lib||g' engine/Makefile
  sed -i 's|-Wl,-rpath,\$(LIBRARIES)|-Wl,-rpath-link,\$(SDKPATH)/usr/lib -Wl,-rpath-link,\$(SDKPATH)/lib|g' engine/Makefile

  LIBGCC_DIR="$(dirname "$(${CC} -print-file-name=libgcc_s.so.1)")"

  cat << EOF >> engine/Makefile

override INCS += ${SYSROOT_PREFIX}/usr/include/SDL2 ${SYSROOT_PREFIX}/usr/include
override LIBS += -L${LIBGCC_DIR} -L${SYSROOT_PREFIX}/usr/lib -L${SYSROOT_PREFIX}/lib -Wl,-rpath-link,${LIBGCC_DIR} -Wl,-rpath-link,${SYSROOT_PREFIX}/usr/lib -Wl,-rpath-link,${SYSROOT_PREFIX}/lib -lstdc++ -lgcc_s
EOF
}

pre_make_target() {
  cd ${PKG_BUILD}/engine
  chmod +x version.sh
  ./version.sh
}

make_target() {
  make ${PKG_MAKE_OPTS_TARGET} \
       -C "${PKG_BUILD}/engine" \
       ${MAKEFLAGS}
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/bin
  cp ${PKG_BUILD}/engine/OpenBOR ${INSTALL}/usr/bin/OpenBOR
  cp ${PKG_DIR}/scripts/*.sh ${INSTALL}/usr/bin
  chmod +x ${INSTALL}/usr/bin/*
}
