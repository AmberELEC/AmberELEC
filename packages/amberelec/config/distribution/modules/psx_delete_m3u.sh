#!/bin/bash

# Clear the screen
printf "\033c" >> /dev/tty1

# PSX roms path
cd /storage/roms/psx/

# remove all m3u
find . -type f -name '*.m3u' -delete

#set show folder to auto

if  grep -q '<string name="psx.FolderViewMode" value=..*$' /storage/.config/emulationstation/es_settings.cfg

	then
         sed -i -e '/<string name="psx.FolderViewMode" value=..*$/d' /storage/.config/emulationstation/es_settings.cfg ; 
	 
fi

#show extension
if  grep -q '<string name="psx.HiddenExt" value="bin;cue;img;mdf;pbp;toc;cbn;ccd;chd;iso" \/>' /storage/.config/emulationstation/es_settings.cfg

	then
         sed -i 's/	<string name="psx.HiddenExt" value=..*$/	<string name="psx.HiddenExt" value="bin;img;mdf;pbp;toc;cbn;iso" \/>/g' /storage/.config/emulationstation/es_settings.cfg ; 
	 
fi

#success message
printf "\nm3u files have been deleted\nEmulationstation will now be restarted." >> /dev/tty1 
sleep 3

# Clear the screen
printf "\033c" >> /dev/tty1

# kill emulationstation for refresh

systemctl restart emustation