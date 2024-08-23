from subprocess import PIPE, run
import subprocess
from pathlib import Path


def list_archive(path: Path) -> 'List[str]':
	"""Reads an archive file and returns an array of all files inside it"""
	#7z path needs to be given explicitly, otherwise it won't find 7z.so
	sevenzip_proc = subprocess.run(['/usr/bin/7z', 'l', '-slt', path], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, check=False)
	if sevenzip_proc.returncode != 0:
		raise OSError(sevenzip_proc.stderr.strip())
	#Ignore the first Path = line which is the archive itself
	return [line[len('Path = '):] for line in sevenzip_proc.stdout.splitlines() if line.startswith('Path = ')][1:]


def show_sanity_warn( message, force_quit=True ) :
	"""This function's sole purpose is to tell the user what we're doing and then ask for consent. If none is given, we stop here."""
	run(f'. /etc/profile && text_viewer -m "%s" -t "AmberELEC Sanity Checker" -w -e' % message, shell=True, stdout=PIPE, stderr=PIPE, universal_newlines=True, check=False)
	if ( True == force_quit ) :
		exit()



def sanity_log():
	"""Run this when you want to show a generic error to the user and zip the logs"""
	try :
		command = ["zip", "-r", "/roms/logs.zip", "/tmp/logs"]
		run(command, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
	finally:
		show_sanity_warn( "A general error has occurred!\n\nIf you wish to get help with this issue, we've zipped your log files.\n\nThey are located at <roms_folder>\\logs.zip\n\nMake sure to send us this file on discord with as much information as you can if you are going to need help!", False )

def sanity_check(rom, platform, emulator, core, args):
	"""Run this to check all parameters for known issues and warn the user"""

	def search_archive(zip_file, filename):
		"""Some roms come in archives, and sometimes they don't have the right ROM file we need, this checks for an extension and acts accordingly!"""
		try:
			files = list_archive(zip_file)
			for file in files:
				if file.lower().endswith(filename):
					return True

		except OSError:
			show_sanity_warn("An error has occurred...\n\nCould not load the ROM for validation at all...\n\nError type : OS Error\nPath : "+zip_file)
		except Exception:
			show_sanity_warn("The archive file you have attempted to open is either corrupt, not found, not a known format or correct extension.")
		return False

	def is_archive(extension):
		"""Simple function to check if the extension is an archive. easier to make it a function than to copy/paste code"""
		return ( extension == ".zip" or extension == ".7z" )

	# Make sure the extension of the rom file can be easily read
	extension = rom.suffix.lower()

	# MacOS creates files that start with ._ for metadata, imagine something like ._Final Fantasy VII.pbp and it'll be ~3KB
	# You can't run it since it's not a real rom and only metadata, so show the user what's going on 
	if (rom.name.startswith("._")):
		show_sanity_warn("You are attempting to load a MacOS metadata file as a ROM, this won't work.\n\nPlease run our \"Run Remove ._ Files\" tool in EmulationStation to clear out these files!")

	if (platform == "psx" ):
		# First we check duckstation. Our core does not support .pbp files
		if (extension == ".pbp" and core == "duckstation" ):
			show_sanity_warn("The Duckstation core does not support .pbp files.\n\nPlease try another core for this rom!")

	if (platform == "neogeo" ):
		
		# Let's first check if we're dealing with a .neo file in any way...
		is_neo_file = False
		if (is_archive(extension)):
			is_neo_file = search_archive(args['rom'], ".neo")
		elif ( extension == ".neo" ):
			is_neo_file = True
	
		if (core != "geolith" and is_neo_file) :
			show_sanity_warn("You have attempted to load either a .neo file or an archive with a .neo file.\n\nThe only core compatible with it is the Geolith core\n\nPlease set your core settings accordingly...")

		if (core == "geolith" and not is_neo_file) :
			show_sanity_warn("The Geolith core only supports .neo files, or archives with .neo files inside!\n\nPlease change your configuration and use another core to run this ROM!")

	if (platform == "pc"):
		# Dosbox core does not support the .dosz format, make sure our users know...
		if (extension == ".dosz" and core == "dosbox_core"):
			show_sanity_warn("The core \"Dosbox Core\" does not support .dosz files.\n\nPlease use \"Dosbox Pure\" for this format!")

	
