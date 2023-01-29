#!/bin/bash
# based on code from https://github.com/Rolen47/ChangeTime

export SDL_GAMECONTROLLERCONFIG_FILE="/storage/.config/SDL-GameControllerDB/gamecontrollerdb.txt"
source /usr/bin/env.sh
export TERM=xterm-color
export DIALOGRC=/etc/amberelec.dialogrc
echo -e '\033[?25h\033[?16;224;238c' > /dev/console
clear > /dev/console

gptokeyb ppsspp_migrate.sh -c /usr/config/gptokeyb/settime.gptk &

raSavesDir='/storage/.config/ppsspp/PSP/SAVEDATA'
saSavesDir='/roms/gamedata/ppsspp/PSP/SAVEDATA'
dialog_title="RetroArch PPaSSPP Save Migration Utility"
dialog_backtitle="AmberELEC"

Quit(){
	kill -9 $(pidof gptokeyb)
	echo -e '\033[?25l' > /dev/console
	clear > /dev/console
	exit 0
}

ShowDisclaimer() {
	dialog \
	--title "${dialog_title}" \
	--backtitle "${dialog_backtitle}" \
	--yesno \
	"(If you never used the PPSSPP Core in RetroArch, disregard this utility)\n\nThis utility helps you move your RetroArch PPSSPP save files from its old location to the new one. If you have a fresh install after the 'Panda Conspiracy' release, don't worry about this utility.\n\nIf that is not the case and you need to move them to the new path, choose yes.\n\nContinue?" 15 40 2>&1 > /dev/console
	
	result=$?
	case ${result} in
		0) ShowSelectionScreen;;
		1) Quit;;
		255) Quit;;
	esac
}

ShowSelectionScreen(){
	if [ -z "$(ls -A $raSavesDir)" ]; then
		dialog \
		--title "${dialog_title}" \
		--backtitle "${dialog_backtitle}" \
		--msgbox "RetroArch's save directory seems empty, quitting..." 10 60 2>&1 > /dev/console
		Quit
	fi

	folderList=("Select all" "" "off")
	for folder in "$raSavesDir"/*; do
		folderName=$(basename "$folder")
		if [ -d "$saSavesDir/$folderName" ]; then
			folderList+=("$folderName" "Duplicate Exists" 'off')
		else
			folderList+=("$folderName" "Unique" 'on')
    		fi
  	done

	selectedFolders=$(dialog \
	--backtitle "${dialog_backtitle}" \
	--title "${dialog_title}" \
	--checklist "Select which save file folders we are copying by using the X button. If you choose 'Select All', all values will be ignored and all folders will be copied over!" 20 70 15 "${folderList[@]}" 2>&1 > /dev/console)
	
	if [ $? -ne 0 ]; then
		Quit
	fi
	
	MoveFiles "${selectedFolders[@]}"

}

MoveFiles(){

	selectedFolders=($@)

	if [[ "${selectedFolders[@]}" =~ "\"Select" ]]; then
		selectedFolders=($(ls -l "$raSavesDir" | grep '^d' | awk '{print $NF}'))
	fi

	(for folder in "${selectedFolders[@]}"; do
		echo $((++i * 100 / ${#selectedFolders[@]}))
		mv "${raSavesDir}/${folder}" "${saSavesDir}/"
		sync
	done) | dialog \
	--title "${dialog_title}" \
	--backtitle "${dialog_backtitle}" \
	--guage "Moving save files..." 10 70 0 2>&1 > /dev/console
	
	dialog \
	--title "${dialog_title}" \
	--backtitle "${dialog_backtitle}" \
	--msgbox "Save file migration complete" 10 30 2>&1 > /dev/console

	Quit


}




ShowDisclaimer
Quit
