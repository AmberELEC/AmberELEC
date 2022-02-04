#!/usr/bin/env python3

import datetime
import os
import shlex
import subprocess
import sys
from pathlib import Path
from typing import TYPE_CHECKING, Optional

if TYPE_CHECKING:
	#These except Union are deprecated in 3.9 and should be replaced with collections.abc / builtin list type, but we have 3.8 for now
	from typing import List, Mapping, Sequence, Tuple, Union, MutableMapping

LOGS_DIR = Path('/tmp/logs')
BASH_EXE = '/usr/bin/bash'
RA_TEMP_CONF = '/storage/.config/retroarch/retroarch.cfg'
RA_APPEND_CONF = '/tmp/raappend.cfg'
LOG_PATH = LOGS_DIR / 'exec.log'

def call_profile_func(function_name: str, *args: str) -> str:
	#We are going to want to call some stuff from /etc/profile, they are defined in ../profile.d/99-distribution.conf
	proc = subprocess.run(f'. /etc/profile && {shlex.quote(function_name)} {shlex.join(args)}', shell=True, stdout=subprocess.PIPE, check=True, text=True)
	return proc.stdout.strip('\n')

def get_es_setting(setting_type: str, setting_name: str) -> str:
	#from es_settings.cfg (XML)
	return call_profile_func('get_es_setting', setting_type, setting_name)

#Not sure why these were originally two variables? Should we always log?
log_level = get_es_setting('string', 'logLevel')
should_log = log_level != 'minimal'
verbose = log_level != 'minimal'

def jslisten_set(*exe_names: str):
	#exe_names are passed as one argument, intended for killall to use them later
	call_profile_func('jslisten', 'set', shlex.join(exe_names))

def jslisten_stop():
	call_profile_func('jslisten', 'stop')

def get_elec_setting(setting_name, platform=None, rom=None):
	#From distribution.conf
	#Potentially this can be reimplemented in Python if that turns out to be a good idea
	return call_profile_func('get_ee_setting', setting_name, platform, rom)

def set_elec_setting(setting_name, value):
	call_profile_func('set_ee_setting', setting_name, value)

def check_bios(platform, core, emulator, game, log_path):
	call_profile_func('ee_check_bios', platform, core, emulator, game, log_path)

def download_things_if_needed(core):
	if core == 'freej2me':
		#freej2me needs the JDK to be downloaded on the first run
		subprocess.run('/usr/bin/freej2me.sh', check=True)
		os.environ['JAVA_HOME']='/storage/jdk'
		os.environ['PATH'] = '/storage/jdk/bin:' + os.environ['PATH']
	elif core == 'easyrpg':
		# easyrpg needs runtime files to be downloaded on the first run
		subprocess.run('/usr/bin/easyrpg.sh', check=True)
		
def log(text):
	if should_log:
		with LOG_PATH.open('at', encoding='utf-8') as log_file:
			print(text, file=log_file)
	else:
		print('runemu.py:', text)

def cleanup_and_quit(return_code):
	if verbose:
		log('Cleaning up and exiting')

	#bluetooth_toggle(True)
	jslisten_stop()
	clear_screen()
	subprocess.run([BASH_EXE, '/usr/bin/show_splash.sh', 'exit'], check=False) #This seems to always return 1
	#subprocess.check_call([BASH_EXE, '/usr/bin/setres.sh'])
	call_profile_func('normperf')
	call_profile_func('set_audio', 'default')
	sys.exit(return_code)

def clear_screen():
	if verbose:
		log('Clearing screen')
	with open('/dev/console', 'wb') as console:
		subprocess.run('clear', stdout=console, check=True)

standalone_emulators: 'MutableMapping[str, Tuple[str, Sequence[str]]]' = {
	'AMIBERRY': ('amiberry', ['/usr/bin/amiberry.start', '<path>']),
	'AdvanceMame': ('advmame', ['/usr/bin/advmame.sh', '<path>']),
	'HATARISA': ('hatari', ['/usr/bin/hatari.start', '<path>']),
	'HYPSEUS': ('hypseus', ['/usr/bin/hypseus.start.sh', '<path>']),
	'OPENBOR': ('openbor', ['/usr/bin/openbor.sh', '<path>']),
	'PPSSPPSDL': ('PPSSPPSDL', ['/usr/bin/ppsspp.sh', '<path>']),
	'SCUMMVMSA': ('scummvm', ['/usr/bin/scummvm.start', 'sa', '<path>']),
	'STELLASA': ('stella', ['/usr/bin/stella.sh', '<path>']),
	'drastic': ('drastic', ['/usr/bin/drastic.sh', '<path>']),
	'ecwolf': ('ecwolf', ['/usr/bin/ecwolf.sh', '<path>']),
	'gzdoom': ('gzdoom', ['/usr/bin/gzdoom.sh', '<path>']),
	'lzdoom': ('lzdoom', ['/usr/bin/lzdoom.sh', '<path>']),
	'mpv': ('mpv', ['/usr/bin/mpv_video.sh', '<path>']),
	'pico8': ('pico8_dyn', ['/usr/bin/pico-8.sh', '<path>']),
	'piemu': ('piemu', ['/usr/bin/piemu.sh', '<path>']),
	'raze': ('raze', ['/usr/bin/raze.sh', '<path>']),
	'solarus': ('solarus-run', ['/usr/bin/solarus.sh', '<path>']),
}

def _load_customized_standalone_emulators():
	try:
		with open('/storage/.config/standalone_emulators', 'rt', encoding='utf-8') as f:
			for line in f:
				if ': ' not in line or line.startswith('#'):
					continue
				name, rest = line.rstrip().split(': ', 1)
				args = rest.split(' ')
				kill_name = name
				#If name of exe to kill was not listed, assume it is the same as the emulator name
				if not args[0].startswith('/'):
					kill_name = args[0]
					args = args[1:]
				standalone_emulators[name] = (kill_name, args)
	except (FileNotFoundError, ValueError):
		pass

_load_customized_standalone_emulators()

def get_standalone_emulator_command(rom: Optional[Path], platform: Optional[str], emulator: str) -> 'Sequence[Union[str, Path]]':
	if verbose:
		log('Running a standalone emulator:')
		log(f'platform: {platform}')
		log(f'emulator: {emulator}')
	#Core is not actually relevant (other than Mupen64Plus which is in another function)
	command: 'List[Union[str, Path]]' = [BASH_EXE]
	
	jslisten_exe, placeholder_args = standalone_emulators[emulator]
	command += [arg for arg in (rom if arg == '<path>' else arg for arg in placeholder_args) if arg]

	jslisten_set(jslisten_exe)
	return command

def get_retroarch_command(rom: Optional[Path], platform: Optional[str], core: str, args: 'Mapping[str, str]', shader_arg: str) -> 'Sequence[Union[str, Path]]':
	if verbose:
		log('Running a libretro core via RetroArch')
		log(f'platform: {platform}')
		log(f'core: {core}')
	retroarch_binary = 'retroarch'
	if core in {'pcsx_rearmed', 'parallel_n64'}:
		retroarch_binary = 'retroarch32'
		os.environ['LD_LIBRARY_PATH'] = '/usr/lib32'
	
	rom_path: 'Optional[Union[str, Path]]' = rom

	if rom:
		if platform == 'doom' and rom.suffix == '.doom':
			subprocess.run(['dos2unix', rom], check=True) #Hmmmmm but do we need that
			with rom.open('rt', encoding='utf-8') as doomfile:
				for line in doomfile:
					key, _, value = line.partition('=')
					if key == 'IWAD':
						rom_path = value
						break
		if core == 'scummvm' and rom.suffix == '.scummvm':
			#ScummVM libretro core actually only works with .scummvm files that just have the game ID with no path specified, which isn't how they are generated by the scummvm scanner script
			#But if you give it any other path to a file, it will autodetect a game inside that file's parent directory, even if the file doesn't actually exist
			#This would otherwise be what /usr/bin/scummvm.start tries to do when its first arg is "libretro", by cd'ing into that game directory
			path = Path(rom.read_text(encoding='utf-8').split('"')[1])
			rom_path = path / 'game'

	jslisten_set(retroarch_binary)
	command: 'List[Union[str, Path]]' = [os.path.join('/usr/bin/', retroarch_binary), '-L', Path('/tmp/cores/', f'{core}_libretro.so')]
	
	if verbose:
		command.append('--verbose')

	if 'host' in args or 'connect' in args:
		netplay_nick = get_elec_setting('netplay.nickname')
		if not netplay_nick:
			netplay_nick = '351ELEC'
		if 'connect' in args:
			set_elec_setting('netplay.client.port', args['port'])
			set_elec_setting('netplay.client.ip', args['connect']) #We should now have parsed that properly so it's just a hostname/IP address, no --port argument
			command += ['--connect', args['connect'] + '|' + args['port']]
		if 'host' in args:
			command += ['--host', args['host']]
			
		command += ['--nick', netplay_nick]

	if core == 'fbneo' and platform == 'neocd':
		command += ['--subsystem', platform]
	if shader_arg:
		#Returned from setsettings, this is of the form "--shader-set /tmp/shaders/blahblahblah", apparently actually needed even if video_shader is set in RA_APPEND_CONF
		command += shlex.split(shader_arg)
	command += ['--config', RA_TEMP_CONF, '--appendconfig', RA_APPEND_CONF]
	if rom_path:
		command.append(rom_path)
	
	return command

def get_retrorun_command(rom: Path, platform: str, core: str) -> 'Sequence[Union[str, Path]]':
	core_path = Path('/tmp/cores/', f'{core}_libretro.so')
	if verbose:
		log('Running a libretro core via retrorun')
		log(f'platform: {platform}')
		log(f'core: {core}')
	jslisten_set('retrorun', 'retrorun32')
	return [BASH_EXE, '/usr/bin/retrorun.sh', core_path, rom, platform]

def get_mupen64plus_standalone_command(rom: Path, video_plugin: str) -> 'Sequence[Union[str, Path]]':
	if verbose:
		log(f'Running Mupen64Plus standalone with {video_plugin} plugin')
	jslisten_set('mupen64plus')
	return [BASH_EXE, '/usr/bin/m64p.sh', video_plugin, rom]

def get_command(rom: Optional[Path], platform: Optional[str], emulator: Optional[str], core: Optional[str], args: 'Mapping[str, str]', shader_arg: str) -> 'Sequence[Union[str, Path]]':
	if rom and (rom.suffix == '.sh' or platform == 'tools'):
		#If the ROM is a shell script then just execute it
		return [rom]
	elif emulator == 'retroarch':
		if not core:
			raise ValueError('runemu.py was called improperly, tried to launch RetroArch with no core')
		return get_retroarch_command(rom, platform, core, args, shader_arg)
	elif emulator == 'retrorun':
		if not rom:
			raise ValueError('runemu.py was called improperly, tried to launch retrorun with no game')
		if not platform:
			raise ValueError('runemu.py was called improperly, tried to launch retrorun with no platform')
		if not core:
			raise ValueError('runemu.py was called improperly, tried to launch retrorun with no core')
		return get_retrorun_command(rom, platform, core)
	elif emulator == 'mupen64plussa':
		if not rom:
			raise ValueError('runemu.py was called improperly, tried to launch Mupen64Plus with no game')
		if not core:
			raise ValueError('runemu.py was called improperly, tried to launch Mupen64Plus with no video plugin')
		return get_mupen64plus_standalone_command(rom, core)
	else:
		if not emulator:
			raise ValueError('runemu.py was called improperly, tried to launch a standard emulator with no emulator')
		return get_standalone_emulator_command(rom, platform, emulator)

def setsettings(rom, core, platform, args) -> str:
	#Note!!! When #740 is merged, replace this with:
	#(from setsettings import set_settings goes at the top)
	#return set_settings(rom_name=rom, core=core, platform=platform, controllers=args['controllers'], autosave=args.get('autosave'), snapshot=args.get('state_slot'))
	#I guess then this doesn't need to be a function

	setsettings_args = ['/usr/bin/setsettings.sh', platform, rom, core]
	if 'controllers' in args:
		setsettings_args.append('--controllers=' + args['controllers'])
	if 'autosave' in args: #Automatically added by ES even if not specified; if autosave is enabled
		setsettings_args.append('--autosave=' + args['autosave'])
	#Automatically added by ES even if not specified; if autosave is enabled, if not, setsettings.sh (as it is now) expects this argument anyway
	setsettings_args.append('--snapshot=' + args.get('state_slot', ''))

	if verbose:
		log(f'Executing setsettings: {setsettings_args}')
	setsettings_proc = subprocess.run(['' if arg is None else arg for arg in setsettings_args], stdout=subprocess.PIPE, check=True, universal_newlines=True)
	return setsettings_proc.stdout

def main():
	i = 0
	args = {}
	while i < len(sys.argv):
		if sys.argv[i].startswith('--'):
			args[sys.argv[i][2:]] = sys.argv[i + 1]
			i += 1
		i += 1

	rom = Path(args['rom']) if 'rom' in args else None
	platform = args.get('platform')
	core = args.get('core')
	emulator = args.get('emulator')
		
	if should_log:
		LOG_PATH.unlink(missing_ok=True)
		LOGS_DIR.mkdir(parents=True, exist_ok=True)
		LOG_PATH.touch()

	log(f'Emulation run log: Started at {datetime.datetime.now()}')
	log(f'Args: {args}')

	download_things_if_needed(core)

	if get_elec_setting('maxperf', platform, rom.name if rom else None) == '1':
		if verbose:
			log('Enabling max performance as requested')
		call_profile_func('maxperf')
	else:
		call_profile_func('normperf')
	
	#Disable netplay by default
	set_elec_setting('netplay.client.ip', 'disable')
	set_elec_setting('netplay.client.port', 'disable')

	clear_screen()
	#bluetooth_toggle(False) #I'm not sure this does anything useful here, so I haven't reimplemented it
	jslisten_stop()
	
	shader_arg = setsettings(rom, core, platform, args)

	if core and not emulator:
		#This is called from the inside of a port .sh that runs a libretro port (e.g. 2048, tyrQuake, etc), it makes no sense otherwise
		emulator = 'retroarch'

	command = get_command(rom, platform, emulator, core, args, shader_arg)
	
	clear_screen()
	if verbose:
		log(f'Executing game: {rom}')
		log(f'Executing {command}')
	with LOG_PATH.open('at', encoding='utf-8') as log_file:
		completed_process = subprocess.run(command, stdout=log_file, stderr=subprocess.STDOUT, check=False, text=True)

	clear_screen()
	if verbose:
		log(f'Process return code: {completed_process.returncode}')
	if completed_process.returncode == 0:
		cleanup_and_quit(0)
	else:
		requires_bios = {'atari5200', 'atari800', 'atari7800', 'atarilynx', 'colecovision', 'amiga', 'amigacd32', 'o2em', 'intellivision', 'pcengine', 'pcenginecd', 'pcfx', 'fds', 'segacd', 'saturn', 'dreamcast', 'naomi', 'atomiswave', 'x68000', 'neogeo', 'neogeocd', 'msx', 'msx2', 'sc-3000'}
		if platform in requires_bios:
			if platform == 'msx2':
				platform_to_check = 'msx2'
			elif platform == 'pcenginecd':
				platform_to_check = 'pcengine'
			elif platform == 'amigacd32':
				platform_to_check = 'amiga'
			else:
				platform_to_check = platform
			check_bios(platform_to_check, core, emulator, rom, LOG_PATH)
		cleanup_and_quit(1)

if __name__ == '__main__':
	main()
