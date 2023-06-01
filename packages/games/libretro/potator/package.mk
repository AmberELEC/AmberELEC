PKG_NAME="potator"
PKG_VERSION="aed31f9254cada9826c65ff4528cc8bdda338275"
PKG_SHA256="2ebded5ae22dea202402cfd378ce1ca2fa2d02a1d739a79f0210ec4675064d64"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/potator"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A Watara Supervision Emulator based on Normmatt version."
PKG_TOOLCHAIN="make"


make_target() {
  make -C platform/libretro/ platform=aarch64
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp platform/libretro/potator_libretro.so ${INSTALL}/usr/lib/libretro/
}
