# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="SDL2_gfx"
PKG_VERSION="16fa07d08e7cee5ad7dc815cfd1f4816e36cc73c"
PKG_SHA256="6be035fb9f59e3c80503c6fd20fd59354338df56b7839e87d13d1e2a8102dec4"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/jjYBdx4IL/SDL2_gfx"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain SDL2"
PKG_LONGDESC="SDL_image is an image file loading library. "
PKG_TOOLCHAIN="configure"

pre_configure_target() {
export CC=${CC}
}
PKG_CONFIGURE_OPTS_TARGET=" --disable-mmx"

