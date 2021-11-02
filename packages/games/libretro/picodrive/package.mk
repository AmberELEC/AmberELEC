PKG_NAME="picodrive"
PKG_VERSION="9cb99ce36f93871b05c5adc2790b2e33e63b50b6"
PKG_LICENSE="MAME"
PKG_SITE="https://github.com/libretro/picodrive"
PKG_URL="$PKG_SITE.git"
PKG_DEPENDS_TARGET="toolchain SDL"
PKG_PRIORITY="optional"
PKG_SECTION="libretro"
PKG_SHORTDESC="Libretro implementation of PicoDrive. (Sega Megadrive/Genesis/Sega Master System/Sega GameGear/Sega CD/32X)"
PKG_LONGDESC="This is yet another Megadrive / Genesis / Sega CD / Mega CD / 32X / SMS emulator, which was written having ARM-based handheld devices in mind (such as smartphones and handheld consoles like GP2X and Pandora), but also runs on non-ARM little-endian hardware too."
GET_HANDLER_SUPPORT="git"
PKG_BUILD_FLAGS="-gold"
PKG_TOOLCHAIN="make"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_PATCH_DIRS="${PROJECT}"

configure_target() {
  :
}

make_target() {
  if [ "$ARCH" == "arm" ]; then
    make -C .. -f Makefile.libretro platform=armv6
  elif [ "$ARCH" == "aarch64" ]; then
    cd $PKG_BUILD
    $PKG_BUILD/configure --platform=generic
    make -f Makefile.libretro
  else
    make -C .. -f Makefile.libretro
  fi
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp $PKG_BUILD/picodrive_libretro.so $INSTALL/usr/lib/libretro/
}
