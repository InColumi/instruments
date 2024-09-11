#!/bin/bash
set -e

source /home/user/Desktop/Projects/instruments/python/export_method_from_database/venv/bin/activate
echo 'venv activated'
nice -5 python3 /home/user/Desktop/Projects/instruments/python/export_method_from_database/main.py

code '/home/user/Desktop/Projects/scripts_medaccount'
code '/home/user/Desktop/Projects/Scripts'
