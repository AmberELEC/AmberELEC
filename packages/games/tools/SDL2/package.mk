# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="SDL2"
PKG_VERSION="2.30.3"
PKG_LICENSE="GPL"
PKG_SITE="https://www.libsdl.org/"
PKG_URL="https://www.libsdl.org/release/SDL2-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain alsa-lib systemd dbus ${OPENGLES} pulseaudio libsamplerate"
PKG_DEPENDS_HOST="toolchain:host distutilscross:host"
PKG_LONGDESC="Simple DirectMedia Layer is a cross-platform development library designed to provide low level access to audio, keyboard, mouse, joystick, and graphics hardware."

PKG_DEPENDS_TARGET="${PKG_DEPENDS_TARGET} libdrm ${OPENGLES} librga"

if [ "${DEVICE}" = "RG351P" ] || [ "${DEVICE}" = "RG552" ]; then
  PKG_PATCH_DIRS="rotation"
fi

pre_make_host() {
  sed -i "s| -lrga||g" ${PKG_BUILD}/CMakeLists.txt
}

pre_configure_target(){
  PKG_CMAKE_OPTS_TARGET="-DSDL_STATIC=OFF \
                         -DSDL_LIBC=ON \
                         -DSDL_GCC_ATOMICS=ON \
                         -DSDL_ALTIVEC=OFF \
                         -DSDL_OSS=OFF \
                         -DSDL_ALSA=ON \
                         -DSDL_ALSA_SHARED=ON \
                         -DSDL_JACK=OFF \
                         -DSDL_JACK_SHARED=OFF \
                         -DSDL_ESD=OFF \
                         -DSDL_ESD_SHARED=OFF \
                         -DSDL_ARTS=OFF \
                         -DSDL_ARTS_SHARED=OFF \
                         -DSDL_NAS=OFF \
                         -DSDL_NAS_SHARED=OFF \
                         -DSDL_LIBSAMPLERATE=ON \
                         -DSDL_LIBSAMPLERATE_SHARED=OFF \
                         -DSDL_SNDIO=OFF \
                         -DSDL_DISKAUDIO=OFF \
                         -DSDL_DUMMYAUDIO=OFF \
                         -DSDL_WAYLAND=OFF \
                         -DSDL_WAYLAND_QT_TOUCH=OFF \
                         -DSDL_WAYLAND_SHARED=OFF \
                         -DSDL_COCOA=OFF \
                         -DSDL_DIRECTFB=OFF \
                         -DSDL_VIVANTE=OFF \
                         -DSDL_DIRECTFB_SHARED=OFF \
                         -DSDL_FUSIONSOUND=OFF \
                         -DSDL_FUSIONSOUND_SHARED=OFF \
                         -DSDL_DUMMYVIDEO=OFF \
                         -DSDL_PTHREADS=ON \
                         -DSDL_PTHREADS_SEM=ON \
                         -DSDL_DIRECTX=OFF \
                         -DSDL_CLOCK_GETTIME=OFF \
                         -DSDL_RPATH=OFF \
                         -DSDL_RENDER_D3D=OFF \
                         -DSDL_X11=OFF \
                         -DSDL_OPENGLES=ON \
                         -DSDL_VULKAN=OFF \
                         -DSDL_KMSDRM=ON \
                         -DSDL_PULSEAUDIO=ON"
  export LDFLAGS="${LDFLAGS} -lrga"
}

post_makeinstall_target() {
  sed -e "s:\(['=LI]\)/usr:\\1${SYSROOT_PREFIX}/usr:g" -i ${SYSROOT_PREFIX}/usr/bin/sdl2-config
  rm -rf ${INSTALL}/usr/bin
}
