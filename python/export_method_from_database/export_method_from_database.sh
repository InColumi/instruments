#!/bin/bash
set -e

WDIR=/home/user/Desktop/Projects/instruments/python/export_method_from_database
DIR_FOR_SAVE=/home/user/Desktop/Projects

source $WDIR/venv/bin/activate
echo 'venv Activated'

ionice -c 3 python3 $WDIR/main.py

ionice -c 3 code $DIR_FOR_SAVE/scripts_medaccount
ionice -c 3 code $DIR_FOR_SAVE/Scripts
