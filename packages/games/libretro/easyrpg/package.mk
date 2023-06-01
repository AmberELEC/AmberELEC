# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="easyrpg"
PKG_VERSION="6ba2f54ed4e2c12b5bd73fc326600a67cf595dde"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/easyrpg/player"
PKG_URL="${PKG_SITE}.git"
PKG_GIT_CLONE_BRANCH="0-8-0-stable"
PKG_DEPENDS_TARGET="toolchain zlib libfmt liblcf pixman speexdsp mpg123 libsndfile libvorbis opusfile wildmidi libxmp-lite fluidsynth harfbuzz libpng"
PKG_LONGDESC="An unofficial libretro port of the EasyRPG/Player."
PKG_BUILD_FLAGS="+pic"

PKG_CMAKE_OPTS_TARGET="-DPLAYER_TARGET_PLATFORM=libretro \
                       -DBUILD_SHARED_LIBS=ON \
                       -DCMAKE_BUILD_TYPE=Release"

pre_make_target() {
  find ${PKG_BUILD} -name flags.make -exec sed -i "s:isystem :I:g" \{} \;
  find ${PKG_BUILD} -name build.ninja -exec sed -i "s:isystem :I:g" \{} \;
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp ${PKG_BUILD}/.${TARGET_NAME}/easyrpg_libretro.so ${INSTALL}/usr/lib/libretro/

  mkdir -p ${INSTALL}/usr/bin
  cp ${PKG_DIR}/easyrpg.sh ${INSTALL}/usr/bin
}
