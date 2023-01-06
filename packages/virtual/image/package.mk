# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="image"
PKG_LICENSE="GPL"
PKG_SITE="https://libreelec.tv"
PKG_DEPENDS_TARGET="toolchain squashfs-tools:host dosfstools:host fakeroot:host kmod:host mtools:host populatefs:host libc gcc linux linux-drivers linux-firmware ${BOOTLOADER} busybox util-linux corefonts network misc-packages debug usb-modeswitch unzip poppler socat p7zip file"
PKG_SECTION="virtual"
PKG_LONGDESC="Root package used to build and create complete image"

# Graphic support
[ ! "${DISPLAYSERVER}" = "no" ] && PKG_DEPENDS_TARGET+=" ${DISPLAYSERVER}"

# Sound support
[ "${ALSA_SUPPORT}" = "yes" ] && PKG_DEPENDS_TARGET+=" alsa"

# Automounter support
[ "${UDEVIL}" = "yes" ] && PKG_DEPENDS_TARGET+=" udevil"

# EXFAT support
[ "${EXFAT}" = "yes" ] && PKG_DEPENDS_TARGET+=" exfat exfatprogs"

# NTFS 3G support
[ "${NTFS3G}" = "yes" ] && PKG_DEPENDS_TARGET+=" ntfs-3g_ntfsprogs"

# Virtual image creation support
[ "${PROJECT}" = "Generic" ] && PKG_DEPENDS_TARGET+=" virtual"

# htop
[ "${HTOP_TOOL}" = "yes" ] && PKG_DEPENDS_TARGET+=" htop"

true
