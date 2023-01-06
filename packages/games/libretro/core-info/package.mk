# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="core-info"
PKG_VERSION="0c56d506ea3eb0d87b3fe64552a7d2bbe04d1658"
PKG_SHA256="762cf227abcdf7fbb61aebbd725756c5af86fb3f0616c7a59618a4488a280fd7"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/libretro/libretro-core-info"
PKG_URL="https://github.com/libretro/libretro-core-info/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Mirror of libretro's core info files"
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  rename.ul -v mednafen beetle $PKG_BUILD/*.info
  cp $PKG_BUILD/*.info $INSTALL/usr/lib/libretro/
  cp $PKG_BUILD/flycast_libretro.info $INSTALL/usr/lib/libretro/flycast2021_libretro.info
  sed -i 's/Flycast/Flycast 2021/g' $INSTALL/usr/lib/libretro/flycast2021_libretro.info 
}
