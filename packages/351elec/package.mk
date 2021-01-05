# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2020-present Fewtarius

PKG_NAME="351elec"
PKG_VERSION=""
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPLv3"
PKG_SITE=""
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain $OPENGLES 351elec-emulationstation retroarch retroarch-overlays"
PKG_SECTION="emuelec"
PKG_SHORTDESC="351ELEC Meta Package"
PKG_LONGDESC="351ELEC Meta Package"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"
PKG_TOOLCHAIN="make"

# Thanks to magicseb  Reicast SA now WORKS :D
PKG_EXPERIMENTAL="munt quasi88 xmil np2kai hypseus"
PKG_EMUS="$LIBRETRO_CORES advancemame PPSSPPSDL tgbdual TIC-80 pcsx_rearmed parallel-n64 fba4arm reicastsa amiberry uae4arm puae hatarisa fba4arm openbor mupen64plus mupen64plus-nx scummvmsa residualvm duckstation"
PKG_TOOLS="ffmpeg libjpeg-turbo common-shaders Skyscraper MC SDL_GameControllerDB linux-utils xmlstarlet CoreELEC-Debug-Scripts sixaxis jslisten evtest mpv bluetool rs97-commander-sdl2 jslisten gnupg gzip patchelf"
PKG_RETROPIE_DEP="bash pyudev dialog six git dbus-python pygobject coreutils"
PKG_DEPENDS_TARGET+=" $PKG_TOOLS $PKG_RETROPIE_DEP $PKG_EMUS $PKG_EXPERIMENTAL ports moonlight"

# These packages are only meant for S922x, S905x2 and A311D devices as they run poorly on S905, S912, etc"
if [ "$PROJECT" == "Amlogic-ng" ]; then
PKG_DEPENDS_TARGET+=" $LIBRETRO_S922X_CORES mame2016"
fi

if [ "$DEVICE" == "RG351P" ]; then
    PKG_DEPENDS_TARGET+=" odroidgoa-utils rs97-commander-sdl2"
    
    #we disable some cores that are not working or work poorly on OGA
    for discore in mesen-s virtualjaguar quicknes reicastsa_old reicastsa MC; do
        PKG_DEPENDS_TARGET=$(echo $PKG_DEPENDS_TARGET | sed "s|$discore||")
    done
    PKG_DEPENDS_TARGET+=" opera yabasanshiro"
else
    PKG_DEPENDS_TARGET+=" fbterm"
fi

make_target() {
if [ "$PROJECT" == "Amlogic-ng" ]; then
    cp -r $PKG_DIR/fbfix* $PKG_BUILD/
    cd $PKG_BUILD/fbfix
    $CC -O2 fbfix.c -o fbfix
fi
}

makeinstall_target() {
   
    if [ "$PROJECT" == "Amlogic-ng" ]; then
    mkdir -p $INSTALL/usr/bin
    cp $PKG_BUILD/fbfix/fbfix $INSTALL/usr/bin
    fi

    mkdir -p $INSTALL/usr/config/
    rsync -av $PKG_DIR/config/* $INSTALL/usr/config/
    #cp -rf $PKG_DIR/config/* $INSTALL/usr/config/
    ln -sf /storage/.config/emuelec $INSTALL/emuelec
    find $INSTALL/usr/config/emuelec/ -type f -exec chmod o+x {} \;
  
  mkdir -p $INSTALL/usr/config/emuelec/logs
  ln -sf /var/log $INSTALL/usr/config/emuelec/logs/var-log
    
  mkdir -p $INSTALL/usr/bin/
  
  # leave for compatibility
  if [ "$PROJECT" == "Amlogic" ]; then
      echo "s905" > $INSTALL/ee_s905
  fi
  
  if [ "$DEVICE" == "RG351P" ]; then
      echo "$DEVICE" > $INSTALL/ee_arch
  else
      echo "$PROJECT" > $INSTALL/ee_arch
  fi

  FILES=$INSTALL/usr/config/emuelec/scripts/*
  for f in $FILES 
    do
    FI=$(basename $f)
    ln -sf "/storage/.config/emuelec/scripts/$FI" $INSTALL/usr/bin/
  done

  FILES=$INSTALL/usr/config/emuelec/scripts/batocera/*
  for f in $FILES
    do
    FI=$(basename $f)
    ln -sf "/storage/.config/emuelec/scripts/batocera/$FI" $INSTALL/usr/bin/
  done

  mkdir -p $INSTALL/usr/share/retroarch-overlays
    cp -r $PKG_DIR/overlay/* $INSTALL/usr/share/retroarch-overlays
  
  mkdir -p $INSTALL/usr/share/common-shaders
    cp -r $PKG_DIR/shaders/* $INSTALL/usr/share/common-shaders
    
  mkdir -p $INSTALL/usr/share/libretro-database
     touch $INSTALL/usr/share/libretro-database/dummy

  # Move plymouth-lite bin to show splash screen
  cp $(get_build_dir plymouth-lite)/.install_init/usr/bin/ply-image $INSTALL/usr/bin

  mkdir -p $INSTALL/usr/share/bootloader
  cp logo.bmp $INSTALL/usr/share/bootloader/logo.bmp

}

post_install() {
# Remove unnecesary Retroarch Assets and overlays
  for i in branding glui nuklear nxrgui pkg switch wallpapers zarch COPYING; do
    rm -rf "$INSTALL/usr/share/retroarch-assets/$i"
  done
  
  for i in automatic dot-art flatui neoactive pixel retroactive retrosystem systematic convert.sh NPMApng2PMApng.py; do
  rm -rf "$INSTALL/usr/share/retroarch-assets/xmb/$i"
  done
  
  for i in borders effects gamepads ipad keyboards misc; do
    rm -rf "$INSTALL/usr/share/retroarch-overlays/$i"
  done
mkdir -p $INSTALL/etc/retroarch-joypad-autoconfig
cp -r $PKG_DIR/gamepads/* $INSTALL/etc/retroarch-joypad-autoconfig
# link default.target to emuelec.target
   ln -sf emuelec.target $INSTALL/usr/lib/systemd/system/default.target
   enable_service emuelec-autostart.service
  #enable_service emuelec-disable_small_cores.service
# Thanks to vpeter we can now have bash :) 
  rm -f $INSTALL/usr/bin/{sh,bash,busybox,sort}
  cp $PKG_DIR/sources/autostart.sh $INSTALL/usr/bin
  cp $PKG_DIR/sources/shutdown.sh $INSTALL/usr/bin
  cp $PKG_DIR/sources/pico-8.sh $INSTALL/usr/bin
  cp $(get_build_dir busybox)/.install_pkg/usr/bin/busybox $INSTALL/usr/bin
  cp $(get_build_dir bash)/.install_pkg/usr/bin/bash $INSTALL/usr/bin
  cp $(get_build_dir coreutils)/.install_pkg/usr/bin/sort $INSTALL/usr/bin
  ln -sf bash $INSTALL/usr/bin/sh
  echo "chmod 4755 $INSTALL/usr/bin/bash" >> $FAKEROOT_SCRIPT
  echo "chmod 4755 $INSTALL/usr/bin/busybox" >> $FAKEROOT_SCRIPT
  find $INSTALL/usr/ -type f -iname "*.sh" -exec chmod +x {} \;
  
CORESFILE="$INSTALL/usr/config/emulationstation/es_systems.cfg"

if [ "${PROJECT}" != "Amlogic-ng" ]; then
    if [[ ${DEVICE} == "RG351P" ]]; then
        remove_cores="mesen-s quicknes REICASTSA_OLD REICASTSA mame2016"
    elif [ "${PROJECT}" == "Amlogic" ]; then
        remove_cores="mesen-s quicknes mame2016"
        xmlstarlet ed -L -P -d "/systemList/system[name='3do']" $CORESFILE
        xmlstarlet ed -L -P -d "/systemList/system[name='saturn']" $CORESFILE
    fi
    
    # remove unused cores
    for discore in ${remove_cores}; do
        sed -i "s|<core>$discore</core>||g" $CORESFILE
        sed -i '/^[[:space:]]*$/d' $CORESFILE
    done
fi
  # Remove scripts from OdroidGoAdvance build
	if [[ ${DEVICE} == "RG351P" ]]; then 
	for i in "01 - Get ES Themes" "03 - wifi" "10 - Force Update" "04 - Configure Reicast" "07 - Skyscraper" "09 - system info"; do 
xmlstarlet ed -L -P -d "/gameList/game[name='${i}']" $INSTALL/usr/config/emuelec/scripts/modules/gamelist.xml 2>/dev/null ||:
	rm "$INSTALL/usr/config/emuelec/scripts/modules/${i}.sh" 2>/dev/null ||:
	done
	fi 
  
} 
