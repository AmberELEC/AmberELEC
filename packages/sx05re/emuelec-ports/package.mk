# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="emuelec-ports"
PKG_VERSION=""
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPLv3"
PKG_SITE=""
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain patchelf jinja2:host pyyaml:host commander-genius devilutionX sdlpop VVVVVV opentyrian"
PKG_SECTION="emuelec"
PKG_SHORTDESC="EmuELEC Ports Meta Package"
PKG_TOOLCHAIN="manual"

# Not Enabled yet: bermuda hodesdl hydracastlelabyrinth eduke

makeinstall_target() {
mkdir -p $INSTALL/usr/config/emuelec/ports
python3 port_builder.py ports.yaml $INSTALL/usr/config/emuelec/ports
mv $INSTALL/usr/local/bin/gamelist.xml $INSTALL/usr/config/emuelec/ports
cp -rf $PKG_BUILD/images $INSTALL/usr/config/emuelec/ports

# Remove duplicate newlines just to be tidy
for file in "$INSTALL/usr/local/bin/*.sh"; do
sed  -i '$!N; /^\(.*\)\n\1$/!P; D' $file
done

# Remove empty lines from gamelist.xml
sed -i '/^$/d' $INSTALL/usr/config/emuelec/ports/gamelist.xml

}
