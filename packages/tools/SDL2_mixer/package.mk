# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Team CoreELEC (https://coreelec.org)

PKG_NAME="SDL2_mixer"
PKG_VERSION="2.8.0"
PKG_LICENSE="GPLv3"
PKG_SITE="http://www.libsdl.org/projects/SDL_mixer/release"
PKG_URL="${PKG_SITE}/${PKG_NAME}-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain alsa-lib SDL2 libogg libvorbis flac mpg123 libmodplug libvorbisidec opusfile fluidsynth"
PKG_LONGDESC="An audio mixer that supports various file formats for Simple Directmedia Layer. "
PKG_DEPENDS_HOST="toolchain:host SDL2:host"

pre_configure_host() {
  PKG_CMAKE_OPTS_HOST="-DSDL2MIXER_OPUS=OFF \
                       -DSDL2MIXER_MOD=OFF \
                       -DSDL2MIXER_MP3=OFF \
                       -DSDL2MIXER_FLAC=OFF \
                       -DSDL2MIXER_MIDI=OFF \
                       -DSDL2MIXER_VORBIS=OFF \
                       -DSDL2MIXER_OGG=OFF \
                       -DSDL2MIXER_MOD_XMP=OFF \
                       -DSDL2MIXER_WAVPACK=OFF"
}

pre_configure_target() {
PKG_CMAKE_OPTS_TARGET="-DSDL2MIXER_MIDI_FLUIDSYNTH=ON \
                       -DSDL2MIXER_FLAC=ON \
                       -DSDL2MIXER_MOD_MODPLUG=ON \
                       -DSDL2MIXER_VORBIS_TREMOR=ON \
                       -DSDL2MIXER_OGG=ON \
                       -DSDL2MIXER_MP3=ON \
                       -DSDL2MIXER_SAMPLES=OFF \
                       -DSDL2MIXER_MOD_MODPLUG_SHARED=OFF \
                       -DSDL2MIXER_MOD_XMP=OFF \
                       -DSDL2MIXER_WAVPACK=OFF"
}
