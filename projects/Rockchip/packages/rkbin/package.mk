# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="rkbin"
PKG_SITE="https://github.com/AmberELEC/rkbin"

if [[ "${DEVICE}" =~ RG351 ]]; then
	PKG_VERSION="0bb1c512492386a72a3a0b5a0e18e49c636577b9"
elif [[ "${DEVICE}" == RG552 ]]; then
	PKG_VERSION="fc44f9401c127affb2a879c1e90fa89ddab505f6"
elif [ "${DEVICE}" = "RG353" ]; then
	PKG_VERSION="5257e54cc6c15fef28c3b73bd95ca1b55cc8c8cd"
	PKG_SITE="https://github.com/RetroGFX/rkbin"
fi

PKG_ARCH="arm aarch64"
PKG_LICENSE="nonfree"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_LONGDESC="rkbin: Rockchip Firmware and Tool Binaries"
PKG_TOOLCHAIN="manual"
