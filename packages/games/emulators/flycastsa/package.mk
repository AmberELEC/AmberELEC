# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="flycastsa"
PKG_VERSION="$(get_pkg_version flycast)"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/flyinghead/flycast"
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain alsa SDL2 ${OPENGLES} libzip zip curl"
PKG_DEPENDS_UNPACK="flycast"
PKG_LONGDESC="Flycast is a multiplatform Sega Dreamcast, Naomi, Naomi 2 and Atomiswave emulator"
PKG_TOOLCHAIN="cmake-make"

unpack() {
  mkdir -p ${PKG_BUILD}
  cp -rf ${SOURCES}/flycast/flycast-${PKG_VERSION}/. ${PKG_BUILD}
}

pre_configure_target() {
  export CXXFLAGS="${CXXFLAGS} -Wno-error=array-bounds"
  PKG_CMAKE_OPTS_TARGET="-DCMAKE_RULE_MESSAGES=OFF \
                         -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
                         -DCMAKE_BUILD_TYPE="Release" \
                         -DCMAKE_C_FLAGS_RELEASE="-DNDEBUG" \
                         -DCMAKE_CXX_FLAGS_RELEASE="-DNDEBUG" \
                         -DWITH_SYSTEM_ZLIB=ON \
                         -DUSE_OPENMP=ON \
                         -DUSE_VULKAN=OFF \
                         -DUSE_GLES=ON"
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/bin
  cp ${PKG_BUILD}/.${TARGET_NAME}/flycast ${INSTALL}/usr/bin/flycast
  cp ${PKG_DIR}/scripts/* ${INSTALL}/usr/bin
}
