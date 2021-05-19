# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="lzdoom"
PKG_VERSION="3579a01994f19469d28a9b94a4d97561f40868eb"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/drfrag666/gzdoom"
PKG_GIT_CLONE_BRANCH="g3.3mgw"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain SDL2 lzdoom:host"
PKG_SHORTDESC="LZDoom"
PKG_LONGDESC="ZDoom is a family of enhanced ports of the Doom engine for running on modern operating systems. It runs on Windows, Linux, and OS X, and adds new features not found in the games as originally published by id Software."
GET_HANDLER_SUPPORT="git"
PKG_TOOLCHAIN="cmake-make"

pre_build_host() {
HOST_CMAKE_OPTS=""
}

make_host() {
  cmake . -DNO_GTK=ON
  make
}

makeinstall_host() {
: #no
}

pre_configure_target() {
PKG_CMAKE_OPTS_TARGET=" -DNO_GTK=ON \
                        -DFORCE_CROSSCOMPILE=ON \
                        -DIMPORT_EXECUTABLES=$PKG_BUILD/.$HOST_NAME/ImportExecutables.cmake
                        -DCMAKE_BUILD_TYPE=Release"
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/local/bin
  cd $PKG_BUILD
  cp .$TARGET_NAME/lzdoom $INSTALL/usr/local/bin

  mkdir -p $INSTALL/usr/config/distribution/lzdoom
  cp $PKG_DIR/config/* $INSTALL/usr/config/distribution/lzdoom
  cp .$TARGET_NAME/*.pk3 $INSTALL/usr/config/distribution/lzdoom
  cp -r .$TARGET_NAME/soundfonts $INSTALL/usr/config/distribution/lzdoom

  mkdir -p $INSTALL/usr/local/bin
  cp $PKG_DIR/scripts/*  $INSTALL/usr/local/bin
}
