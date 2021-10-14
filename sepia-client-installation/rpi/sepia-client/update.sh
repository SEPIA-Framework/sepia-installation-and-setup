#!/bin/bash
set -e
SCRIPT_PATH="$(realpath "$BASH_SOURCE")"
LOG="$(dirname "$SCRIPT_PATH")""/log-update.out"
NOW=$(date +"%Y_%m_%d_%H:%M:%S")
BCK_NOW=$(date +"%Y_%m_%d_%H%M%S")
# Use master or dev?
CLIENT_BRANCH="master"
if [ -n "$1" ] && [ "$1" = "dev" ]; then
	CLIENT_BRANCH="dev"
fi
echo "$NOW - Updating SEPIA client using branch: $CLIENT_BRANCH" >> "$LOG"
echo "Saving backup of settings at ~/clexi/www/sepia/settings_$BCK_NOW.js"
echo "$NOW - Saving backup of settings at ~/clexi/www/sepia/settings_$BCK_NOW.js" >> "$LOG"
cp ~/clexi/www/sepia/settings.js ~/clexi/www/sepia/settings_$BCK_NOW.js
echo "Updating SEPIA Client from current '$CLIENT_BRANCH' branch ..."
echo "$NOW - Downloading client files from Git to ~/tmp/sepia-client-git" >> "$LOG"
mkdir -p ~/clexi/www/sepia
mkdir -p ~/tmp
rm -rf ~/tmp/sepia-client-git
git clone --single-branch -b $CLIENT_BRANCH https://github.com/SEPIA-Framework/sepia-html-client-app.git ~/tmp/sepia-client-git
echo "$NOW - Replacing current files ..." >> "$LOG"
cp -rf ~/tmp/sepia-client-git/www/* ~/clexi/www/sepia/
echo "$NOW - Cleaning up ..." >> "$LOG"
rm -rf ~/tmp/sepia-client-git
echo "Client files have been updated. Note: settings have to be restored manually atm."
echo "DONE"
echo "$NOW - DONE - Note: settings have to be restored manually atm." >> "$LOG"