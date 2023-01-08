# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="build-lib32"
PKG_ARCH="arm"
PKG_LICENSE="GPLv2"
PKG_DEPENDS_TARGET="toolchain gcc retroarch libsndfile libmodplug flac SDL2 SDL2_image SDL2_mixer SDL2_net SDL2_ttf SDL2_gfx"
PKG_LONGDESC="ARM 32bit bundle for aarch64"
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  cd ${PKG_BUILD}
  if [ "${ARCH}" = "arm" ]; then
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
      find ${ROOT}/build.${DISTRO}-${DEVICE}.arm/*/.install_pkg -name ${lib} -exec cp -vP \{} ${INSTALL}/usr/lib32 \;
    done
    rm -f ${INSTALL}/usr/lib32/*.ko || :
    chmod -f +x ${INSTALL}/usr/lib32/* || :
    cd ${INSTALL}
    tar -C ${INSTALL} -zcvpf ${PKG_BUILD}/lib32_${DEVICE}.tar.gz usr/lib32
    mkdir -p ${ROOT}/lib32-package
    mv ${PKG_BUILD}/lib32_${DEVICE}.tar.gz ${ROOT}/lib32-package
  fi
}
