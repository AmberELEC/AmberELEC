# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2021-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="parallel-n64"
PKG_VERSION="1b57f9199b1f8a4510f7f89f14afa9cabf9b3bdd"
PKG_SHA256="2dec08f3026dd160a0129507f4c8891325c5d2444822135d2be3ccc4517e37bb"
PKG_REV="2"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/parallel-n64"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain ${OPENGLES}"
PKG_LONGDESC="Optimized/rewritten Nintendo 64 emulator made specifically for Libretro. Originally based on Mupen64 Plus."
PKG_TOOLCHAIN="make"

if [[ "${DEVICE}" =~ RG552 ]]; then
  PKG_MAKE_OPTS_TARGET=" platform=unix_RK3399"
else
  PKG_MAKE_OPTS_TARGET=" platform=unix_RK3326"
fi

if [[ "${DEVICE}" == RG351P ]] || [[ "${DEVICE}" == RG351V ]]; then
  PKG_PATCH_DIRS="rumble"
fi

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp parallel_n64_libretro.so ${INSTALL}/usr/lib/libretro/
}
