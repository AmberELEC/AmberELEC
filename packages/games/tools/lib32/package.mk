# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="lib32"
PKG_ARCH="aarch64"
PKG_LICENSE="GPLv2"
PKG_DEPENDS_TARGET="toolchain retroarch SDL2 libsndfile libmodplug flac"
PKG_SHORTDESC="ARM 32bit bundle for aarch64"
PKG_PRIORITY="optional"
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  cd ${PKG_BUILD}
  if [ "${ARCH}" = "aarch64" ]; then
      mkdir -p ${INSTALL}/usr/lib32
      LIBS="ld-2.*.so \
		ld-linux-armhf* \
		libarmmem-v7l* \
		libatomic* \
		librt* \
		libass* \
		libasound* \
		libopenal* \
		libpulse* \
		libfreetype* \
		libpthread* \
		libudev.so* \
		libusb-1.0* \
		libSDL2* \
		libFLAC* \
		libmodplug* \
		libsndfile* \
		libvorbis* \
		libFLAC* \
		libavcodec* \
		libavformat* \
		libavutil* \
		libswscale* \
		libswresample* \
		libstdc++* \
		libm* \
		libgcc_s* \
		libc* \
		libfontconfig* \
		libexpat* \
		libbz2* \
		libz* \
		libpulsecommon-12* \
		libdbus-1* \
		libdav1d* \
		libspeex* \
		libssl* \
		libcrypt* \
		libsystemd* \
		libncurses* \
		libdl* \
		libMali* \
		libdrm* \
		librga* \
		libpng* \
		libjpeg* \
		libturbojpeg* \
		libgo2* \
		libevdev* \
		librockchip_mpp* \
		libxkbcommon* \
		libresolv* \
		libnss_dns* \
		libpthread* \
		libmali* \
		libGLES* \
		libgnutls* \
		libgbm* \
		libidn2* \
		libnettle* \
		libhogweed* \
		libgmp* \
		libuuid.so* \
		libEG*"

    for lib in ${LIBS}
    do
      find $PKG_BUILD/../../build.${DISTRO}-${DEVICE}.arm/*/.install_pkg -name ${lib} -exec cp -vP \{} ${INSTALL}/usr/lib32 \;
    done
    chmod -f +x ${INSTALL}/usr/lib32/* || :
  fi
}