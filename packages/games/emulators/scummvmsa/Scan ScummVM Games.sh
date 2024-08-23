python3 << END

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present Tiago Medeiros (https://github.com/medeirost)

from subprocess import PIPE, run
import re
from time import sleep
import os

# Which folder we'll be scanning for scummvm games.
gamefolder = "/roms/scummvm/games"

# Which path we'll copy the scummvm.ini to
target_ini_path = "/roms/bios/scummvm.ini"

# Which path we'll copy the scummvm.ini from
source_ini_path = "/storage/.config/scummvm/scummvm.ini"

# Location of the ScummVM binary
scummvmbin = "/usr/bin/scummvm"

# Message and title to use at the beginning.
info_message = "This script will now scan your device for ScummVM Games!\n\nMake sure you put all your games in their own folders\n inside <roms>\\scummvm\\games\\\n\n\nExample: <roms>\scummvm\games\Monkey Island 2\n\n\nContinue?"
info_title   = "AmberELEC ScummVM Game Scanner"

# Message to use at the results screen
result_message = "These are the games we found:\n\n"
result_message_end = "\n\nIf any game was found, it was already added\n and should show up in EmulationStation!\n\n\nIf your game isn't in this list, double check you put the game\n files in its own folder under <roms>\scummvm\games\n and run this script again!"

# Message for no games found in the results screen
result_nogame = "None were found :("

# Where we're putting the .scummvm files.
output_path  = "/roms/scummvm"

# Finally, the file extension we're using for these files:
output_ext  = ".scummvm"

# We store working game names here to show in the results screen
game_name_list = []

def show_info_screen():
	"""This function's sole purpose is to tell the user what we're doing and then ask for consent. If none is given, we stop here."""


	result = run(["text_viewer", "-m", info_message,"-y", "-t", info_title], stdout=PIPE, stderr=PIPE, universal_newlines=True, check=False)
	if result.returncode == 0:
		echo ("Exiting without scanning")
		sleep(2)
		cls()
		exit(0)
	else:
		echo ("Scanning for ScummVM Games...\n")

def echo(text):
	"""To show text on the "AmberELEC" one must pipe text to /dev/console this handles it"""

	with open("/dev/console","a") as f:
		f.write(text)

def cls():
	"""clears screen"""
	echo("\033[0;0H")
	echo("                                                       ")
	echo("\033[0;0H")

def show_results_screen():
	"""Sole purpose of this one is to show the results to the user afterwards"""

	# Copy the results message to a temp variable
	output = result_message

	# loop through the game list
	if game_name_list:

		# If we have one or more, append it to the output message
		for game in game_name_list:
			output = output+"- "+game+"\n"
	else:
		# if we have none, just show the "none" message
		output = output+"- "+result_nogame

	# Append the end of the message to the temp variable
	output = output+result_message_end

	# Run the fancy text viewer with our nice message
	run(["text_viewer", "-m", output, "-t", info_title], check=False)

	# Clear screen
	cls()

	# Restart Emulation Station
	run(["systemctl","restart","emustation"], check=False)

def read_scummvm_game_line(line):
	"""This function's purpose is to parse each line and return a list with the ID, name and path of a found game. Will return false if something is up"""


	try:
		# This is a regular expression that looks for text at the beginning of the
		# string, a ":" character, and any alphanumeric set afterwards until an
		# unspecified character shows up (Such as a space character)
		full_id = re.findall(r"^[a-zA-Z0-9]+\:[a-zA-Z0-9]+",line)[0]

		# since we can't use "scumm:monkey2" we need only "monkey2", so...
		game_id = full_id[full_id.index(":")+1:]

		# Here, we grab the path to the game, using @gamefolder as the search key
		path = line[line.index(gamefolder):]

		# And here comes the part with the game, this will take some magic.
		# We replace the ID and path to the game with " ". We then trim
		# the resulting string and it *SHOULD* give us a clean name.
		name = line.replace(full_id,"").replace(path,"").strip()

		# Some users like having multiple versions of the same game.
		# Let's grab the version info before cleaning the string
		match = re.search(r'\((.*?)\)', name)
		version = match.group(1) if match else ''
		if version:
			version = re.sub(r'[\/?\\><:*|]', '_', version)

		# And now, we clean that version number stuff off our name
		# since this is more than likely gonna cause FS issues.
		# And since not all games have it, let's check first...
		if name.find("(") > -1:
			name = name[0:name.index("(")].strip()

		# One more alteration to the name... Colons not allowed!
		name = name.replace(":"," -")

		# If all went well, let's make sure to add the game to the
		# ScummVM list:
		result = run([scummvmbin, "-a", "--path="+path], capture_output=True, check=False, universal_newlines=True)

		# Return the list!
		return [game_id,name,path,version]

	except ValueError:
		return False


def make_scummvm_file(gameinfo):
	"""This function creates the .scummvm files according to the settings on the top of the file. Feed it the return of @read_scummvm_game_line and it'll handle the rest."""

	# Create a fullpath to the file (Sans extension, we're checking if we already have this game created)
	fullpath=output_path+"/"+gameinfo[1]

	# If we already have a file for this game, differenciate it
	# Based on the version
	if os.path.exists(fullpath+output_ext):
		f = open(fullpath+" "+gameinfo[3]+output_ext, "w+")
	else:
		f = open(fullpath+output_ext, "w+")

	# Output the parameters and a couple of newlines
	f.write(f"--path=\"{gameinfo[2]}\" {gameinfo[0]}\n\n")

	# Close the file
	f.close()


def scan_scummvm_games():
	"""This calls ScummVM to scan through all games. It then grabs the output and sends it off to read_scummvm_game_line to split all values"""

	# Grab the list by using scummvm's internal scanning routine
	# --detect doesn't change any configs so we can use this
	# without any changes to the OS/config
	result = run([scummvmbin, "--path="+gamefolder, "--detect", "--recursive"], capture_output=True, check=False, universal_newlines=True)

	# Split the output so we can better manage it.
	gamelist = result.stdout.splitlines()

	# Output for this list usually starts after a lot of "---"
	# So we only start adding games when we are AFTER this list item
	start = False

	# So loop through the list we got
	for game in gamelist:
		# If we haven't found that "---" yet, don't bother reading the output.
		if start is False :
			try:
				game.index("----")
				start = True
			except ValueError:
				continue
		# if we *DID* find the "---" start processing each line
		else:
			# First process that line
			gameinfo = read_scummvm_game_line(game)
			if gameinfo is False:
				continue
			make_scummvm_file(gameinfo)
			game_name_list.append(gameinfo[1])

def copy_file(src: str, dst: str) -> bool:
	"""
	Copy a file from one location to another.
	:param src: The source file path
	:param dst: The destination file path
	:return: True if the copy was successful, False otherwise
	"""
	try:
		with open(src, 'rb') as src_file:
			with open(dst, 'wb') as dst_file:
				dst_file.write(src_file.read())
		return True
	except FileNotFoundError:
		return False
	except Exception as e:
		return False




cls()
show_info_screen()
scan_scummvm_games()
show_results_screen()
copy_file(source_ini_path,target_ini_path)
END
