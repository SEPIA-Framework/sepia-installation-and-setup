#!/bin/bash
SCRIPT_PATH="$(realpath "$BASH_SOURCE")"
SEPIA_FOLDER="$(dirname "$SCRIPT_PATH")"
cd "$SEPIA_FOLDER"
NOW=$(date +"%Y_%m_%d_%H%M%S")
echo "$NOW - Restarting SEPIA Home" >> restart.log
bash restart-sepia.sh
