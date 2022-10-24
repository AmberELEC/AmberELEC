# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020 Trond Haugland (trondah@gmail.com)
# Copyright (C) 2021-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="pcsx_rearmed"
PKG_VERSION="c0c1a5b0163ec977f5cc597a8732e0fce93203f7"
PKG_SHA256="56b081d7a7ba7aa4d079f9ef7a67c24ccc8061111a83539dbcd1e23c8ae79d7c"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/pcsx_rearmed"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SHORTDESC="ARM optimized PCSX fork"
PKG_TOOLCHAIN="manual"

if [[ "$DEVICE" == RG351P ]] || [[ "$DEVICE" == RG351V ]]; then
  PKG_PATCH_DIRS="rumble"
fi

pre_configure_target() {
  sed -i 's/\-O[23]//' ${PKG_BUILD}/Makefile
}

make_target() {
  cd ${PKG_BUILD}
  if [[ "${DEVICE}" =~ RG552 ]]; then
    make -f Makefile.libretro GIT_VERSION=${PKG_VERSION} platform=rk3399
  else
    make -f Makefile.libretro GIT_VERSION=${PKG_VERSION} platform=rk3326
  fi
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp $PKG_BUILD/pcsx_rearmed_libretro.so $INSTALL/usr/lib/libretro/
}
