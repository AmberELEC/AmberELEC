#!/bin/bash

source /etc/profile

EE_DEVICE=$(cat /storage/.config/.OS_ARCH)
EXECLOG="/tmp/logs/exec.log"

if [ ! -d "/storage/drastic/aarch64/drastic/config" ]
then
  mkdir -p /storage/drastic/aarch64/drastic/config
  cp -rf /usr/share/drastic/drastic.cfg /storage/drastic/aarch64/drastic/config
fi
if [ ! -f "/storage/drastic/aarch64/drastic/config/drastic.cfg" ]
then
  cp -rf /usr/share/drastic/config/drastic.cfg /storage/drastic/aarch64/drastic/config
fi

if [ ! -f "/storage/drastic/aarch64/drastic/drastic" ]
then
  mkdir -p /storage/drastic/aarch64/drastic/
  cp -rf /usr/share/drastic/data/* /storage/drastic/aarch64/drastic/
fi

cd /storage/drastic/aarch64/drastic/
LD_PRELOAD=/usr/lib/libSDL2-2.0.so.0.14.0 ./drastic "$1" >> $EXECLOG 2>&1
