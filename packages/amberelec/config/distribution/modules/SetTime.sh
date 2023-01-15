#!/bin/bash

source /usr/bin/env.sh
export TERM=xterm-color
export DIALOGRC=/etc/amberelec.dialogrc

gptokeyb SetTime.sh -c /usr/config/gptokeyb/settime.gptk &

clear > /dev/console

userQuit() {
 kill -9 $(pidof gptokeyb)
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
  --menu "$current_date $current_time $current_zone" 0 0 0)
	
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
 show_dialog=(dialog --title " Set Time " --timebox "" 0 0)
 desired_time=$("${show_dialog[@]}" 2>&1 > /dev/console) || MainMenu
 if [ "$desired_time" != "" ]; then
  date +%T -s "$desired_time"
  hwclock --systohc --utc
 fi
}

SetDate() {
 show_dialog=(dialog --date-format "%Y-%m-%d" --title " Set Date " --calendar "" 0 0)
 desired_date=$("${show_dialog[@]}" 2>&1 > /dev/console) || MainMenu
 if [ "$desired_date" != "" ]; then
  current_time=`date +%H:%M:%S`
  date +%Y-%m-%d -s "$desired_date $current_time"
  hwclock --systohc --utc
 fi
}

MainMenu
userQuit