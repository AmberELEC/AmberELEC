# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="ports"
PKG_VERSION=""
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPLv3"
PKG_SITE=""
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain bermuda hodesdl hydracastlelabyrinth eduke jinja2:host pyyaml:host commander-genius devilutionX sdlpop VVVVVV opentyrian"
PKG_SHORTDESC="Ports Meta Package"
PKG_TOOLCHAIN="manual"

makeinstall_target() {
mkdir -p $INSTALL/usr/config/distribution/ports
python3 port_builder.py ports.yaml $INSTALL/usr/config/distribution/ports
cp -rf $PKG_BUILD/images $INSTALL/usr/config/distribution/ports
cp -rf $PKG_BUILD/videos $INSTALL/usr/config/distribution/ports

# Remove duplicate newlines just to be tidy
for file in "$INSTALL/usr/config/distribution/ports/*.sh"; do
sed  -i '$!N; /^\(.*\)\n\1$/!P; D' $file
done

# Remove empty lines from gamelist.xml
sed -i '/^$/d' $INSTALL/usr/config/distribution/ports/gamelist.xml

}
