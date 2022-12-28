# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="dosbox-core"
PKG_VERSION="4032f8ba364e8594fd8e160121f6b13f6ee2bf65"
PKG_SHA256="8d8da47840e7925772b28f159965d8e1796904df05fb9e32f8070307c1310652"
PKG_ARCH="aarch64"
PKG_SITE="https://github.com/realnc/dosbox-core"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain munt flac fluidsynth libsndfile mpg123 libvorbis libogg opus alsa-lib"
PKG_SECTION="libretro"
PKG_SHORTDESC="A DOSBox core for use in RetroArch and other libretro frontends."
PKG_TOOLCHAIN="make"

pre_configure_target() {
  sed -i 's/\-O[23]//' ${PKG_BUILD}/libretro/Makefile.libretro
}

make_target() {
  cd libretro
  make BUNDLED_AUDIO_CODECS=0 BUNDLED_LIBSNDFILE=0 WITH_CPP20=1 WITH_BASSMIDI=1 WITH_FLUIDSYNTH=1 WITH_PINHACK=1 WITH_DYNAREC=arm64
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp $PKG_BUILD/libretro/dosbox_core_libretro.so $INSTALL/usr/lib/libretro/
}
