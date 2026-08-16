# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2021-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="gzdoom"
PKG_VERSION="a1f88cb1ee7fda0739811435921d7c3d4a71d01d"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/dhwz/gzdoom"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_HOST="toolchain zmusic:host libwebp:host"
PKG_DEPENDS_TARGET="toolchain SDL2 gzdoom:host zmusic libwebp"
PKG_LONGDESC="GZDoom is a modder-friendly OpenGL and Vulkan source port based on the DOOM engine"
PKG_TOOLCHAIN="cmake-make"

if [ ! "${DEVICE}" = "RG351MP" ] && [ ! "${DEVICE}" = "RG552" ]
then
  PKG_PATCH_DIRS="RG351P"
fi

pre_build_host() {
  HOST_CMAKE_OPTS=""
}

make_host() {
  make lemon zipdir re2c
}

makeinstall_host() {
: #no
}

pre_configure_host(){
  PKG_CMAKE_OPTS_HOST=" -DZMUSIC_LIBRARIES=$(get_build_dir zmusic)/build_host/source/libzmusic.so \
                        -DZMUSIC_INCLUDE_DIR=$(get_build_dir zmusic)/include \
                        -DCMAKE_BUILD_TYPE=Release \
                        -DCMAKE_RULE_MESSAGES=OFF \
                        -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON"
}

pre_configure_target() {
  sed -i 's/src\/window\/x11\/x11_display_backend.cpp/src\/window\/sdl2\/sdl2_display_backend.cpp/g' ${PKG_BUILD}/libraries/ZWidget/CMakeLists.txt
  sed -i 's/src\/window\/x11\/x11_display_window.cpp/src\/window\/sdl2\/sdl2_display_window.cpp/g' ${PKG_BUILD}/libraries/ZWidget/CMakeLists.txt
  sed -i 's/src\/window\/x11\/x11_connection.cpp//g' ${PKG_BUILD}/libraries/ZWidget/CMakeLists.txt

  sed -i 's/X11DisplayBackend/SDL2DisplayBackend/g' ${PKG_BUILD}/libraries/ZWidget/src/window/window.cpp
  sed -i 's/x11\/x11_display_backend.h/sdl2\/sdl2_display_backend.h/g' ${PKG_BUILD}/libraries/ZWidget/src/window/window.cpp

  sed -i 's/common\/platform\/posix\/unix\/gtk_dialogs.cpp//g' ${PKG_BUILD}/src/CMakeLists.txt
  sed -i 's/find_package(GTK3)/# find_package(GTK3)/g' ${PKG_BUILD}/src/CMakeLists.txt
  sed -i 's/pkg_check_modules(GTK3/# pkg_check_modules(GTK3/g' ${PKG_BUILD}/src/CMakeLists.txt

  TARGET_CXXFLAGS="${TARGET_CXXFLAGS} -DNO_X11=1 -DNO_GTK=1"

  PKG_CMAKE_OPTS_TARGET=" -DNO_GTK=ON \
                          -DFORCE_CROSSCOMPILE=ON \
                          -DIMPORT_EXECUTABLES=${PKG_BUILD}/.${HOST_NAME}/ImportExecutables.cmake \
                          -DCMAKE_BUILD_TYPE=Release \
                          -DCMAKE_RULE_MESSAGES=OFF \
                          -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
                          -DHAVE_GLES2=ON \
                          -DHAVE_VULKAN=OFF \
                          -DZMUSIC_LIBRARIES=$(get_build_dir zmusic)/build_target/source/libzmusic.so \
                          -DZMUSIC_INCLUDE_DIR=$(get_build_dir zmusic)/include"
}

pre_make_target() {
  sed -i 's/-lX11//g' ${PKG_BUILD}/.${TARGET_NAME}/src/CMakeFiles/zdoom.dir/link.txt
  sed -i 's/-lXi//g' ${PKG_BUILD}/.${TARGET_NAME}/src/CMakeFiles/zdoom.dir/link.txt
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/bin
  cp ${PKG_DIR}/gzdoom.sh ${INSTALL}/usr/bin/
  cp ${PKG_BUILD}/.${TARGET_NAME}/gzdoom ${INSTALL}/usr/bin

  mkdir -p ${INSTALL}/usr/config/distribution/gzdoom
  if [ "${DEVICE}" = "RG351MP" ] || [ "${DEVICE}" = "RG552" ]; then
    cp ${PKG_DIR}/config/RG351MP/* ${INSTALL}/usr/config/distribution/gzdoom
  else
    cp ${PKG_DIR}/config/RG351P/* ${INSTALL}/usr/config/distribution/gzdoom
  fi
  cp ${PKG_BUILD}/.${TARGET_NAME}/*.pk3 ${INSTALL}/usr/config/distribution/gzdoom
  cp -r ${PKG_BUILD}/.${TARGET_NAME}/soundfonts ${INSTALL}/usr/config/distribution/gzdoom
  cp -r ${PKG_BUILD}/.${TARGET_NAME}/fm_banks ${INSTALL}/usr/config/distribution/gzdoom
}
