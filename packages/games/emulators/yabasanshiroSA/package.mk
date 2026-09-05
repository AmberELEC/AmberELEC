# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="yabasanshiroSA"
PKG_VERSION="a40dace1ae0af3ebd45848549fdf396f40e3930f"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/sydarn/yabause"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain SDL2 boost openal-soft ${OPENGLES} zlib"
PKG_LONGDESC="Yabause is a Sega Saturn emulator and took over as Yaba Sanshiro"
PKG_TOOLCHAIN="cmake-make"
PKG_GIT_CLONE_BRANCH="pi4-update"
PKG_BUILD_FLAGS="+bfd"
PKG_PATCH_DIRS="${DEVICE}"

post_unpack() {
  sed -i "s|COMMAND m68kmake|COMMAND ${PKG_BUILD}/m68kmake_host|" ${PKG_BUILD}/yabause/src/musashi/CMakeLists.txt
  sed -i "s|COMMAND ./bin2c|COMMAND ${PKG_BUILD}/bin2c_host|" ${PKG_BUILD}/yabause/src/retro_arena/nanogui-sdl/CMakeLists.txt
  find ${PKG_BUILD} -type f -name "CMakeLists.txt" -exec sed -i 's/^\s*cmake_minimum_required.*$/cmake_minimum_required(VERSION 3.10...3.25)/' {} +

  sed -i 's/include(FindOpenGL)/set(OPENGL_FOUND TRUE)/g' ${PKG_BUILD}/yabause/src/CMakeLists.txt
  sed -i 's/if (OPENGL_FOUND )/if (TRUE)/g' ${PKG_BUILD}/yabause/src/CMakeLists.txt
  sed -i 's/if(OPENGL_FOUND)/if(TRUE)/g' ${PKG_BUILD}/yabause/src/CMakeLists.txt
}

pre_make_target() {
  ${HOST_CC} ${PKG_BUILD}/yabause/src/retro_arena/nanogui-sdl/resources/bin2c.c -o ${PKG_BUILD}/bin2c_host
  ${HOST_CC} ${PKG_BUILD}/yabause/src/musashi/m68kmake.c -o ${PKG_BUILD}/m68kmake_host
}

pre_configure_target() {
  TARGET_CFLAGS="${TARGET_CFLAGS} -D_POSIX_C_SOURCE=199309L -D__N2__ -D__RETORO_ARENA__"
  TARGET_CXXFLAGS="${TARGET_CXXFLAGS} -D__N2__ -D__RETORO_ARENA__"

  EXTRA_LDFLAGS="-Wl,-rpath-link,${SYSROOT_PREFIX}/usr/lib -Wl,--allow-multiple-definition -ldrm -lrga -lpulse"
  TARGET_LDFLAGS="${TARGET_LDFLAGS} ${EXTRA_LDFLAGS}"
  export LDFLAGS="${LDFLAGS} ${EXTRA_LDFLAGS}"

  PKG_CMAKE_OPTS_TARGET="-S ${PKG_BUILD}/yabause \
                         -DYAB_WANT_DYNAREC_DEVMIYAX=ON \
                         -DYAB_WANT_ARM7=ON \
                         -DYAB_PORTS=retro_arena \
                         -DUSE_EGL=ON \
                         -DBOOST_ROOT=${SYSROOT_PREFIX}/usr \
                         -DBoost_NO_SYSTEM_PATHS=ON \
                         -DOPENGL_INCLUDE_DIR=${SYSROOT_PREFIX}/usr/include \
                         -DOpenGL_GL_PREFERENCE=LEGACY \
                         -DLIBPNG_LIB_DIR=${SYSROOT_PREFIX}/usr/lib \
                         -Dpng_STATIC_LIBRARIES=${SYSROOT_PREFIX}/usr/lib/libpng16.so \
                         -DCMAKE_BUILD_TYPE=Release"
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/bin
  cp -a ${PKG_BUILD}/src/retro_arena/yabasanshiro ${INSTALL}/usr/bin
  cp -a ${PKG_DIR}/yabasanshiro.sh ${INSTALL}/usr/bin

  mkdir -p ${INSTALL}/usr/config/yabasanshiro
  cp ${PKG_DIR}/config/* ${INSTALL}/usr/config/yabasanshiro
}
