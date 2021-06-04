# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Fewtarius

PKG_NAME="retroarch32"
PKG_ARCH="aarch64"
PKG_LICENSE="GPLv2"
PKG_DEPENDS_TARGET="toolchain"
PKG_SHORTDESC="ARM 32bit retroarch bundle for aarch64"
PKG_PRIORITY="optional"
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  cd ${PKG_BUILD}
  VERSION=${LIBREELEC_VERSION}
  INSTALLTO="/usr/lib/libretro/"

  mkdir -p ${INSTALL}${INSTALLTO}

  if [ "${ARCH}" = "aarch64" ]; then
      mkdir -p ${INSTALL}/usr/bin
      mkdir -p ${INSTALL}/usr/lib32
      LIBS="ld-2.*.so \
		ld-linux-armhf* \
		libarmmem-v7l* \
		librt* \
		libass* \
		libasound* \
		libopenal* \
		libpulse* \
		libfreetype* \
		libpthread* \
		libudev.so* \
		libusb-1.0* \
		libSDL2-2.0* \
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
    rm -f ${INSTALL}/usr/lib32/libmali.so
    ln -sf libmali.so.1 ${INSTALL}/usr/lib32/libmali.so
    cp -vP $PKG_BUILD/../../build.${DISTRO}-${DEVICE}.arm/retroarch-*/.install_pkg/usr/bin/retroarch ${INSTALL}/usr/bin/retroarch32
    patchelf --set-interpreter /usr/lib32/ld-linux-armhf.so.3 ${INSTALL}/usr/bin/retroarch32
    chmod -f +x ${INSTALL}/usr/lib32/* || :
  fi
}
