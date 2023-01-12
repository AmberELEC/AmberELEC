# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="rkbin"

if [[ "${DEVICE}" =~ RG351 ]]; then
	PKG_VERSION="0bb1c512492386a72a3a0b5a0e18e49c636577b9"
	#PKG_SHA256="39289966b39c7bd5b2e5031d12f071e1aa80b80dc83c74b8658b3c119b6d5fd5"
elif [[ "${DEVICE}" =~ RG552 ]]; then
	PKG_VERSION="b46c088e6f40bb5a2c513af4ab593a21f83c0e83"
	#PKG_SHA256="39289966b39c7bd5b2e5031d12f071e1aa80b80dc83c74b8658b3c119b6d5fd5"
fi

PKG_ARCH="arm aarch64"
PKG_LICENSE="nonfree"
PKG_SITE="https://github.com/AmberELEC/rkbin"
PKG_URL="https://github.com/AmberELEC/rkbin/archive/${PKG_VERSION}.tar.gz"
PKG_LONGDESC="rkbin: Rockchip Firmware and Tool Binaries"
PKG_TOOLCHAIN="manual"
