# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2021-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="parallel-n64"
PKG_VERSION="334998e6129debe50f7ef9c5cd1e995460ae2da8"
PKG_SHA256="8fa8b47f718c8f8d003108c22c67b906995c8315aa9dd385eb413bb70b68d7d7"
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
