# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="rkbin"

if [[ "${DEVICE}" =~ RG351 ]]; then
	PKG_VERSION="0bb1c512492386a72a3a0b5a0e18e49c636577b9"
elif [[ "${DEVICE}" == RG552 ]]; then
	PKG_VERSION="fc44f9401c127affb2a879c1e90fa89ddab505f6"
fi

PKG_ARCH="arm aarch64"
PKG_LICENSE="nonfree"
PKG_SITE="https://github.com/AmberELEC/rkbin"
PKG_URL="https://github.com/AmberELEC/rkbin/archive/${PKG_VERSION}.tar.gz"
PKG_LONGDESC="rkbin: Rockchip Firmware and Tool Binaries"
PKG_TOOLCHAIN="manual"
