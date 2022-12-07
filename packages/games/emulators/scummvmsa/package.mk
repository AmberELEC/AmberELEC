# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2020-present Fewtarius
# Copyright (C) 2021-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="scummvmsa"
PKG_VERSION="9d827c9915229ccb1210dbd93401e53207ec047d"
PKG_SHA256="5bbc312f9b02343432ace23740e0d1470fa70295ddab8362964a34aa02c3cf6b"
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

  #enable monkey4
  sed -i 's|add_engine monkey4 "Escape from Monkey Island" no|add_engine monkey4 "Escape from Monkey Island" yes|g' $PKG_BUILD/engines/grim/configure.engine
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
