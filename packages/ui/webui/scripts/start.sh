#! /bin/sh
#dir is the directory where this script lives
dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

pushd $dir

# This is a hack - but there's really no way in python register additional packages without a
# virtualenv or putting them in site-packages for all users 
PYTHONPATH=$(for egg in eggs/*.egg; do echo -n "./$egg:"; done)

# LD_LIBRARY_PATH is required to find lib_pam.so
LD_LIBRARY_PATH=/usr/lib PYTHONPATH=$PYTHONPATH python3 ./server.py