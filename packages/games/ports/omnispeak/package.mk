PKG_NAME="omnispeak"
PKG_VERSION="de2d3fda9efeba45b5dcc1428ca551d44bb9f698"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL2"
PKG_SITE="https://github.com/sulix/omnispeak"
PKG_URL="$PKG_SITE.git"
#PKG_GIT_CLONE_BRANCH="tweaks"
PKG_DEPENDS_TARGET="toolchain SDL2"
PKG_LONGDESC="Omnispeak is an open-source reimplementation of Commander Keen episodes 4, 5, and 6. It aims to be a pixel-perfect, bug-for-bug clone of the original games, and is compatible with savegames from the DOS version."
PKG_TOOLCHAIN="make"
PKG_GIT_BRANCH="sdl2"
GET_HANDLER_SUPPORT="git"

pre_configure_target() {
  sed -i "s|sdl2-config|${SYSROOT_PREFIX}/usr/bin/sdl2-config|g" $PKG_BUILD/src/Makefile
  cd $PKG_BUILD/src
}

make_target() {
  make RENDERER=sdl2 TOOLDIR=${TOOLCHAIN}/bin TOOLSET=${TARGET_ARCH}-libreelec-linux-gnu${TARGET_ABI}
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/local/bin
  cp $PKG_BUILD/bin/omnispeak $INSTALL/usr/local/bin

  mkdir -p $INSTALL/usr/config/distribution/ports/omnispeak
  cp $PKG_BUILD/bin/*.CK? $INSTALL/usr/config/distribution/ports/omnispeak

  # Config files that enable joystick and configure joystick buttons
  cp $PKG_DIR/config/CONFIG.CK? $INSTALL/usr/config/distribution/ports/omnispeak
}
