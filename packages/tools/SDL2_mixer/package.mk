# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Team CoreELEC (https://coreelec.org)

PKG_NAME="SDL2_mixer"
PKG_VERSION="2.8.2"
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
  # Sync staged target files into the toolchain sysroot so CMake can find them
  if [ ! -f "${SYSROOT_PREFIX}/usr/lib/libSDL2.so" ]; then
    mkdir -p "${SYSROOT_PREFIX}/usr"
    
    # 1. Copy from image/system if present
    if [ -d "${BUILD}/image/system/usr" ]; then
      cp -PR ${BUILD}/image/system/usr/* "${SYSROOT_PREFIX}/usr/" 2>/dev/null || true
    fi
    
    # 2. Copy from package staging areas (.install_pkg)
    for pkg in SDL2 opusfile libmodplug fluidsynth; do
      STAGING_DIR=$(ls -d ${BUILD}/${pkg}*/.install_pkg/usr 2>/dev/null | head -n 1)
      if [ -n "${STAGING_DIR}" ] && [ -d "${STAGING_DIR}" ]; then
        cp -PR ${STAGING_DIR}/* "${SYSROOT_PREFIX}/usr/" 2>/dev/null || true
      fi
    done
  fi


  PKG_CMAKE_OPTS_TARGET="-DSDL2_INCLUDE_DIR=${SYSROOT_PREFIX}/usr/include/SDL2 \
                         -DSDL2_LIBRARY=${SYSROOT_PREFIX}/usr/lib/libSDL2.so \
                         -DOpusFile_INCLUDE_PATH=${SYSROOT_PREFIX}/usr/include/opus \
                         -DOpusFile_LIBRARY=${SYSROOT_PREFIX}/usr/lib/libopusfile.so \
                         -Dmodplug_INCLUDE_PATH=${SYSROOT_PREFIX}/usr/include/libmodplug \
                         -Dmodplug_LIBRARY=${SYSROOT_PREFIX}/usr/lib/libmodplug.so \
                         -DFLAC_INCLUDE_PATH=${SYSROOT_PREFIX}/usr/include \
                         -DFLAC_LIBRARY=${SYSROOT_PREFIX}/usr/lib/libFLAC.so \
                         -DFluidSynth_INCLUDE_PATH=${SYSROOT_PREFIX}/usr/include \
                         -DFluidSynth_LIBRARY=${SYSROOT_PREFIX}/usr/lib/libfluidsynth.so \
                         -Dfluidsynth_INCLUDE_PATH=${SYSROOT_PREFIX}/usr/include \
                         -Dfluidsynth_LIBRARY=${SYSROOT_PREFIX}/usr/lib/libfluidsynth.so \
                         -DTremor_INCLUDE_PATH=${SYSROOT_PREFIX}/usr/include/tremor \
                         -DTremor_LIBRARY=${SYSROOT_PREFIX}/usr/lib/libvorbisidec.so \
                         -Dtremor_INCLUDE_PATH=${SYSROOT_PREFIX}/usr/include/tremor \
                         -Dtremor_LIBRARY=${SYSROOT_PREFIX}/usr/lib/libvorbisidec.so \
                         -DMPG123_INCLUDE_PATH=${SYSROOT_PREFIX}/usr/include \
                         -DMPG123_LIBRARY=${SYSROOT_PREFIX}/usr/lib/libmpg123.so \
                         -Dmpg123_INCLUDE_PATH=${SYSROOT_PREFIX}/usr/include \
                         -Dmpg123_LIBRARY=${SYSROOT_PREFIX}/usr/lib/libmpg123.so \
                         -DSDL2MIXER_OPUS=ON \
                         -DSDL2MIXER_MIDI_FLUIDSYNTH=ON \
                         -DSDL2MIXER_FLAC=ON \
                         -DSDL2MIXER_MOD_MODPLUG=ON \
                         -DSDL2MIXER_VORBIS_TREMOR=ON \
                         -DSDL2MIXER_OGG=ON \
                         -DSDL2MIXER_MP3=ON \
                         -DSDL2MIXER_SAMPLES=OFF \
                         -DSDL2MIXER_MOD_XMP=OFF \
                         -DSDL2MIXER_WAVPACK=OFF"
}
