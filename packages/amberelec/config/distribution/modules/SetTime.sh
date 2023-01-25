#!/bin/bash
# based on code from https://github.com/Rolen47/ChangeTime

export SDL_GAMECONTROLLERCONFIG_FILE="/storage/.config/SDL-GameControllerDB/gamecontrollerdb.txt"
source /usr/bin/env.sh
export TERM=xterm-color
export DIALOGRC=/etc/amberelec.dialogrc
echo -e '\033[?25h\033[?16;224;238c' > /dev/console
clear > /dev/console

gptokeyb SetTime.sh -c /usr/config/gptokeyb/settime.gptk &

userQuit() {
 kill -9 $(pidof gptokeyb)
 echo -e '\033[?25l' > /dev/console
 clear > /dev/console
 exit 0
}

MainMenu() {
 local dialog_options=( 1 "Set Time" 2 "Set Date" 3 "Quit" )

 while true; do
  current_time=`date +%H:%M:%S`
  current_date=`date +%F`
  current_zone=`date +%Z`
  show_dialog=(dialog \
  --title " Main menu " \
  --clear \
  --no-cancel \
  --menu "$current_date $current_time $current_zone" 0 0 1)

  choices=$("${show_dialog[@]}" "${dialog_options[@]}" 2>&1 > /dev/console) || userQuit

  for choice in $choices; do
    case $choice in
    1) SetTime ;;
    2) SetDate ;;
    3) userQuit ;;
   esac
  done
 done
}

SetTime() {
 show_dialog=(dialog --title " Set Time " --timebox "Use Left/Right/Y to select the field, use Up/Down to change the value." 5 35)
 desired_time=$("${show_dialog[@]}" 2>&1 > /dev/console) || MainMenu
 if [ "$desired_time" != "" ]; then
  date +%T -s "$desired_time"
  hwclock --systohc --utc
 fi
}

SetDate() {
 show_dialog=(dialog --date-format "%Y-%m-%d" --title " Set Date " --calendar "Use Y to switch between Month, Year and Day selection, use Up/Down/Left/Right to select the value." 0 0)
 desired_date=$("${show_dialog[@]}" 2>&1 > /dev/console) || MainMenu
 if [ "$desired_date" != "" ]; then
  current_time=`date +%H:%M:%S`
  date +%Y-%m-%d -s "$desired_date $current_time"
  hwclock --systohc --utc
 fi
}

MainMenu
userQuit