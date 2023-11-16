# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020 Trond Haugland (trondah@gmail.com)
# Copyright (C) 2021-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="pcsx_rearmed"
PKG_VERSION="9159f799aba897c27569a7a51a40736bd8a90d2f"
PKG_SHA256="e99764df7c7214a2ed30cd8a2332f8134c314951284b3be7850a171d396694a2"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/pcsx_rearmed"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="ARM optimized PCSX fork"
PKG_TOOLCHAIN="manual"

if [[ "${DEVICE}" == RG351P ]] || [[ "${DEVICE}" == RG351V ]]; then
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
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp ${PKG_BUILD}/pcsx_rearmed_libretro.so ${INSTALL}/usr/lib/libretro/
}
