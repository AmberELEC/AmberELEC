PKG_NAME="potator"
PKG_VERSION="dacb12c8eb1a9adc96972969634d219eace35ff3"
PKG_SHA256="142638c35983325465450c0f89cdac53c494e65c69ea74a22104b487536e1762"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/potator"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="libretro"
PKG_SHORTDESC="A Watara Supervision Emulator based on Normmatt version."
PKG_LONGDESC="A Watara Supervision Emulator based on Normmatt version."
PKG_TOOLCHAIN="make"


make_target() {
  make -C platform/libretro/ platform=aarch64
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp platform/libretro/potator_libretro.so $INSTALL/usr/lib/libretro/
}
