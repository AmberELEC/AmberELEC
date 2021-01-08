# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020 Trond Haugland (trondah@gmail.com)

PKG_NAME="pcsx_rearmed"
PKG_VERSION="bde5ee93147e22965118455b8397d4b28ed7743d"
PKG_SHA256="69fdb41dd33f4e850279190f3a5e6bcb834e31cb4c3ba5df5329cabc63c860cb"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/pcsx_rearmed"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SHORTDESC="ARM optimized PCSX fork"
PKG_TOOLCHAIN="manual"
PKG_BUILD_FLAGS="+speed -gold"

makeinstall_target() {
  cd ${PKG_BUILD}
  if [ "${ARCH}" != "aarch64" ]; then
    make -f Makefile.libretro GIT_VERSION=${PKG_VERSION} platform=rpi3
  fi

# Thanks to escalade for the multilib solution! https://forum.odroid.com/viewtopic.php?f=193&t=39281

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
		libdl* \
		libMali* \
		libdrm* \
		librga* \
		libpng* \
		librockchip_mpp* \
		libxkbcommon* \
		libresolv* \
		libnss_dns* \
		libpthread* \
		libmali*"

    for lib in ${LIBS}
    do 
      find $PKG_BUILD/../../build.${DISTRO}-${DEVICE}.arm-${VERSION}/*/.install_pkg -name ${lib} -exec cp -vP \{} ${INSTALL}/usr/lib32 \;
    done
    rm -f ${INSTALL}/usr/lib32/libmali.so
    ln -sf /usr/lib32/libmali.so.1 ${INSTALL}/usr/lib32/libmali.so
    cp -vP $PKG_BUILD/../../build.${DISTRO}-${DEVICE}.arm-${VERSION}/retroarch-*/.install_pkg/usr/bin/retroarch ${INSTALL}/usr/bin/retroarch32
    patchelf --set-interpreter /usr/lib32/ld-linux-armhf.so.3 ${INSTALL}/usr/bin/retroarch32
    cp -vP $PKG_BUILD/../../build.${DISTRO}-${DEVICE}.arm-${VERSION}/pcsx_rearmed-*/.install_pkg/usr/lib/libretro/pcsx_rearmed_libretro.so ${INSTALL}${INSTALLTO}
    chmod -f +x ${INSTALL}/usr/lib32/* || :
else
    cp pcsx_rearmed_libretro.so ${INSTALL}${INSTALLTO}
fi
}
