from datetime import datetime, timedelta
import sys

import json
import urllib.request
from urllib.request import Request, urlopen
from urllib.error import HTTPError
import time
import argparse
import logging
import os
import hashlib
import time
from multiprocessing import Pool
import subprocess
import atexit
import socket
import shutil
import re

logger = logging.getLogger(__name__)

# Ensure downloads timeoout w/no data as normal timeout is infinite
socket.setdefaulttimeout(60)


class CONSOLE:
    AMBER = '\033[38;5;220m'
    WHITE = '\033[38;5;255m'
    ENDC = '\033[0m'
    CLEAR = '\033c'


class UpdateError(Exception):
    """Raised when an error happens updating"""

    def __init__(self, message=None):
        self.message = message

OS_VERSION_FILE="/storage/.config/.OS_VERSION"
DEVICE_FILE="/storage/.config/.OS_ARCH"
UPDATE_DIR="/storage/roms/update"
console = "/dev/console"
message_stream_delay = 0.02


# Main method handles main flow including
# all 'message_stream' logging and exiting of the program
def main():

    args = get_args()

    initialize_directories(args.update_dir, args.check)

    message_stream(CONSOLE.CLEAR)
    message_stream(
        f"{CONSOLE.AMBER}Amber{CONSOLE.WHITE}ELEC{CONSOLE.ENDC} Update Utility - Starting Update...\n")

    if not online_status():
        message_stream(
            "\nERROR: No networking detected.  Online updates not available.\n")
        sys.exit(1)

    message_stream(f"\nChecking for updates in the '{args.band}' channel...")
    try:
        current_release = check_current_release(
            args.band, args.org, args.repo)
    except UpdateError as e:
        message_stream(e.message)
        sys.exit(1)

    if not current_release:
        message_stream("\nNo update available\n")
        if not args.check:
            time.sleep(4)
        sys.exit(1)

    if args.force_update:
        message_stream(f"\nForcing update to {current_release}...")
    elif not download_needed(args.existing_release, current_release):
        message_stream(
            f"\nExisting release ({args.existing_release}) >= current release ({current_release}). No download needed\n")
        message_stream_close()
        sys.exit(1)

    if args.check:
        print(current_release)
        sys.exit(0)

    # 3000 MB (307200 bytes)
    try:
        update_dir_has_available_disk(args.update_dir, 3000*1024*1024)
        check_boot_partition_size_correct()

    except UpdateError as e:
        message_stream(e.message)
        sys.exit(1)

    message_stream(
        f"\nUpdating to: {current_release} from: {args.existing_release}\n")
    message_stream(f"\nDownloading (each # = 1.25%)... \n")
    downloaded_file = download_update(
        current_release, args.existing_release, args.device, args.org, args.repo, args.update_dir, show_progress)
    if not downloaded_file:
        message_stream("ERROR: Could not download update.")
        sys.exit(1)
    else:
        message_stream(
            f"\nFile: {os.path.basename(downloaded_file)} downloaded successfully.\n")

def download_needed(existing_release, current_release):

    if not existing_release:
        return True

    # If the current release is a real release and existing device release is not, still download.
    #  This allows 'downgrading' from beta back to any release
    if parse_release(current_release, "release") and not parse_release(existing_release, "release"):
        return True

    if existing_release < current_release:
        return True
    return False

# Create any needed directories
def initialize_directories(update_dir, check):
    update_dir = os.path.abspath(update_dir)
    if not check and not os.path.isdir(update_dir):
        logger.warning(
            f"--update-dir ({update_dir}) does not exist.  Attempting to create")
        os.makedirs(update_dir, exist_ok=True)


def initialize_logging(log_level):
    logging.basicConfig(level=log_level, format="%(levelname)s: %(message)s")


# Map any global variables from args
def set_global_args(args):
    global console
    global message_stream_delay
    console = args.console

    if args.check:
        message_stream_delay = 0
        console = "/dev/null"

    if args.fast_messages:
        message_stream_delay = 0

# Download from github


def download_update(current_release, existing_release, device, org, repo, update_dir, show_progress):

    downloaded_file = None
    repo = f"https://github.com/{org}/{repo}"

    download_file_name = f"AmberELEC-{device}.aarch64-{current_release}.tar"
    download_file_name_sha256 = f"{download_file_name}.sha256"
    download_base_url = f"{repo}/releases/download/{current_release}"
    download_url = f"{download_base_url}/{download_file_name}"
    download_file = f"{update_dir}/{download_file_name}"
    download_url_sha256 = f"{download_base_url}/{download_file_name_sha256}"
    download_file_sha256 = f"{update_dir}/{download_file_name_sha256}"
    sha256 = None

    try:
      logger.info("checking for SHA")
      download(download_url_sha256, download_file_sha256)
    except HTTPError as e:
    
      # After we no longer have the possibility of '351ELEC' named releases - we can remove this
      if e.code == 404:
          logger.info("Could not find release named AmberELEC - falling back to 351ELEC")
          download_file_name = f"351ELEC-{device}.aarch64-{current_release}.tar"
          download_file_name_sha256 = f"{download_file_name}.sha256"
          download_base_url = f"{repo}/releases/download/{current_release}"
          download_url = f"{download_base_url}/{download_file_name}"
          download_file = f"{update_dir}/{download_file_name}"
          download_url_sha256 = f"{download_base_url}/{download_file_name_sha256}"
          download_file_sha256 = f"{update_dir}/{download_file_name_sha256}"

    sha256 = load_file_to_string(download_file_sha256).split(" ")[0]
    if os.path.isfile(download_file):
        file_hash = check_hash(download_file)
        if file_hash != sha256:
            logger.warning(
                f"\nLocal file: {os.path.basename(download_file)} ({file_hash}) does not match hash from github.  Removing and re-downloading...\n")
            os.remove(download_file)

    if not os.path.isfile(download_file):
        download(download_url, download_file, show_progress)
        file_hash = check_hash(download_file)
        if file_hash != sha256:
            return None

    return download_file

# Check if update is available


def check_current_release(band, org, repo):
    """
    Returns true for update, false for none
    """
    current_release = None
    try:
        current_release = get_current_release(org, repo, band)
    except urllib.error.URLError as e:
        logger.debug(e)
        raise UpdateError(
            f"\n\nCould not get current release.  A url error occurred: '{e.reason}'\n")
    except UpdateError as e:
        raise e
    except Exception as e:
        logger.error(e)
        raise UpdateError(
            f"\n\nCould not get current release.  An error occurred: '{e}'\n")

    if current_release == None:
        logger.warning("No current release found")
        return None

    return current_release

# Get existing release from file system
# Can be None if file doesn't exist.


def get_existing_release():
    if os.path.isfile(OS_VERSION_FILE):
        existing_release = load_file_to_string(OS_VERSION_FILE).strip()
        return existing_release
    else:
        logger.warning(
            f"Warning: No existing release found in: {OS_VERSION_FILE}")

def update_dir_has_available_disk(update_dir, required_bytes):

    total_bytes, used_bytes, free_bytes = shutil.disk_usage(update_dir)
    if free_bytes < required_bytes:
        needed_mb = (required_bytes - free_bytes) / 1024 / 1024
        raise UpdateError(message_stream(
            f"\n\nERROR: There is not enough free space available in: {update_dir} to install this update.  Free up an additional ${needed_mb}MB, or reflash this version.")
        )

# This was done in old update script and is likely not needed(?)
# Checks that the flash partition is the correct size (1GB)


def check_boot_partition_size_correct():

    flash_dir = "/flash"
    if not os.path.exists(flash_dir):
        logger.info(
            f"{flash_dir} not found.  Ignoring space requirements...\n")
        return
    # AmberELEC needs 2GB on the boot volume.
    REQUIRED_BOOT_PARTITION_BYTES = 2048000

    total_bytes, used_bytes, free_bytes = shutil.disk_usage(flash_dir)
    if total_bytes < REQUIRED_BOOT_PARTITION_BYTES:
        raise UpdateError(
            f"\n\nERROR: There is not enough space available in the flash partition: {flash_dir} to update via .tar. You must reflash from .img.gz")

# Determines if we are 'online' and can check for an update


def online_status():
    # Check for default route - maybe there's a better way
    output = subprocess.check_output(
        'ip route | grep "default via"', shell=True)
    logger.debug(f"IP route info: {output}")
    if output:
        return True
    else:
        return False


pool = None


# Wait for all mesage_streams to outpu
def message_stream_close():
    global pool
    if pool:
        pool.close()
        pool.join()


def message_stream(message):
    """
    Steams out messages in a similar manner to `message_stream` function.
    Streams asyncronously in the background as to not delay processing.
    """
    global pool
    if not pool:
        pool = Pool(processes=1)

        # Ensure we wait for all messages when we are done
        atexit.register(message_stream_close)

    pool.apply_async(message_stream_sync, [message])


def message_stream_sync(message):
    """
    Streams out messages in a similar mannaer to the emuelec `message_stream` function
    """
    logger.debug(message)
    global console
    with open(console, 'w') as f:
        for char in message:
            print(char, end="", file=f, flush=True)
            time.sleep(message_stream_delay)


def load_file_to_string(local_file):
    with open(local_file, 'r') as file:
        text = file.read()
        logger.debug(f"string: {text}")
        return text

# Get sha256 hash of file


def check_hash(local_file):
    sha256_hash = hashlib.sha256()
    with open(local_file, "rb") as f:
        for contents in iter(lambda: f.read(8192), b""):
            sha256_hash.update(contents)
        file_hash = sha256_hash.hexdigest()
        logger.debug(f"Local file hash: {file_hash}")
        return file_hash


last_mod = 0

# Outputs progress in 80 #'s.  This is the width of the P/V


def show_progress(block_num, block_size, total_size):
    global last_mod
    if last_mod == None:
        last_mod = 0
    current_size = block_num * block_size
    if current_size == 0.0:
        return

    percentage = ((current_size / total_size)*80)
    mod_percentage = 10*percentage
    mod = int(mod_percentage % 10)

    if mod == 0 and last_mod != 0:
        message_stream("#")
        logger.debug(
            f"Percentage: {percentage} mod: {mod} mod_percentage: {mod_percentage}")

    last_mod = mod

# Downloads a file


def download(url, local_file, show_progress=None):
    logger.debug(f"Downloading: {url} to: {local_file}")
    urllib.request.urlretrieve(url, local_file, show_progress)


def get_args():
    parser = argparse.ArgumentParser(
        description='Arguments for picking up release')
    parser.add_argument('--org',
                        default="AmberELEC",
                        help='Github organization. Allows testing with fork releases other than AmberELEC')
    parser.add_argument('--repo',
                        default="AmberELEC",
                        help='Github repository. Allows testing with repo releases other than AmberELEC')
    parser.add_argument('--band',
                        default="release",
                        choices=['release', 'beta', 'prerelease', 'daily', 'dev'],
                        help='''Update "band" ("channel"). Allows determining what latest release to get. 
                             "daily" is for backwards compatibility and maps to "release"
                             "beta" is for backwards compatibility and will map to 'prerelease'
                             ''')
    parser.add_argument('--device',
                        choices=['RG351P', 'RG351V', 'RG351MP'],
                        help=f'Sets the appropriate device for testing.  Will fallback to contents of: {DEVICE_FILE}')
    parser.add_argument('--console',
                        default="/dev/console",
                        help='Sets device to output messages to.  Use /dev/stderr for testing.')
    parser.add_argument('--log-level', '-l',
                        default="WARN",
                        choices=['DEBUG', 'INFO', 'WARN', 'ERROR', 'CRITICAL'],
                        help='Allows setting log level for more debugging')
    parser.add_argument('--update-dir',
                        default=UPDATE_DIR,
                        help='Allows setting a different directory for downloads')
    parser.add_argument('--existing-release',
                        help=f'Overrides release version in "{OS_VERSION_FILE}" for upgrade/testing purposes')
    parser.add_argument('--check',
                        default=False,
                        help='Only check for update - do not download update')
    parser.add_argument('--force-update',
                        dest="force_update",
                        action='store_true',
                        help='Always updates as long as there is a release')
    parser.add_argument('-f', '--fast-messages',
                        nargs="?",
                        default=False,
                        type=bool,
                        help='No delay when printing out messages to the console.  This is always on with --check')
    args = parser.parse_args()
    initialize_logging(args.log_level)

    set_global_args(args)
    
    if args.band == "daily":
        args.band = "release"
    if args.band == "beta":
        args.band = "prerelease"

    if not args.device:
        if os.path.isfile(DEVICE_FILE):
            args.device = load_file_to_string(DEVICE_FILE).strip()
        else:
            args.device="RG351P"

    if not args.existing_release:
        args.existing_release = get_existing_release()
    
    existing_release = parse_release(args.existing_release, args.band)

    #In case of beta, we need to check if it's a beta release too. Otherwise it will not parse due to channel being 'prerelease'
    #TODO: If we end up with a lot of different bands - we may need to refactor this in the future
    if not existing_release:
      existing_release = parse_release(args.existing_release, "beta")
    if not existing_release:
      existing_release = parse_release(args.existing_release, "dev")
    args.existing_release = existing_release
    return args


def get_current_release(org, repo, band, page=0, per_page=100):
    """
    Gets the current release from github.

    Logic:
      - Request releases from github
      - Loop - ignoring prereleases unless band is prerelease
      - When a release matching naming YYYYMMDD is found (ex: 20210603) return
        - This allows new naming conventions to be added and this will only update to latest release of this convention
      - Recursively call this method to get the 'next page' of releases if no matching release is found (shouldn't be needed, but helpful if we move to new naming convention)
    """
    api = f"https://api.github.com/repos/{org}/{repo}"
    try:
        req = Request(f"{api}/releases?per_page={per_page}&page={page}")

        if os.getenv("GITHUB_TOKEN", "") != "":
          token=os.getenv("GITHUB_TOKEN","")
          req.add_header('Authorization' , f"token {token}")
        response = urlopen(req)

    except Exception as e:

        # This should be rare unless we check for releases more than 60 times an hour
        if hasattr(e, 'headers') and 'X-RateLimit-Remaining' in e.headers and e.headers['X-RateLimit-Remaining'] == "0":
            logger.debug(e.headers)
            rate_expiration = datetime.now() + timedelta(hours=1)
            if 'X-RateLimit-Reset' in e.headers:
                try:
                    rate_limit_reset = int(e.headers['X-RateLimit-Reset'])
                    logger.debug(f"Rate limit reset: {rate_limit_reset}")
                    rate_expiration = datetime.fromtimestamp(rate_limit_reset)
                except Exception as e:
                    logger.debug(
                        "Could not parse expiration from timestamp", e)
            raise UpdateError(f"Github rate limit exceeded.  Try again after: {rate_expiration}")
        else:
            raise e
    releases_string = response.read().decode('utf-8')
    logger.debug(releases_string)
    logger.debug(response.headers)
    releases = json.loads(releases_string)
    link = response.headers.get('link', None)
    current_release = None
    for release in releases:
        if band == "release" and release['prerelease']:
            continue
        tag_name = parse_release(release['tag_name'], band)
        if tag_name:
            current_release = tag_name
            break

    # For 'prerelease', if we did not find a matching tag, look for 'beta' too
    # This makes it possible for something like 552_beta repo to work
    if band == "prerelease" and current_release == None:
        for release in releases:
            tag_name = parse_release(release['tag_name'], "beta")
            if tag_name:
                current_release = tag_name
                break
        for release in releases:
            tag_name = parse_release(release['tag_name'], "dev")
            if tag_name:
                current_release = tag_name
                break

    if current_release == None and link:
        page=page+1
        current_release = get_current_release(org, repo, band, page)
    return current_release

# Returns the release_tag if it can parse, otherwise None
# Example valid releases:
# band = release: 20210603, 20210603-1   
# band = prerelease: prerelease-20210603_1010, 20210603, 20210603-1 20210603_1010

def parse_release(release_tag,band):
    try:
        #Temporarily strip off the `-1` modifiers used for hotfix for date parsing.
        #  Ex: 20210603-1 -> 20210603 when ensure the date is valid
        temp_release = re.sub("-[0-9]*$", "", release_tag)
        
        # Just parse as a date so we can check if release format is correct
        time.strptime(temp_release, '%Y%m%d')
        return release_tag
    except Exception as e:
        try:
            temp_release = re.sub(f"{band}-", "", release_tag)
            logger.debug(f"temp_release : {temp_release}")
            time.strptime(temp_release, '%Y%m%d_%H%M')

            return release_tag
        except Exception as ex:
            logger.debug(f"Could not parse release: {release_tag} as '{band}'")
            logger.debug(ex)
        logger.info(f"Could not parse release: {release_tag}.  Ignoring...")
        logger.debug("Parsing exception", e)
    return None

if __name__ == "__main__":
    main()
