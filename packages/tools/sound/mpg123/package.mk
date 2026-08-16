# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018-present 5schatten (https://github.com/5schatten)

PKG_NAME="mpg123"
PKG_VERSION="1.33.0"
PKG_SHA256="2290e3aede6f4d163e1a17452165af33caad4b5f0948f99429cfa2d8385faa9d"
PKG_LICENSE="LGPLv2"
PKG_SITE="http://www.mpg123.org/"
PKG_URL="http://www.mpg123.org/download/mpg123-${PKG_VERSION}.tar.bz2"
PKG_DEPENDS_TARGET="toolchain alsa-lib SDL2"
PKG_LONGDESC="A console based real time MPEG Audio Player for Layer 1, 2 and 3."
PKG_BUILD_FLAGS="-fpic"

if [ "${PULSEAUDIO_SUPPORT}" = yes ]; then
  PKG_DEPENDS_TARGET="${PKG_DEPENDS_TARGET} pulseaudio"
  PKG_CONFIGURE_OPTS_TARGET="${PKG_CONFIGURE_OPTS_TARGET} --with-default-audio=pulse --with-audio=alsa,pulse"
fi
