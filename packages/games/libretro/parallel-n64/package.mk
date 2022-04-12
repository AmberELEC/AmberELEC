# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="parallel-n64"
PKG_VERSION="b804ab1a199d6ff1f8fef4aa7dfcf663990e430b"
PKG_SHA256="918a949deabd9e5025ca5667cbce40a47bd48eb17909dd6af42fb79baf9b05d4"
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
	
	if [[ "${DEVICE}" =~ RG351 ]] || [[ "${DEVICE}" =~ RG552 ]]; then
		PKG_MAKE_OPTS_TARGET=" platform=Odroidgoa"
	fi
else
	PKG_MAKE_OPTS_TARGET=" platform=emuelec64-armv8"
	
fi

if [[ "$DEVICE" == RG351P ]] || [[ "$DEVICE" == RG351V ]]; then
  PKG_PATCH_DIRS="rumble"
fi

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  if [[ "$ARCH" == "aarch64" ]]
  then
    cp -vP $PKG_BUILD/../../build.${DISTRO}-${DEVICE}.arm/parallel-n64-*/.install_pkg/usr/lib/libretro/parallel_n64_libretro.so ${INSTALL}/usr/lib/libretro/
  else
    cp parallel_n64_libretro.so $INSTALL/usr/lib/libretro/
  fi
}
