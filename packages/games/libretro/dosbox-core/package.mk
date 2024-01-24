# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="dosbox-core"
PKG_VERSION="27b6dbe8608ff63aaf8d5b7257a2b08c7d1a7a90"
PKG_SHA256="d5821349004c90f87d2b80525d94bb69624d0a587778483ae7c0b0b8187bae3b"
PKG_ARCH="aarch64"
PKG_SITE="https://github.com/realnc/dosbox-core"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain munt flac fluidsynth libsndfile mpg123 libvorbis libogg opus opusfile alsa-lib SDL_net"
PKG_LONGDESC="A DOSBox core for use in RetroArch and other libretro frontends."
PKG_TOOLCHAIN="make"

pre_configure_target() {
  sed -i 's/\-O[23]//' ${PKG_BUILD}/libretro/Makefile.libretro
}

make_target() {
  cd libretro
  make BUNDLED_AUDIO_CODECS=0 BUNDLED_LIBSNDFILE=0 WITH_CPP20=1 WITH_BASSMIDI=1 WITH_FLUIDSYNTH=1 WITH_PINHACK=1 WITH_DYNAREC=arm64
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp ${PKG_BUILD}/libretro/dosbox_core_libretro.so ${INSTALL}/usr/lib/libretro/
}
