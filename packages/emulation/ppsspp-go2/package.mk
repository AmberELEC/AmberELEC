# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2020-present Fewtarius

PKG_NAME="ppsspp-go2"
PKG_VERSION="c85bdbfdc7bccaf082ff668404a53f69739b0e3c"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="MAME"
PKG_SITE="https://github.com/OtherCrashOverride/ppsspp-go2"
PKG_URL="https://github.com/OtherCrashOverride/ppsspp-go2.git"
PKG_DEPENDS_TARGET="toolchain ffmpeg libzip libpng libgo2 SDL2-git zlib zip"
PKG_SHORTDESC="ppsspp-go2"
PKG_LONGDESC="PPSSPP libGO2 port Standalone"
GET_HANDLER_SUPPORT="git"
PKG_BUILD_FLAGS="+lto"

PKG_CMAKE_OPTS_TARGET+="-DARMV7=ON  \
                       -DUSE_SYSTEM_FFMPEG=ON \
                       -DUSING_FBDEV=ON \
                       -DUSE_WAYLAND_WSI=OFF \
                       -DUSING_EGL=OFF \
                       -DUSING_GLES2=ON \
                       -DUSE_DISCORD=OFF \
                       -DUSING_X11_VULKAN=OFF \
                       -DARM_NO_VULKAN=ON \
                       -DBUILD_SHARED_LIBS=OFF \
                       -DANDROID=OFF \
                       -DWIN32=OFF \
                       -DAPPLE=OFF \
                       -DCMAKE_CROSSCOMPILING=ON \
                       -DVULKAN=OFF \
                       -DUSING_QT_UI=OFF \
                       -DUNITTEST=OFF \
                       -DSIMULATOR=OFF \
                       -DHEADLESS=OFF \
                       -fpermissive \
                       -Wno-dev "

if [ $ARCH == "aarch64" ]; then
PKG_CMAKE_OPTS_TARGET+=" -DARM64=ON"
else
PKG_CMAKE_OPTS_TARGET+=" -DARMV7=ON"
fi

pre_configure_target() {
if [ "$DEVICE" == "RG351P" ]; then
	sed -i "s|include_directories(/usr/include/drm)|include_directories(${SYSROOT_PREFIX}/usr/include/drm)|" $PKG_BUILD/CMakeLists.txt
fi
}

pre_make_target() {
  # fix cross compiling
  find ${PKG_BUILD} -name flags.make -exec sed -i "s:isystem :I:g" \{} \;
  find ${PKG_BUILD} -name build.ninja -exec sed -i "s:isystem :I:g" \{} \;
}


makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
    cp $PKG_DIR/ppsspp-go2.sh $INSTALL/usr/bin/ppsspp-go2.sh
    cp `find . -name "PPSSPPSDL" | xargs echo` $INSTALL/usr/bin/ppsspp-go2
    ln -sf /storage/.config/ppsspp/assets $INSTALL/usr/bin/assets
    mkdir -p $INSTALL/usr/config/ppsspp/
    cp -r `find . -name "assets" | xargs echo` $INSTALL/usr/config/ppsspp/
    cp -rf $PKG_DIR/config/* $INSTALL/usr/config/ppsspp/
} 
