# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="parallel-n64"
PKG_VERSION="6e26fbbc5a85f9613a01c1880142add81d618e19"
PKG_SHA256="9e88d2039bc7ccda0919f75b464c83b09f466aee4de215289c6b09e12da4756f"
PKG_REV="2"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/parallel-n64"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain $OPENGLES"
PKG_SECTION="libretro"
PKG_SHORTDESC="Optimized/rewritten Nintendo 64 emulator made specifically for Libretro. Originally based on Mupen64 Plus."
PKG_LONGDESC="Optimized/rewritten Nintendo 64 emulator made specifically for Libretro. Originally based on Mupen64 Plus."
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="-lto"

if [[ "$ARCH" == "arm" ]]; then
	PKG_MAKE_OPTS_TARGET=" platform=${PROJECT}"
	
	if [ "${DEVICE}" == "RG351P" ]; then
		PKG_MAKE_OPTS_TARGET=" platform=Odroidgoa"
	fi
else
	PKG_MAKE_OPTS_TARGET=" platform=emuelec64-armv8"
	
fi

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  if [[ "${DEVICE}" == "RG351P" ]] && [[ "$ARCH" == "aarch64" ]]
  then
    cp -vP $PKG_BUILD/../../build.${DISTRO}-${DEVICE}.arm-${LIBREELEC_VERSION}/parallel-n64-*/.install_pkg/usr/lib/libretro/parallel_n64_libretro.so ${INSTALL}/usr/lib/libretro/
  else
    cp parallel_n64_libretro.so $INSTALL/usr/lib/libretro/
  fi
}
