# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="ppssppsa"
PKG_VERSION="$(get_pkg_version ppsspp)"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/hrydgard/ppsspp"
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain ${OPENGLES} ffmpeg libzip SDL2 zlib zstd"
PKG_DEPENDS_UNPACK="ppsspp"
PKG_LONGDESC="PPSSPP Standalone"
PKG_TOOLCHAIN="cmake-make"

unpack() {
  mkdir -p ${PKG_BUILD}
  cp -rf ${SOURCES}/ppsspp/ppsspp-${PKG_VERSION}/. ${PKG_BUILD}
}

if [[ "${DEVICE}" == RG351V ]] || [[ "${DEVICE}" == RG351MP ]]; then
  PKG_PATCH_DIRS="RG351MP"
fi

PKG_CMAKE_OPTS_TARGET+="-DUSE_WAYLAND_WSI=OFF \
                        -DUSE_VULKAN_DISPLAY_KHR=OFF \
                        -DUSING_FBDEV=ON \
                        -DCMAKE_BUILD_TYPE=Release \
                        -DCMAKE_SYSTEM_NAME=Linux \
                        -DCMAKE_RULE_MESSAGES=OFF \
                        -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
                        -DCMAKE_C_FLAGS_RELEASE="-DNDEBUG" \
                        -DCMAKE_CXX_FLAGS_RELEASE="-DNDEBUG" \
                        -DUSING_EGL=OFF \
                        -DUSING_GLES2=ON \
                        -DVULKAN=OFF \
                        -DARM_NO_VULKAN=ON \
                        -DUSING_X11_VULKAN=OFF \
                        -DBUILD_SHARED_LIBS=OFF \
                        -DANDROID=OFF \
                        -DWIN32=OFF \
                        -DAPPLE=OFF \
                        -DCMAKE_CROSSCOMPILING=ON \
                        -DUSING_QT_UI=OFF \
                        -DUNITTEST=OFF \
                        -DSIMULATOR=OFF \
                        -DHEADLESS=OFF \
                        -DUSE_SYSTEM_FFMPEG=ON \
                        -DUSE_SYSTEM_ZSTD=ON \
                        -DUSE_SYSTEM_LIBZIP=ON \
                        -DUSE_DISCORD=OFF"

pre_configure_target() {
  sed -i 's/\-O[23]//' ${PKG_BUILD}/CMakeLists.txt
  sed -i "s|include_directories(/usr/include/drm)|include_directories(${SYSROOT_PREFIX}/usr/include/drm)|" ${PKG_BUILD}/CMakeLists.txt
}

pre_make_target() {
  export CPPFLAGS="${CPPFLAGS} -Wno-error"
  export CFLAGS="${CFLAGS} -Wno-error"

  # fix cross compiling
  find ${PKG_BUILD} -name flags.make -exec sed -i "s:isystem :I:g" \{} \;
  find ${PKG_BUILD} -name build.ninja -exec sed -i "s:isystem :I:g" \{} \;
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/bin
    cp ${PKG_DIR}/ppsspp.sh ${INSTALL}/usr/bin/ppsspp.sh
    cp `find . -name "PPSSPPSDL" | xargs echo` ${INSTALL}/usr/bin/PPSSPPSDL
    ln -sf /storage/.config/ppsspp/assets ${INSTALL}/usr/bin/assets
    mkdir -p ${INSTALL}/usr/config/ppsspp/
    cp -r `find . -name "assets" | xargs echo` ${INSTALL}/usr/config/ppsspp/
    cp -rf ${PKG_DIR}/config/* ${INSTALL}/usr/config/ppsspp/
    rm ${INSTALL}/usr/config/ppsspp/assets/gamecontrollerdb.txt
}
