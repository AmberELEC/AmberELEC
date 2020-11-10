# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

# This is gross, but use Anbernic's kernel for now.

PKG_NAME="linux"
PKG_LICENSE="GPL"
PKG_SITE="http://www.kernel.org"
PKG_DEPENDS_HOST="ccache:host openssl:host"
PKG_DEPENDS_TARGET="toolchain linux:host cpio:host kmod:host xz:host wireless-regdb keyutils $KERNEL_EXTRA_DEPENDS_TARGET"
PKG_DEPENDS_INIT="toolchain"
PKG_NEED_UNPACK="$LINUX_DEPENDS $(get_pkg_directory busybox)"
PKG_LONGDESC="This package contains a precompiled kernel image and the modules."
PKG_IS_KERNEL_PKG="yes"
PKG_STAMP="$KERNEL_TARGET $KERNEL_MAKE_EXTRACMD"
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  tar -xvzf anbernic-kernel.tar.gz
  mkdir -p $INSTALL/usr/share/bootloader

  cp anbernic-kernel/usr/share/bootloader/* $INSTALL/usr/share/bootloader
  mkdir -p arch/arm64/boot

  cp anbernic-kernel/kernel arch/${TARGET_KERNEL_ARCH}/boot/${KERNEL_TARGET}

  mkdir -p $INSTALL/usr/lib/kernel-overlays/base/lib/modules
  cp -rf anbernic-kernel/usr/lib/kernel-overlays/base/lib/modules/* $INSTALL/usr/lib/kernel-overlays/base/lib/modules

  mkdir -p $INSTALL/usr/lib/kernel-overlays/base/lib/firmware
  cp -rf anbernic-kernel/usr/lib/kernel-overlays/base/lib/firmware/* $INSTALL/usr/lib/kernel-overlays/base/lib/firmware

  mkdir -p $INSTALL/usr/share/bootloader
  cp -rf anbernic-kernel/usr/share/bootloader/* $INSTALL/usr/share/bootloader
}
