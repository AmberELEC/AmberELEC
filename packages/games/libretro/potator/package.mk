PKG_NAME="potator"
PKG_VERSION="2873c42f28012992c1132fd083787f5b76b99418"
PKG_SHA256="6220c22516327071d8167caeb289da79fee39683ff0ba44c62ad0bd88fc43fa7"
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
  if [ "$ARCH" == "arm" ]; then
    CFLAGS="$CFLAGS -DALIGN_LONG"
  fi
  make -C platform/libretro/
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp platform/libretro/potator_libretro.so $INSTALL/usr/lib/libretro/
}
