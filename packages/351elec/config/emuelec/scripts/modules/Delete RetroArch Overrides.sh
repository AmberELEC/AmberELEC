#!/bin/bash

. /etc/profile

message_stream "Deleting all RetroArch Overrides" .02
rm -rf /storage/.config/retroarch/config/*
