# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="mpv"
PKG_VERSION="7eb8f81091008d4e90dfc758df27342a541327f3"
PKG_SHA256="5ecaa44664326b84583415afe88bfa92c15d16a50a34c92f20c4f7b5261cc64f"
PKG_LICENSE="GPLv2+"
PKG_SITE="https://github.com/mpv-player/mpv"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain ffmpeg SDL2 ${OPENGLES}"
PKG_LONGDESC="Video player based on MPlayer/mplayer2 https://mpv.io"
PKG_TOOLCHAIN="manual"

configure_target() {
  #./bootstrap.py 
  # the bootstrap was failing for some reason. 
  cp ${PKG_DIR}/waf/* ${PKG_BUILD}  
  cd ${PKG_BUILD}
  ./waf configure --enable-sdl2 --enable-sdl2-gamepad --disable-pulse --enable-egl --disable-libbluray --disable-gl
}

make_target() {
  ./waf build
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/bin
  cp ./build/mpv ${INSTALL}/usr/bin
}
