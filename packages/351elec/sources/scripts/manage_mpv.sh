#!/bin/bash
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present ShantiGilbert, RedWolfTech, Fewtarius

function sendkey() {
  echo '{"command":["keypress", "'${1}'"]}' | socat - "/tmp/mpvsocket"
}

case "$1" in
    "pause")
        sendkey "p"
    ;;
    "skip5s") 
        sendkey "RIGHT"
    ;;
    "back5s") 
        sendkey "LEFT"
    ;;
    "skip60s") 
        sendkey "UP"
    ;;
    "back60s") 
        sendkey "DOWN"
    ;;
    "quit") 
        sendkey "q"
    ;;
esac

