# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2020-present Fewtarius

PKG_NAME="351elec-emulationstation"
PKG_VERSION="67e17969f9299bf57f28751ad5fe3a4de3e2c06d"
PKG_GIT_CLONE_BRANCH="main"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/351ELEC/351elec-emulationstation"
PKG_URL="$PKG_SITE.git"
PKG_DEPENDS_TARGET="toolchain SDL2 freetype curl freeimage bash rapidjson ${OPENGLES} SDL2_mixer libcec fping p7zip vlc"
PKG_NEED_UNPACK="busybox"
PKG_SHORTDESC="Emulationstation emulator frontend"
PKG_BUILD_FLAGS="-gold"
GET_HANDLER_SUPPORT="git"

# themes for Emulationstation
PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET es-theme-art-book-3-2"

PKG_CMAKE_OPTS_TARGET=" -DENABLE_EMUELEC=1 -DGLES2=0 -DDISABLE_KODI=1 -DENABLE_FILEMANAGER=1"

makeinstall_target() {
	mkdir -p $INSTALL/usr/config/distribution/configs/locale
	cp -rf $PKG_BUILD/locale/lang/* $INSTALL/usr/config/distribution/configs/locale/
	
	mkdir -p $INSTALL/usr/lib
	ln -sf /storage/.config/distribution/configs/locale $INSTALL/usr/lib/locale
	
	mkdir -p $INSTALL/usr/config/emulationstation/resources
	cp -rf $PKG_BUILD/resources/* $INSTALL/usr/config/emulationstation/resources/

	mkdir -p $INSTALL/usr/lib/python2.7
	cp -rf $PKG_DIR/bluez/* $INSTALL/usr/lib/python2.7
	
	mkdir -p $INSTALL/usr/bin
	ln -sf /storage/.config/emulationstation/resources $INSTALL/usr/bin/resources
	cp -rf $PKG_BUILD/emulationstation $INSTALL/usr/bin

	mkdir -p $INSTALL/etc/emulationstation/
	ln -sf /storage/.config/emulationstation/themes $INSTALL/etc/emulationstation/
	ln -sf /usr/config/emulationstation/es_systems.cfg $INSTALL/etc/emulationstation/es_systems.cfg

        cp -rf $PKG_DIR/config/*.cfg $INSTALL/usr/config/emulationstation
        cp -rf $PKG_DIR/config/scripts $INSTALL/usr/config/emulationstation  
 
	chmod +x $INSTALL/usr/config/emulationstation/scripts/*
	chmod +x $INSTALL/usr/config/emulationstation/scripts/configscripts/*
	find $INSTALL/usr/config/emulationstation/scripts/ -type f -exec chmod o+x {} \; 
	
	# Vertical Games are only supported in the OdroidGoAdvance
    if [[ ${DEVICE} != "OdroidGoAdvance" ]] || [[ ${DEVICE} =~ RG351 ]]; then
        sed -i "s|, vertical||g" "$INSTALL/usr/config/emulationstation/es_features.cfg"
    fi
}

post_install() {  
	enable_service emustation.service
	mkdir -p $INSTALL/usr/share
	ln -sf /storage/.config/distribution/configs/locale $INSTALL/usr/share/locale
	mkdir -p $INSTALL/usr/config/emulationstation/resources
        cp -rf $PKG_DIR/config/resources/* $INSTALL/usr/config/emulationstation/resources/
}
