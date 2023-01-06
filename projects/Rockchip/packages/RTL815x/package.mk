# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="RTL815x"
PKG_VERSION="8a84a7a5d4e482bd2f16dc1d0dced997338b0729"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/dhwz/realtek-r8152-linux"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux"
PKG_NEED_UNPACK="${LINUX_DEPENDS}"
PKG_LONGDESC="Realtek RTL8152/RTL8153/RTL8156 Linux driver"
PKG_IS_KERNEL_PKG="yes"

make_target() {
  LDFLAGS="" make -C $(kernel_path) M=${PKG_BUILD} \
    ARCH=${TARGET_KERNEL_ARCH} \
    KSRC=$(kernel_path) \
    CROSS_COMPILE=${TARGET_KERNEL_PREFIX} \
    USER_EXTRA_CFLAGS="-fgnu89-inline"
}

makeinstall_target() {
  mkdir -p ${INSTALL}/$(get_full_module_dir)/${PKG_NAME}
  find ${PKG_BUILD}/ -name \*.ko -not -path '*/\.*' -exec cp {} ${INSTALL}/$(get_full_module_dir)/${PKG_NAME} \;
}
