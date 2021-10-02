# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2020-present Fewtarius

PKG_NAME="351elec-emulationstation"
PKG_VERSION="de9f3e7abb966030d7bbe0a2ba7d8aa9908e0923"
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

##########################################################################################################
# Uncomment the following lines (PKG_SITE, PKG_URL, GET_HANDLER_SUPPORT) to build locally from a git clone
# of 351elec-emulationstation in your work directory.  Works with docker too if it's in the work directory.
# ------------------------
# To ensure the source gets updated , you must remove source before each build or it will not get rebuilt.  
# So build similar to this:
#   rm -rf ./sources/351elec-emulationstation/ \
#      && DOCKER_WORK_DIR=/work DEVICE=RG351V ARCH=aarch64 PACKAGE=351elec-emulationstation make docker-package-clean docker-package
##########################################################################################################
#PKG_SITE="file:///work/351elec-emulationstation"
#PKG_URL="$PKG_SITE"
#GET_HANDLER_SUPPORT="file"

# themes for Emulationstation
PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET es-theme-art-book-3-2 es-theme-art-book-4-3"

PKG_CMAKE_OPTS_TARGET=" -DENABLE_EMUELEC=1 -DGLES2=0 -DDISABLE_KODI=1 -DENABLE_FILEMANAGER=1"

pre_configure_target() {
  cd $PKG_BUILD
  sed -i "s|SMOOTH GAMES|BILINEAR FILTER|g" es-app/src/guis/GuiMenu.cpp
}


makeinstall_target() {
	mkdir -p $INSTALL/usr/config/distribution/configs/locale
	cp -rf $PKG_BUILD/locale/lang/* $INSTALL/usr/config/distribution/configs/locale/

	mkdir -p $INSTALL/usr/lib
	ln -sf /storage/.config/distribution/configs/locale $INSTALL/usr/lib/locale

	mkdir -p $INSTALL/usr/config/emulationstation/resources
	cp -rf $PKG_BUILD/resources/* $INSTALL/usr/config/emulationstation/resources/
	rm -rf $INSTALL/usr/config/emulationstation/resources/logo.png

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

	# set the correct default theme for P/M or V/MP models
	# there are both default themes in es_settings.cfg
	# delete es-theme-art-book-3-2 on V/MP
	if [ "${DEVICE}" = "RG351V" ] || [ "${DEVICE}" = "RG351MP" ]; then
		sed -i "/value=\"es-theme-art-book-3-2\"/d" $INSTALL/usr/config/emulationstation/es_settings.cfg
	fi
	# delete es-theme-art-book-4-3 on P/M
	if [ "${DEVICE}" = "RG351P" ]; then
                sed -i "/value=\"es-theme-art-book-4-3\"/d" $INSTALL/usr/config/emulationstation/es_settings.cfg
        fi

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
}
