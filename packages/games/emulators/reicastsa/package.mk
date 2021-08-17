# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="reicastsa"
if [ "${PROJECT}" == "Amlogic-ng" ]; then
PKG_VERSION="7e11e7aff6d704de4ad8ad7531f597df058099ac"
PKG_SHA256=""
else
PKG_VERSION="0bd6ea371e0293f3c8e02b5ac1344c89b1e60bee"
PKG_SHA256="9a9dddb0c07f941b23c899dd82ef9be4c75653523e99f9f84bb5cae02c9b2fa5"
fi
PKG_EE_UPDATE="no"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/reicast/reicast-emulator"
PKG_URL="https://github.com/reicast/reicast-emulator/archive/$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="reicast-emulator-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain alsa libpng libevdev python-evdev"
PKG_SHORTDESC="Reicast is a multi-platform Sega Dreamcast emulator"
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="-gold"

PKG_PATCH_DIRS="${PROJECT}"

make_target() {
  cd shell/linux
  make CC=$CC CXX=$CXX AS=$CC STRIP=$STRIP EXTRAFLAGS="-I$PKG_BUILD/shell/linux-deps/include" platform=odroidc2 reicast.elf
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
  cp reicast.elf $INSTALL/usr/bin/reicast
  cp tools/reicast-joyconfig.py $INSTALL/usr/bin/

  mkdir -p $INSTALL/usr/config/distribution/bin
  cp -r $PKG_DIR/config/* $INSTALL/usr/config/
  cp -r $PKG_DIR/scripts/* $INSTALL/usr/config/distribution/bin/
 
}
