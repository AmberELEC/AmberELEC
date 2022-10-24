# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="fbneo"
PKG_VERSION="f5331e4911daa528ac6a7dd6af344df8afd187e5"
PKG_SHA256="d953aeaccf1b25a0a0c53faae7c3449a13c3d13bb2191dfbf086f54a4cdc3c91"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="Non-commercial"
PKG_SITE="https://github.com/libretro/FBNeo"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="libretro"
PKG_SHORTDESC="Port of Final Burn Neo to Libretro (v0.2.97.38)."
PKG_LONGDESC="Currently, FB neo supports games on Capcom CPS-1 and CPS-2 hardware, SNK Neo-Geo hardware, Toaplan hardware, Cave hardware, and various games on miscellaneous hardware. "
PKG_TOOLCHAIN="make"


pre_configure_target() {
  sed -i "s|LDFLAGS += -static-libgcc -static-libstdc++|LDFLAGS += -static-libgcc|"  ./src/burner/libretro/Makefile
  sed -i 's/\-O[23]//' ./src/burner/libretro/Makefile

  PKG_MAKE_OPTS_TARGET=" -C ./src/burner/libretro USE_CYCLONE=0 profile=performance"

  if [[ "$TARGET_FPU" =~ "neon" ]]; then
    PKG_MAKE_OPTS_TARGET+=" HAVE_NEON=1"
  fi
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp $PKG_BUILD/src/burner/libretro/fbneo_libretro.so $INSTALL/usr/lib/libretro/
}
