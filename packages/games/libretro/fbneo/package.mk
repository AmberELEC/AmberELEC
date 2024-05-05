# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="fbneo"
PKG_VERSION="24de1b83932196d1dce754a601ae07e857b5b817"
PKG_SHA256="ce493ffea9e027c60cece672a74b8d2adc977972eec494b0a723235800615f4b"
PKG_LICENSE="Non-commercial"
PKG_SITE="https://github.com/libretro/FBNeo"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Currently, FB neo supports games on Capcom CPS-1 and CPS-2 hardware, SNK Neo-Geo hardware, Toaplan hardware, Cave hardware, and various games on miscellaneous hardware. "
PKG_TOOLCHAIN="make"


pre_configure_target() {
  sed -i "s|LDFLAGS += -static-libgcc -static-libstdc++|LDFLAGS += -static-libgcc|"  ./src/burner/libretro/Makefile
  sed -i 's/\-O[23]//' ./src/burner/libretro/Makefile

  PKG_MAKE_OPTS_TARGET=" -C ./src/burner/libretro USE_CYCLONE=0 profile=performance"

  if [[ "${TARGET_FPU}" =~ "neon" ]]; then
    PKG_MAKE_OPTS_TARGET+=" HAVE_NEON=1"
  fi
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp ${PKG_BUILD}/src/burner/libretro/fbneo_libretro.so ${INSTALL}/usr/lib/libretro/
}
