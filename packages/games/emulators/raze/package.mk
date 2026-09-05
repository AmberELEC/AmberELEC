# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2021-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="raze"
PKG_VERSION="4ba5bb5c2da5893e1eb4a5ef0fec4c6f01b26e95"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/dhwz/Raze"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_HOST="toolchain"
PKG_DEPENDS_TARGET="toolchain SDL2 raze:host zmusic libvpx libwebp"
PKG_LONGDESC="Raze is a fork of Build engine games backed by GZDoom tech and combines Duke Nukem 3D, Blood, Redneck Rampage, Shadow Warrior and Exhumed/Powerslave in a single package."
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
  sed -i 's/find_package( ZMusic REQUIRED )/# find_package( ZMusic REQUIRED )/g' ${PKG_BUILD}/source/CMakeLists.txt
  sed -i 's/find_package(GTK3)/# find_package(GTK3)/g' ${PKG_BUILD}/source/CMakeLists.txt
  sed -i 's/pkg_check_modules(GTK3/# pkg_check_modules(GTK3/g' ${PKG_BUILD}/source/CMakeLists.txt

  PKG_CMAKE_OPTS_HOST="-DCMAKE_BUILD_TYPE=Release \
                       -DCMAKE_RULE_MESSAGES=OFF \
                       -DZMUSIC_INCLUDE_DIR=/usr/include \
                       -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON"
}

pre_configure_target() {
  sed -i 's/src\/window\/x11\/x11_display_backend.cpp/src\/window\/sdl2\/sdl2_display_backend.cpp/g' ${PKG_BUILD}/libraries/ZWidget/CMakeLists.txt
  sed -i 's/src\/window\/x11\/x11_display_window.cpp/src\/window\/sdl2\/sdl2_display_window.cpp/g' ${PKG_BUILD}/libraries/ZWidget/CMakeLists.txt
  sed -i 's/src\/window\/x11\/x11_connection.cpp//g' ${PKG_BUILD}/libraries/ZWidget/CMakeLists.txt

  sed -i 's/X11DisplayBackend/SDL2DisplayBackend/g' ${PKG_BUILD}/libraries/ZWidget/src/window/window.cpp
  sed -i 's/x11\/x11_display_backend.h/sdl2\/sdl2_display_backend.h/g' ${PKG_BUILD}/libraries/ZWidget/src/window/window.cpp

  sed -i 's/common\/platform\/posix\/unix\/gtk_dialogs.cpp//g' ${PKG_BUILD}/source/CMakeLists.txt
  sed -i 's/find_package(GTK3)/# find_package(GTK3)/g' ${PKG_BUILD}/source/CMakeLists.txt
  sed -i 's/pkg_check_modules(GTK3/# pkg_check_modules(GTK3/g' ${PKG_BUILD}/source/CMakeLists.txt

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
  sed -i 's/-lX11//g' ${PKG_BUILD}/.${TARGET_NAME}/source/CMakeFiles/raze.dir/link.txt
  sed -i 's/-lXi//g' ${PKG_BUILD}/.${TARGET_NAME}/source/CMakeFiles/raze.dir/link.txt
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/bin
  cp ${PKG_DIR}/raze.sh ${INSTALL}/usr/bin/
  cp ${PKG_BUILD}/.${TARGET_NAME}/raze ${INSTALL}/usr/bin

  mkdir -p ${INSTALL}/usr/config/distribution/raze
  if [ "${DEVICE}" = "RG351MP" ] || [ "${DEVICE}" = "RG552" ]; then
    cp ${PKG_DIR}/config/RG351MP/* ${INSTALL}/usr/config/distribution/raze
  else
    cp ${PKG_DIR}/config/RG351P/* ${INSTALL}/usr/config/distribution/raze
  fi
  cp ${PKG_BUILD}/.${TARGET_NAME}/*.pk3 ${INSTALL}/usr/config/distribution/raze
  cp -r ${PKG_BUILD}/.${TARGET_NAME}/soundfonts ${INSTALL}/usr/config/distribution/raze
}
