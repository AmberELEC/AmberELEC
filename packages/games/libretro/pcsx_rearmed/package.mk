# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020 Trond Haugland (trondah@gmail.com)

PKG_NAME="pcsx_rearmed"
PKG_VERSION="2c78ad6070f85d9fbf08db1301561a90ba3d54e6"
PKG_SHA256="7936c90a5b2245c281209f644111c68812d9ed76f8bc7323c9225e9518a2f849"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/pcsx_rearmed"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SHORTDESC="ARM optimized PCSX fork"
PKG_TOOLCHAIN="manual"
PKG_BUILD_FLAGS="+speed -gold"

if [[ "$DEVICE" == RG351P ]] || [[ "$DEVICE" == RG351V ]]; then
  PKG_PATCH_DIRS="rumble"
fi

make_target() {
  cd ${PKG_BUILD}
  if [ ! "${ARCH}" = "aarch64" ]; then
    make -f Makefile.libretro GIT_VERSION=${PKG_VERSION} platform=rpi3
  fi
}

makeinstall_target() {
  INSTALLTO="/usr/lib/libretro/"

  mkdir -p ${INSTALL}${INSTALLTO}
  cd ${PKG_BUILD}
  if [ "${ARCH}" = "aarch64" ]; then
    cp -vP ${PKG_BUILD}/../../build.${DISTRO}-${DEVICE}.arm/pcsx_rearmed-*/.install_pkg/usr/lib/libretro/pcsx_rearmed_libretro.so ${INSTALL}${INSTALLTO}
  else
    cp pcsx_rearmed_libretro.so ${INSTALL}${INSTALLTO}
  fi
}
