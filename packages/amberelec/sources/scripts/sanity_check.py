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
	run(["text_viewer", "-m", message, "-t", "AmberELEC Sanity Checker"], stdout=PIPE, stderr=PIPE, universal_newlines=True, check=False)
	if ( True == force_quit ) :
		exit()



def sanity_log():
	try :
		command = ["zip", "-r", "/roms/logs.zip", "/tmp/logs"]
		run(command, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
	finally:
		show_sanity_warn( "A general error has occurred!\n\nIf you wish to get help with this issue,\nwe've zipped your log files.\n\nThey are located at <roms_folder>\\logs.zip\n\nMake sure to send us this file on discord\nWith as much information as you can\nIf you are going to need help!\n\nExiting...", False )

def sanity_check(rom, platform, emulator, core, args):

	def search_archive(zip_file, filename):
		"""Some roms come in .ZIP format, and sometimes they don't have the right ROM file we need, this checks for an extension and acts accordingly!"""
		try:
			files = list_archive(zip_file)
			for file in files:
				if file.lower().endswith(filename):
					return True
#			with zipfile.ZipFile(zip_file, 'r') as zip_file:
#				for file_info in zip_file.infolist():
#					if file_info.filename.lower().endswith(filename):
#						return True

		except OSError:
			show_sanity_warn("An error has occurred...\n\nCould not load the ROM for validation at all...\n\nError type : OS Error\nPath : "+zip_file+"\n\nExiting...")
		except Exception:
			show_sanity_warn("The zip file you have attempted to open is either corrupt or not found\n\nExiting...")
		finally:
			return False

	extension = rom.suffix.lower()

	# First we check duckstation. Our core does not support .pbp files
	if (extension == ".pbp" and core == "duckstation" ):
		show_sanity_warn("The Duckstation core does not support .pbp files.\n\nPlease try another core for this rom!\n\nExiting...")

	# Geolith is its own beast, but I need to double check if a zip file it opens has a .neo file inside...
	if (core == "geolith" and extension == ".zip"):
		if( False == search_archive(args['rom'], ".neo") ):
			show_sanity_warn("You tried to load a .zip file with the Geolith core\nbut it only supports either .neo files or\n.zip files with a .neo file inside which this one does not!\n\nExiting...")

	# I also need to make sure that if we're opening a .neo file, that we do it with Geolith!
	if (extension == ".neo" and core != "geolith" ):
		show_sanity_warn("Only the Geolith core supports .neo files.\n\nPlease try another core for this rom!\n\nExiting...")
