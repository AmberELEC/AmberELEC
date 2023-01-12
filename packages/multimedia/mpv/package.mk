# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="mpv"
PKG_VERSION="05bc366d18c72e94ee07448e2cfa28102e9c0766"
PKG_SHA256="bb3563fb8c8a544ba1c31e43e751bf76156d5f13206b56f27d831b97ae634c7f"
PKG_LICENSE="GPLv2+"
PKG_SITE="https://github.com/mpv-player/mpv"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain ffmpeg SDL2 ${OPENGLES} waf:host"
PKG_LONGDESC="Video player based on MPlayer/mplayer2 https://mpv.io"
PKG_TOOLCHAIN="manual"

pre_configure_target() {
  cp -f ${TOOLCHAIN}/bin/waf ${PKG_BUILD}
}

configure_target() {
  cd ${PKG_BUILD}
  ${PKG_BUILD}/waf configure --enable-sdl2 --enable-sdl2-gamepad --disable-pulse --enable-egl --disable-libbluray --disable-gl
}

make_target() {
  ${PKG_BUILD}/waf build
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/bin
  cp ./build/mpv ${INSTALL}/usr/bin
}
