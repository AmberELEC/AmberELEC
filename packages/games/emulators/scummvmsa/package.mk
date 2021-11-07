# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2020-present Fewtarius

PKG_NAME="scummvmsa"
PKG_VERSION="81a24aa152e064dc6b0711b88e461d71e3b3830f"
PKG_SHA256="b75e6e7e602025b2ef4be0b348bc9f08d831b7cef818cd8de87a879df350eb7e"
PKG_REV="1"
PKG_LICENSE="GPL2"
PKG_SITE="https://github.com/scummvm/scummvm"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain SDL2 SDL2_net freetype fluidsynth-git"
PKG_SHORTDESC="Script Creation Utility for Maniac Mansion Virtual Machine"
PKG_LONGDESC="ScummVM is a program which allows you to run certain classic graphical point-and-click adventure games, provided you already have their data files."

pre_configure_target() { 
  sed -i "s|sdl-config|sdl2-config|g" $PKG_BUILD/configure
  TARGET_CONFIGURE_OPTS="--host=${TARGET_NAME} --backend=sdl --with-sdl-prefix=${SYSROOT_PREFIX}/usr/bin --disable-debug --enable-release --enable-vkeybd --opengl-mode=gles2 --force-opengl-game-es2"
}

post_makeinstall_target() {
  mkdir -p $INSTALL/usr/config/scummvm/
  cp -rf $PKG_DIR/config/* $INSTALL/usr/config/scummvm/

  mv $INSTALL/usr/local/bin $INSTALL/usr/
  cp -rf $PKG_DIR/bin/* $INSTALL/usr/bin
  chmod 755 $INSTALL/usr/bin/*
	
  for i in appdata applications doc icons man; do
    rm -rf "$INSTALL/usr/local/share/$i"
  done

  for i in residualvm.zip scummmodern.zip scummclassic.zip; do
    rm -rf "$INSTALL/usr/local/share/scummvm/$i"
  done

  if [[ "$DEVICE" == RG351P ]]; then
    mkdir -p $INSTALL/usr/local/share/scummvm/
    cp -rf $PKG_DIR/scummremastered.zip $INSTALL/usr/local/share/scummvm/
  fi
}

