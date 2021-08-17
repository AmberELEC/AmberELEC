################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.tv; see the file COPYING.  If not, write to
#  the Free Software Foundation, 51 Franklin Street, Suite 500, Boston, MA 02110, USA.
#  http://www.gnu.org/copyleft/gpl.html
################################################################################

PKG_NAME="retroarch"
PKG_VERSION="c226bd87f47b3fdec642216fcaf6edc651e30eb4"
PKG_SITE="https://github.com/libretro/RetroArch"
PKG_URL="$PKG_SITE.git"
PKG_LICENSE="GPLv3"
PKG_DEPENDS_TARGET="toolchain SDL2 alsa-lib openssl freetype zlib retroarch-assets retroarch-overlays core-info ffmpeg libass joyutils empty $OPENGLES samba avahi nss-mdns openal-soft libogg libvorbisidec libvpx libpng16"
PKG_LONGDESC="Reference frontend for the libretro API."
GET_HANDLER_SUPPORT="git"

if [ ${PROJECT} = "Amlogic-ng" ]; then
  PKG_PATCH_DIRS="${PROJECT}"
fi

if [[ "$DEVICE" =~ RG351 ]]; then
PKG_DEPENDS_TARGET+=" libdrm librga"
fi

# Pulseaudio Support
  if [ "${PULSEAUDIO_SUPPORT}" = yes ]; then
    PKG_DEPENDS_TARGET+=" pulseaudio"
fi

pre_configure_target() {
# Retroarch does not like -O3 for CHD loading with cheevos
#export CFLAGS="`echo $CFLAGS | sed -e "s|-O.|-O2|g"`"

TARGET_CONFIGURE_OPTS=""
PKG_CONFIGURE_OPTS_TARGET="--disable-qt \
                           --enable-alsa \
                           --enable-udev \
                           --disable-opengl1 \
                           --disable-opengl \
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
                           --enable-ffmpeg"

if [[ "$DEVICE" =~ RG351 ]]
then
  PKG_CONFIGURE_OPTS_TARGET+=" --enable-opengles3 \
                             --enable-kms \
                             --disable-mali_fbdev"
else
  PKG_CONFIGURE_OPTS_TARGET+=" --disable-kms \
                             --enable-mali_fbdev"
fi

if [[ "$DEVICE" == "RG351P" ]]
then
  PKG_CONFIGURE_OPTS_TARGET+=" --enable-odroidgo2"
fi

if [ $ARCH == "arm" ]; then
  PKG_CONFIGURE_OPTS_TARGET+=" --enable-neon"
fi

cd $PKG_BUILD
}

make_target() {
  make HAVE_UPDATE_ASSETS=1 HAVE_LIBRETRODB=1 HAVE_NETWORKING=1 HAVE_LAKKA=1 HAVE_ZARCH=1 HAVE_QT=0 HAVE_LANGEXTRA=1
  [ $? -eq 0 ] && echo "(retroarch ok)" || { echo "(retroarch failed)" ; exit 1 ; }
  make -C gfx/video_filters compiler=$CC extra_flags="$CFLAGS"
[ $? -eq 0 ] && echo "(video filters ok)" || { echo "(video filters failed)" ; exit 1 ; }
  make -C libretro-common/audio/dsp_filters compiler=$CC extra_flags="$CFLAGS"
[ $? -eq 0 ] && echo "(audio filters ok)" || { echo "(audio filters failed)" ; exit 1 ; }
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
  mkdir -p $INSTALL/etc
    cp $PKG_BUILD/retroarch $INSTALL/usr/bin

    cp $PKG_BUILD/retroarch.cfg $INSTALL/etc
  mkdir -p $INSTALL/usr/share/video_filters
    cp $PKG_BUILD/gfx/video_filters/*.so $INSTALL/usr/share/video_filters
    cp $PKG_BUILD/gfx/video_filters/*.filt $INSTALL/usr/share/video_filters
  mkdir -p $INSTALL/usr/share/audio_filters
    cp $PKG_BUILD/libretro-common/audio/dsp_filters/*.so $INSTALL/usr/share/audio_filters
    cp $PKG_BUILD/libretro-common/audio/dsp_filters/*.dsp $INSTALL/usr/share/audio_filters

   # General configuration
   mkdir -p $INSTALL/usr/config/retroarch/
   cp -rf $PKG_DIR/sources/* $INSTALL/usr/config/retroarch/ 
 
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
