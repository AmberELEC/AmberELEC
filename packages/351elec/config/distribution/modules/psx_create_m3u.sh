#!/bin/bash
#
# Original script https://github.com/danyboy666/Generate-PSX-m3u-playlist/blob/master/generate_psx_m3u.sh
# Modified by Raven Kilit
# Usage : Copy script in working dir and execute.
# Simple script to generate an .m3u playlist file for every title found in the folder and subfolder
# This will take care of multi disc as well as single disk.
# Multi-disc games must be labeled with one of the following keywords: (Disc ), (disc ), (Disk ), (disk ), Disc, disc, Disk, disk, (CD ), (cd ), CD, cd.  E.g. Final Fantasy VII (Disc 1)

# Clear the screen
printf "\033c" >> /dev/tty1

# PSX roms path
cd /storage/roms/psx/

# remove all m3u
find . -type f -name '*.m3u' -delete

totf=0

#spin
spinner=( '/' '-' '\' '|' )
while :
do
  printf "\033c" >> /dev/tty1
  printf "\n\nGenerating... ${spinner[i++ % ${#spinner[@]}]}" >> /dev/tty1
  sleep 0.3
done &
spinPID=$!


# convert chd files

shopt -s nullglob
for i in *.[cC][hH][dD] ./*/*.[cC][hH][dD]
do
	((totf+=1))
	a=$i
	i=${i##*/}
	title=$(echo "$i" | sed s'/.chd//gI; s/ (disc..)*$//gI; s/ disc..*$//gI; s/ (disk..)*$//gI; s/ disk..*$//gI; s/ (cd..)*$//gI; s/ cd..*$//gI')
	
	list+=("$title\n")
	echo "$a" >> "$title".m3u
		
	

done

# convert cue files

for i in *.[cC][uU][eE] ./*/*.[cC][uU][eE]
do
	if [ ! -f "$(echo "$i" | sed s/.cue//gI).chd" ]
	then
	((totf+=1))
	a=$i
	i=${i##*/}	
    title=$(echo "$i" | sed s'/.cue//gI; s/ (disc..)*$//gI; s/ disc..*$//gI; s/ (disk..)*$//gI; s/ disk..*$//gI; s/ (cd..)*$//gI; s/ cd..*$//gI')
    
  list+=("$title\n")
	echo "$a" >> "$title".m3u

	fi
done

# convert ccd files

for i in *.[cC][cC][dD] ./*/*.[cC][cC][dD]
do
	if [ ! -f "$(echo "$i" | sed s/.ccd//gI).chd" ] && [ ! -f "$(echo "$i" | sed s/.ccd//gI).cue" ]
	then
	((totf+=1))
	a=$i
	i=${i##*/}	
    title=$(echo "$i" | sed s'/.ccd//gI; s/ (disc..)*$//gI; s/ disc..*$//gI; s/ (disk..)*$//gI; s/ disk..*$//gI; s/ (cd..)*$//gI; s/ cd..*$//gI')
    
  list+=("$title\n")
	echo "$a" >> "$title".m3u

	fi
done

#kill spin
kill "$spinPID"

# Clear the screen
printf "\033c" >> /dev/tty1

#choice hide extensions and subfolder

IFS=$'\n' listsort=($(sort <<<"${list[*]}")); unset IFS

text_viewer -w -y -t "Generation completed!" -m "\nWould you like to hide the other extensions and subfolders?\n\nGames detected: "$totf"\n\n ${listsort[*]}"
response=$?

case $response in

  0) ;;

  21) #hide subfolder

if  grep -q '<string name="psx.FolderViewMode" value=..*$' /storage/.config/emulationstation/es_settings.cfg

	then
         sed -i 's/	<string name="psx.FolderViewMode" value=..*$/	<string name="psx.FolderViewMode" value="never" \/>/g' /storage/.config/emulationstation/es_settings.cfg ; 
	else
         sed -i '/<\/config>/i \        \<string name="psx.FolderViewMode" value="never" \/>' /storage/.config/emulationstation/es_settings.cfg ; 
fi

#hide other extension

if  grep -q '<string name="psx.HiddenExt" value=..*$' /storage/.config/emulationstation/es_settings.cfg

	then
         sed -i 's/	<string name="psx.HiddenExt" value=..*$/	<string name="psx.HiddenExt" value="bin;cue;img;mdf;pbp;toc;cbn;ccd;chd;iso" \/>/g' /storage/.config/emulationstation/es_settings.cfg ; 
	else
         sed -i '/<\/config>/i \        \<string name="psx.HiddenExt" value="bin;cue;img;mdf;pbp;toc;cbn;ccd;chd;iso" \/>' /storage/.config/emulationstation/es_settings.cfg ; 
fi
     ;;

esac


# restart emulationstation for refresh

systemctl restart emustation