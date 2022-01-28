#!/bin/bash
# make sure we are in the right folder
SCRIPT_PATH="$(realpath "$BASH_SOURCE")"
SEPIA_FOLDER="$(dirname "$SCRIPT_PATH")"
cd "$SEPIA_FOLDER"
#Preliminary restart script, we should replace the sleep with a real check, e.g. via HTTP GET
./shutdown-sepia.sh 
sleep 5
./run-sepia.sh
