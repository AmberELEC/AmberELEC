# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="capsimg"
PKG_VERSION="457d420848145de6541e47296405b1938830900a"
PKG_SHA256="d32c4d802301e33abef067837a20bc8bc5d9769154820b99408c6a967e8cd402"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/FrodeSolheim/capsimg"
PKG_URL="https://github.com/FrodeSolheim/capsimg/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="SPS Decoder Library 5.1 (formerly IPF Decoder Lib)"
PKG_TOOLCHAIN="make"

PKG_MAKE_OPTS_TARGET="-C CAPSImg"

pre_configure_target() {
  cd ..
  ./bootstrap
  ./configure --host=${TARGET_NAME}
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib
  cp -v  CAPSImg/libcapsimage.so.5.1 ${INSTALL}/usr/lib/
  ln -sf libcapsimage.so.5.1 ${INSTALL}/usr/lib/libcapsimage.so.5
  ln -sf libcapsimage.so.5.1 ${INSTALL}/usr/lib/libcapsimage.so
  mkdir -p ${INSTALL}/usr/local/include/caps5
  cp -v LibIPF/* ${INSTALL}/usr/local/include/caps5
}
