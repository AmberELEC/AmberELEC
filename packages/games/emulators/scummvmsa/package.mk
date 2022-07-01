# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2020-present Fewtarius
# Copyright (C) 2021-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="scummvmsa"
PKG_VERSION="edd4fad03c6a1dee140b08f0eba7b9a0d5f257b7"
PKG_SHA256="47e967b1c6f3e5e7d28333ffd667791af6f6a3bb88bd2af043b9575d8455d0fb"
PKG_REV="1"
PKG_LICENSE="GPL2"
PKG_SITE="https://github.com/scummvm/scummvm"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain SDL2 SDL2_net freetype fluidsynth libmad libtheora"
PKG_SHORTDESC="Script Creation Utility for Maniac Mansion Virtual Machine"
PKG_LONGDESC="ScummVM is a program which allows you to run certain classic graphical point-and-click adventure games, provided you already have their data files."

pre_configure_target() { 
  sed -i "s|sdl-config|sdl2-config|g" $PKG_BUILD/configure
  sed -i "s|static const int guiBaseValues\[\] = { 150, 125, 100, 75, -1 };|static const int guiBaseValues\[\] = { 200, 125, 100, 75, -1 };|g" $PKG_BUILD/gui/options.cpp
  TARGET_CONFIGURE_OPTS="--host=${TARGET_NAME} --backend=sdl --with-sdl-prefix=${SYSROOT_PREFIX}/usr/bin --disable-debug --enable-release --enable-vkeybd --opengl-mode=gles2"
}

post_makeinstall_target() {
  mkdir -p $INSTALL/usr/config/scummvm/
  cp -rf $PKG_DIR/config/* $INSTALL/usr/config/scummvm/
  if [[ "$DEVICE" == RG552 ]]; then
    sed -i "s|gui_scale=100|gui_scale=200|g" $INSTALL/usr/config/scummvm/scummvm.ini
  fi
  
  mkdir -p $INSTALL/usr/config/distribution/modules/
  cp "$PKG_DIR/Scan ScummVM Games.sh" $INSTALL/usr/config/distribution/modules/

  mv $INSTALL/usr/local/bin $INSTALL/usr/
  cp -rf $PKG_DIR/scummvm.sh $INSTALL/usr/bin
  chmod 755 $INSTALL/usr/bin/*
	
  for i in appdata applications doc icons man; do
    rm -rf "$INSTALL/usr/local/share/$i"
  done

  for i in residualvm.zip scummclassic.zip; do
    rm -rf "$INSTALL/usr/local/share/scummvm/$i"
  done
}
