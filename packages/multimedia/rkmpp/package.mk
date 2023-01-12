# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="rkmpp"
PKG_VERSION="2e5ea77cb2969a1b240d8154fe42f33d898546f5"
#PKG_SHA256="b2f6478783caa8ffb9698b4207bae3a684fe861ba09cd371414fe26d41a3433e"
PKG_ARCH="arm aarch64"
PKG_LICENSE="APL"
PKG_SITE="https://github.com/rockchip-linux/mpp"
PKG_URL="https://github.com/rockchip-linux/mpp/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain libdrm"
PKG_LONGDESC="rkmpp: Rockchip Media Process Platform (MPP) module"

if [ "${DEVICE}" = "RK3328" -o "${DEVICE}" = "RK3399" ]; then
  PKG_ENABLE_VP9D="ON"
else
  PKG_ENABLE_VP9D="OFF"
fi

PKG_CMAKE_OPTS_TARGET="-DENABLE_VP9D=${PKG_ENABLE_VP9D} \
                       -DHAVE_DRM=ON"
