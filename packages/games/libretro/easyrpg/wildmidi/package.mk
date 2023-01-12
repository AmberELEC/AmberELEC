# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)

PKG_NAME="wildmidi"
PKG_VERSION="405ca73"
PKG_SITE="https://github.com/Mindwerks/wildmidi"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="WildMIDI is a simple software midi player which has a core softsynth library that can be used with other applications."
PKG_TOOLCHAIN="cmake"

PKG_CMAKE_OPTS_TARGET="WANT_PLAYER=OFF -DWANT_ALSA=ON"
