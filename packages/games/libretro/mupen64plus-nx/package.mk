# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Fewtarius

PKG_NAME="mupen64plus-nx"
PKG_VERSION="3f794eec4dc4af2f22ecce507f2da324381d3d92"
PKG_SHA256="7492fbcc60af0dd9b82f9ec04d6765fe3c0baf6197f6076f3c22b2a303047ebf"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/mupen64plus-libretro-nx"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain nasm:host ${OPENGLES}"
PKG_LONGDESC="mupen64plus NX"
PKG_TOOLCHAIN="make"

pre_configure_target() {
  sed -e "s|^GIT_VERSION ?.*$|GIT_VERSION := \" ${PKG_VERSION:0:7}\"|" -i Makefile

  if [ "${DEVICE}" = "RG552" ]; then
    PKG_MAKE_OPTS_TARGET+=" platform=RK3399 HAVE_PARALLEL_RSP=1"
  else
    PKG_MAKE_OPTS_TARGET+=" platform=RK3326 HAVE_PARALLEL_RSP=1"
  fi
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp mupen64plus_next_libretro.so ${INSTALL}/usr/lib/libretro/
}
