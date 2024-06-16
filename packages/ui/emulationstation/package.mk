# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2020-present Fewtarius
# Copyright (C) 2021-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="emulationstation"
PKG_VERSION="976e4f299b37f81ef89bd8f2e08b88706aadbae4"
PKG_GIT_CLONE_BRANCH="main"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/AmberELEC/emulationstation"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="boost toolchain SDL2 freetype curl freeimage bash rapidjson ${OPENGLES} SDL2_mixer fping p7zip vlc zstd"
PKG_NEED_UNPACK="busybox"
PKG_LONGDESC="Emulationstation emulator frontend"
PKG_BUILD_FLAGS="+lto-parallel"

##########################################################################################################
# Uncomment the following lines (PKG_SITE, PKG_URL) to build locally from a git clone
# of emulationstation in your work directory.  Works with docker too if it's in the work directory.
# ------------------------
# To ensure the source gets updated , you must remove source before each build or it will not get rebuilt.
# So build similar to this:
#   rm -rf ./sources/emulationstation/ \
#      && DOCKER_WORK_DIR=/work DEVICE=RG351V ARCH=aarch64 PACKAGE=emulationstation make docker-package-clean docker-package
##########################################################################################################
#PKG_SITE="file:///work/emulationstation"
#PKG_URL="${PKG_SITE}"

# themes for Emulationstation
PKG_DEPENDS_TARGET="${PKG_DEPENDS_TARGET} es-theme-art-book-next"

PKG_CMAKE_OPTS_TARGET=" -DENABLE_AMBERELEC=1 -DGLES2=1 -DDISABLE_KODI=1 -DENABLE_FILEMANAGER=0 -DCEC=0 -D${DEVICE}=1"

pre_configure_target() {
  if [ -f ~/developer_settings.conf ]; then
    . ~/developer_settings.conf
  fi
}

makeinstall_target() {
	mkdir -p ${INSTALL}/usr/config/locale
	cp -rf ${PKG_BUILD}/locale/lang/* ${INSTALL}/usr/config/locale/

	mkdir -p ${INSTALL}/usr/lib
	ln -sf /storage/.config/emulationstation/locale ${INSTALL}/usr/lib/locale

	mkdir -p ${INSTALL}/usr/config/emulationstation/resources
	cp -rf ${PKG_BUILD}/resources/* ${INSTALL}/usr/config/emulationstation/resources/
	rm -rf ${INSTALL}/usr/config/emulationstation/resources/logo.png

	mkdir -p ${INSTALL}/usr/lib/${PKG_PYTHON_VERSION}
	cp -rf ${PKG_DIR}/bluez/* ${INSTALL}/usr/lib/${PKG_PYTHON_VERSION}

	mkdir -p ${INSTALL}/usr/bin
	ln -sf /storage/.config/emulationstation/resources ${INSTALL}/usr/bin/resources
	cp -rf ${PKG_BUILD}/emulationstation ${INSTALL}/usr/bin

	mkdir -p ${INSTALL}/etc/emulationstation/
	ln -sf /storage/.config/emulationstation/themes ${INSTALL}/etc/emulationstation/
	ln -sf /usr/config/emulationstation/es_systems.cfg ${INSTALL}/etc/emulationstation/es_systems.cfg

        cp -rf ${PKG_DIR}/config/*.cfg ${INSTALL}/usr/config/emulationstation
}

post_install() {
	enable_service emustation.service
	mkdir -p ${INSTALL}/usr/share
	ln -sf /storage/.config/emulationstation/locale ${INSTALL}/usr/share/locale
}
