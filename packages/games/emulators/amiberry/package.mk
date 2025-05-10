# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)
# Copyright (C) 2024-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="amiberry"
PKG_VERSION="02878326e0841b9cc76f92ecb679d5d0a2c5575c"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/BlitterStudio/amiberry"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain linux glibc bzip2 zlib SDL2 SDL2_image SDL2_ttf capsimg freetype libxml2 flac libogg mpg123 libpng libmpeg2 libserialport libportmidi enet"
PKG_LONGDESC="Amiberry is an optimized Amiga emulator for ARM-based boards."
PKG_TOOLCHAIN="cmake-make"
PKG_GIT_CLONE_BRANCH="master"

pre_configure_target() {
  PKG_CMAKE_OPTS_TARGET=" -DCMAKE_BUILD_TYPE=Release \
                      -DCMAKE_RULE_MESSAGES=OFF \
                      -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
                      -DCMAKE_C_FLAGS_RELEASE="-DNDEBUG" \
                      -DCMAKE_CXX_FLAGS_RELEASE="-DNDEBUG""
}

makeinstall_target() {
  # Create directories
  mkdir -p ${INSTALL}/usr/bin
  mkdir -p ${INSTALL}/usr/lib
  mkdir -p ${INSTALL}/usr/config/amiberry

  # Copy ressources
  cp -ra ${PKG_DIR}/config/* ${INSTALL}/usr/config/amiberry/
  cp -a data ${INSTALL}/usr/config/amiberry/
  mkdir -p ${INSTALL}/usr/config/amiberry/savestates
  mkdir -p ${INSTALL}/usr/config/amiberry/screenshots
  cp -a whdboot ${INSTALL}/usr/config/amiberry/
  ln -s /storage/roms/bios ${INSTALL}/usr/config/amiberry/kickstarts

  # Copy binary, scripts & link libcapsimg
  cp -a amiberry* ${INSTALL}/usr/bin/amiberry
  cp -a ${PKG_DIR}/scripts/* ${INSTALL}/usr/bin
  ln -sf /usr/lib/libcapsimage.so.5.1 ${INSTALL}/usr/config/amiberry/capsimg.so
  
  UAE="${INSTALL}/usr/config/amiberry/conf/*.uae"
  for i in ${UAE}; do echo -e "gfx_center_vertical=smart\ngfx_center_horizontal=smart" >> ${i}; done
}
