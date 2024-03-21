# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020 Trond Haugland (trondah@gmail.com)
# Copyright (C) 2021-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="pcsx_rearmed2023"
PKG_VERSION="263c6482a45ea118b7e5e4f3939b0cd50f08793e"
PKG_SHA256="dba7e5408cf8a64788ee06fc48ae48893434c9a074380ddb3db0e6ade07facf0"
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
  mv pcsx_rearmed_libretro.so pcsx_rearmed2023_libretro.so
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp ${PKG_BUILD}/pcsx_rearmed2023_libretro.so ${INSTALL}/usr/lib/libretro/
}
