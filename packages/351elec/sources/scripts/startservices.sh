#!/bin/sh

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present 351ELEC (https://github.com/351ELEC)

# Source predefined functions and variables
. /etc/profile

# handle SSH
DEFE=$(get_ee_setting ee_ssh.enabled)

case "$DEFE" in
"0")
	systemctl stop sshd
	rm /storage/.cache/services/sshd.conf
	;;
"1")
	mkdir -p /storage/.cache/services/
	touch /storage/.cache/services/sshd.conf
	systemctl start sshd
	;;
*)
	systemctl stop sshd
	rm /storage/.cache/services/sshd.conf
	;;
esac

# handle SAMBA
DEFE=$(get_ee_setting ee_samba.enabled)

case "$DEFE" in
"0")
	systemctl stop nmbd
	systemctl stop smbd
	rm /storage/.cache/services/smb.conf
	;;
"1")
	mkdir -p /storage/.cache/services/
	touch /storage/.cache/services/smb.conf
	systemctl start nmbd
	systemctl start smbd
	;;
*)
	systemctl stop nmbd
	systemctl stop smbd
	rm /storage/.cache/services/smb.conf
	;;
esac