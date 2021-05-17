# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="physfs"
PKG_VERSION="610a844fa3d003fc8501dd2b0a1ce13d077a38b6"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="https://github.com/criptych/physfs"
PKG_URL="$PKG_SITE.git"
PKG_DEPENDS_TARGET="toolchain glm"
PKG_SHORTDESC="PhysicsFS; a portable, flexible file i/o abstraction."
GET_HANDLER_SUPPORT="git"
PKG_TOOLCHAIN="cmake-make"

configure_target() {
 mkdir -p build
 cd build
 cmake $PKG_BUILD
}

make_target() {
  make
}

pre_makeinstall_target() {
  mkdir -p $INSTALL/usr/lib
  cp libphysfs.so* $INSTALL/usr/lib
}
