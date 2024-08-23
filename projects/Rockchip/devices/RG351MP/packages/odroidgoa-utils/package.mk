# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2021-present Fewtarius

PKG_NAME="odroidgoa-utils"
PKG_VERSION=""
PKG_SHA256=""
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_DEPENDS_TARGET="toolchain enable-oga-sleep"
PKG_SITE=""
PKG_URL=""
PKG_LONGDESC="Support scripts for the RG351P/M/V"
PKG_TOOLCHAIN="manual"

makeinstall_target() {
	mkdir -p ${INSTALL}/usr/bin
	cp headphone_sense.sh ${INSTALL}/usr/bin
	cp battery.sh ${INSTALL}/usr/bin
	cp odroidgoa_utils.sh ${INSTALL}/usr/bin
	cp volume_sense.sh ${INSTALL}/usr/bin
	cp adckeys.sh ${INSTALL}/usr/bin
	cp adckeys.py ${INSTALL}/usr/bin
	cp joyled.sh ${INSTALL}/usr/bin
	chmod 0755 ${INSTALL}/usr/bin/*
}

post_install() {  
	enable_service volume.service
	enable_service headphones.service
	enable_service battery.service
	enable_service adckeys.service
	enable_service joyled.service
}
