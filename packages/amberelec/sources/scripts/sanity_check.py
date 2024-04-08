from subprocess import PIPE, run
import zipfile
import subprocess

def show_sanity_warn( message, force_quit=True ) :
	"""This function's sole purpose is to tell the user what we're doing and then ask for consent. If none is given, we stop here."""
	run(["text_viewer", "-m", message, "-t", "AmberELEC Sanity Checker"], stdout=PIPE, stderr=PIPE, universal_newlines=True, check=False)
	if ( True == force_quit ) :
		exit()



def sanity_log():
	"""Run this when you want to show a generic error to the user and zip the logs"""
	try :
		command = ["zip", "-r", "/roms/logs.zip", "/tmp/logs"]
		run(command, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
	finally:
		show_sanity_warn( "A general error has occurred!\n\nIf you wish to get help with this issue,\nwe've zipped your log files.\n\nThey are located at <roms_folder>\\logs.zip\n\nMake sure to send us this file on discord\nWith as much information as you can\nIf you are going to need help!\n\nExiting...", False )

def sanity_check(rom, platform, emulator, core, args):
	"""Run this to check all parameters for known issues and warn the user"""

	def search_zip_file(zip_file, filename):
		"""Some roms come in .ZIP format, and sometimes they don't have the right ROM file we need, this checks for an extension and acts accordingly!"""
		try:
			with zipfile.ZipFile(zip_file, 'r') as zip_file:
				for file_info in zip_file.infolist():
					if file_info.filename.lower().endswith(filename):
						return True
		except Exception:
			show_sanity_warn("The zip file you have attempted to open is either corrupt or not found\n\nExiting...")
		return False

	# Make sure the extension of the rom file can be easily read
	extension = rom.suffix.lower()

	# First we check duckstation. Our core does not support .pbp files
	if (extension == ".pbp" and core == "duckstation" ):
		show_sanity_warn("The Duckstation core does not support .pbp files.\n\nPlease try another core for this rom!\n\nExiting...")

	# Geolith is its own beast, but I need to double check if a zip file it opens has a .neo file inside...
	if (core == "geolith" and extension == ".zip"):
		if( False == search_zip_file(args['rom'], ".neo") ):
			show_sanity_warn("You tried to load a .zip file with the Geolith core\nbut it only supports either .neo files or\n.zip files with a .neo file inside which this one does not!\n\nExiting...")

	# I also need to make sure that if we're opening a .neo file, that we do it with Geolith!
	if (extension == ".neo" and core != "geolith" ):
		show_sanity_warn("Only the Geolith core supports .neo files.\n\nPlease try another core for this rom!\n\nExiting...")
