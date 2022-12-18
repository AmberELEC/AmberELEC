# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="retroarch"
PKG_VERSION="ad89b0c655fc1d25adfcdf40268e95c5d0391111"
PKG_SITE="https://github.com/libretro/RetroArch"
PKG_URL="$PKG_SITE.git"
PKG_LICENSE="GPLv3"
PKG_DEPENDS_TARGET="toolchain SDL2 alsa-lib openssl freetype zlib retroarch-assets core-info ffmpeg libass joyutils empty $OPENGLES nss-mdns openal-soft libogg libvorbis libvorbisidec libvpx libpng libdrm librga pulseaudio"
PKG_LONGDESC="Reference frontend for the libretro API."

if [[ "$DEVICE" == RG351V ]]; then
  PKG_PATCH_DIRS="$DEVICE"
fi

if [[ "$DEVICE" =~ RG351 ]]; then
  PKG_PATCH_DIRS="ui-patches"
fi

pre_configure_target() {
  TARGET_CONFIGURE_OPTS=""
  PKG_CONFIGURE_OPTS_TARGET="--disable-qt \
                             --enable-alsa \
                             --enable-udev \
                             --disable-opengl1 \
                             --disable-opengl \
                             --disable-vulkan \
                             --disable-vulkan_display \
                             --enable-egl \
                             --enable-opengles \
                             --disable-wayland \
                             --disable-x11 \
                             --enable-zlib \
                             --enable-freetype \
                             --disable-discord \
                             --disable-vg \
                             --disable-sdl \
                             --enable-sdl2 \
                             --disable-ffmpeg \
                             --enable-opengles3 \
                             --enable-opengles3_2 \
                             --enable-kms \
                             --disable-mali_fbdev \
                             --enable-odroidgo2"

  if [ $ARCH == "arm" ]; then
    PKG_CONFIGURE_OPTS_TARGET+=" --enable-neon"
  fi

  cd $PKG_BUILD
}

make_target() {
  make HAVE_LIBRETRODB=1 HAVE_NETWORKING=1 HAVE_LAKKA=1 HAVE_ZARCH=1 HAVE_QT=0 HAVE_LANGEXTRA=1
  [ $? -eq 0 ] && echo "(retroarch ok)" || { echo "(retroarch failed)" ; exit 1 ; }
  make -C gfx/video_filters compiler=$CC extra_flags="$CFLAGS"
  [ $? -eq 0 ] && echo "(video filters ok)" || { echo "(video filters failed)" ; exit 1 ; }
  make -C libretro-common/audio/dsp_filters compiler=$CC extra_flags="$CFLAGS"
  [ $? -eq 0 ] && echo "(audio filters ok)" || { echo "(audio filters failed)" ; exit 1 ; }
}

makeinstall_target() {
  if [ "${ARCH}" == "aarch64" ]; then
    mkdir -p $INSTALL/usr/bin
    cp $PKG_BUILD/retroarch $INSTALL/usr/bin
    #cp -vP $PKG_BUILD/../../build.${DISTRO}-${DEVICE}.arm/retroarch-*/.install_pkg/usr/bin/retroarch ${INSTALL}/usr/bin/retroarch32

    mkdir -p $INSTALL/usr/share/retroarch/filters
    #cp -rvP $PKG_BUILD/../../build.${DISTRO}-${DEVICE}.arm/retroarch-*/.install_pkg/usr/share/retroarch/filters/* ${INSTALL}/usr/share/retroarch/filters

    mkdir -p $INSTALL/etc
    cp $PKG_BUILD/retroarch.cfg $INSTALL/etc

    mkdir -p $INSTALL/usr/share/retroarch/filters/64bit/video
    cp $PKG_BUILD/gfx/video_filters/*.so $INSTALL/usr/share/retroarch/filters/64bit/video
    cp $PKG_BUILD/gfx/video_filters/*.filt $INSTALL/usr/share/retroarch/filters/64bit/video

    mkdir -p $INSTALL/usr/share/retroarch/filters/64bit/audio
    cp $PKG_BUILD/libretro-common/audio/dsp_filters/*.so $INSTALL/usr/share/retroarch/filters/64bit/audio
    cp $PKG_BUILD/libretro-common/audio/dsp_filters/*.dsp $INSTALL/usr/share/retroarch/filters/64bit/audio

    # General configuration
    mkdir -p $INSTALL/usr/config/retroarch/
    cp -rf $PKG_DIR/sources/* $INSTALL/usr/config/retroarch/
  else
    mkdir -p $INSTALL/usr/bin
    cp $PKG_BUILD/retroarch $INSTALL/usr/bin

    mkdir -p $INSTALL/usr/share/retroarch/filters/32bit/video
    cp $PKG_BUILD/gfx/video_filters/*.so $INSTALL/usr/share/retroarch/filters/32bit/video
    cp $PKG_BUILD/gfx/video_filters/*.filt $INSTALL/usr/share/retroarch/filters/32bit/video

    mkdir -p $INSTALL/usr/share/retroarch/filters/32bit/audio
    cp $PKG_BUILD/libretro-common/audio/dsp_filters/*.so $INSTALL/usr/share/retroarch/filters/32bit/audio
    cp $PKG_BUILD/libretro-common/audio/dsp_filters/*.dsp $INSTALL/usr/share/retroarch/filters/32bit/audio
  fi
}

post_install() {
  enable_service retroarch.service
  enable_service tmp-cores.mount
  enable_service tmp-joypads.mount
  enable_service tmp-database.mount
  enable_service tmp-assets.mount
  enable_service tmp-shaders.mount
  enable_service tmp-overlays.mount
}
