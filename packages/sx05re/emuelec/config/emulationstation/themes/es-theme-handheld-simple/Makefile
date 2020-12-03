# Environment values
ROOT_DIR ?= ${CURDIR}

# Values for remote device syncing
DEVICE_HOST ?= 192.168.0.182
DEVICE_THEME_PATH ?= /storage/.config/emulationstation/themes/
DEVICE_SSH_USER ?= root
DEVICE_SSH_PASS ?= 351elec
DEVICE_SSH_URI ?= ${DEVICE_SSH_USER}@${DEVICE_HOST}

# Remote commands
COMMAND_REMOTE_EMULATIONSTATION_RELOAD ?= systemctl try-reload-or-restart emustation.service


sync-with-handheld:
	rsync --archive --delete --progress --human-readable --exclude='.git/' "${ROOT_DIR}" "${DEVICE_SSH_URI}":"${DEVICE_THEME_PATH}" && ssh "${DEVICE_SSH_URI}" '${COMMAND_REMOTE_EMULATIONSTATION_RELOAD}'

# Requires `watchexec` and `sshpass`
sync-with-handheld-unattended:
	watchexec -- sshpass -p "${DEVICE_SSH_PASS}" rsync --archive --delete --progress --human-readable --exclude='.git/' "${ROOT_DIR}" "${DEVICE_SSH_URI}":"${DEVICE_THEME_PATH}" \&\& sshpass -p "${DEVICE_SSH_PASS}" ssh "${DEVICE_SSH_URI}" '${COMMAND_REMOTE_EMULATIONSTATION_RELOAD}'


.PHONY: sync-with-handheld sync-with-handheld-unattended
