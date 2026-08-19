# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="RTL815x"
PKG_VERSION="9ff8b9d961f3927a211a25b187c749daf0769318"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/dhwz/realtek-r8152-linux"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux"
PKG_NEED_UNPACK="${LINUX_DEPENDS}"
PKG_LONGDESC="Realtek RTL8152/RTL8153/RTL8156 Linux driver"
PKG_IS_KERNEL_PKG="yes"

pre_make_target() {
	unset LDFLAGS
	sed -i 's/\\u2103/°C/g; s/\\u2109/°F/g' ${PKG_BUILD}/r8152.c
}

make_target() {
	LDFLAGS="" make -C $(kernel_path) M=${PKG_BUILD} \
		ARCH=${TARGET_KERNEL_ARCH} \
		KSRC=$(kernel_path) \
		CROSS_COMPILE=${TARGET_KERNEL_PREFIX} \
		KCFLAGS="${KCFLAGS} -Wno-undef"
}

makeinstall_target() {
  mkdir -p ${INSTALL}/$(get_full_module_dir)/${PKG_NAME}
  find ${PKG_BUILD}/ -name \*.ko -not -path '*/\.*' -exec cp {} ${INSTALL}/$(get_full_module_dir)/${PKG_NAME} \;

  mkdir -p ${INSTALL}/usr/lib/udev/rules.d
  cp ${PKG_BUILD}/50-usb-realtek-net.rules ${INSTALL}/usr/lib/udev/rules.d
}

post_install() {
  rm -f ${INSTALL}/$(get_full_module_dir)/kernel/drivers/net/usb/r8152.ko
}
