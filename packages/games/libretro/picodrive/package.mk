PKG_NAME="picodrive"
PKG_VERSION="7ab066aab84f15388a53433ea273420bcf917e00"
PKG_LICENSE="MAME"
PKG_SITE="https://github.com/libretro/picodrive"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="This is yet another Megadrive / Genesis / Sega CD / Mega CD / 32X / SMS emulator, which was written having ARM-based handheld devices in mind (such as smartphones and handheld consoles like GP2X and Pandora), but also runs on non-ARM little-endian hardware too."
PKG_TOOLCHAIN="make"

PKG_PATCH_DIRS="${PROJECT}"

configure_target() {
  :
}

make_target() {
  cd ${PKG_BUILD}
#  ${PKG_BUILD}/configure --platform=generic
  make -f Makefile.libretro
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp ${PKG_BUILD}/picodrive_libretro.so ${INSTALL}/usr/lib/libretro/
}
