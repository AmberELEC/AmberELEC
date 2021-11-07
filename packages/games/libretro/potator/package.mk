PKG_NAME="potator"
PKG_VERSION="3e3bfd787306d5a074a91bfd9baee2f9cc3b82f3"
PKG_SHA256="95952073bca7db2fce3747059dea1d809246026928d8785a5ba11edd6e5c6214"
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
