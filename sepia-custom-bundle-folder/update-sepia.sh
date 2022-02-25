#!/bin/bash
set -e
#
# make sure we are in the right folder
SCRIPT_PATH="$(realpath "$BASH_SOURCE")"
SEPIA_PATH="$(dirname "$SCRIPT_PATH")"
cd "$SEPIA_PATH"
#
ORG_FOLDER=$(pwd)
NOW=$(date +"%Y_%m_%d_%H%M%S")
OLD_FOLDER=SEPIA_old_$NOW
BCK_FILE=""
get_latest_release() {
	curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
		grep '"tag_name":' |                                          # Get tag line
		sed -E 's/.*"([^"]+)".*/\1/'                                  # Get JSON value
}
if [ -n "$1" ]; then
	BCK_FILE=$(realpath $1)
	echo "Welcome!"
	echo "You've selected a custom file to update SEPIA: $BCK_FILE"
	echo "NOTE: put the file OUTSIDE of $ORG_FOLDER!"
	echo ""
else
	echo "Welcome! Checking version number of latest SEPIA release, just a second ..."
	SEPIA_VERSION=$(get_latest_release "SEPIA-Framework/sepia-installation-and-setup")
	echo "Latest SEPIA-Home version is: $SEPIA_VERSION"
	echo ""
	echo "This script will try to update your default SEPIA-Home installation. NOTE: your own custom modifications might not be fully supported."
	echo "What it does is it..."
	echo "1) uses the 'backup-sepia.sh' script to backup your current installation"
	echo "2) moves your old installation to '../$OLD_FOLDER'"
	echo "3) downloads the newest SEPIA-Home release from GitHub and extracts it to this folder"
	echo "4) restores the latest backup"
	echo ""
	echo "NOTE: Step 4 will restore your old property files (your SEPIA server settings) removing any newly added property entries. This is usually ok since they have default values, but a proper file merge would be better!"
	echo ""
	echo "If you experience any problems during the update process please try the most recent version of the updater:"
	echo "cd .. && wget https://sepia-framework.github.io/install/sepia-home-rpi-update.sh && bash sepia-home-rpi-update.sh"
	echo ""
fi
if [ -n "$ISDOCKER" ]; then
	echo "NOTE: Due to the Docker environment the backup cannot be stored properly! Be sure to make a copy of your SEPIA folder BEFORE you continue."
	echo ""
fi
echo "The server will be shut down now for the update process. If you have any health checks or auto-start services runnig please disable them in advance!"
echo "Do you want to continue?"
echo ""
read -p "Enter 'yes' to continue: " yesno
echo ""
if [ -n "$yesno" ] && [ $yesno = "yes" ]; then
	echo "Ok. Good luck ;-)"
else
	echo "Ok. Maybe later :-)"
	exit
fi
echo ""
bash shutdown-sepia.sh
echo "Starting backup ..."
bash backup-sepia.sh
echo "BACKUP finished. Next step: UPDATE."
echo ""
read -p "Press any key to continue (CTRL+C to exit)" anykey
echo ""
cd ..
if [ -n "$ISDOCKER" ]; then
	echo "NOTE: Due to the Docker environment the old SEPIA folder will be cleared not moved!"
	rm -rf $ORG_FOLDER/*
else
	mv $ORG_FOLDER $OLD_FOLDER
	# to prevent runing the wrong version after update we put everything in a sub-folder
	mkdir -p "$OLD_FOLDER/backup"
	find "$OLD_FOLDER"/* -maxdepth 0 -not -name backup -exec mv '{}' "$OLD_FOLDER/backup/" \;
fi
mkdir -p $ORG_FOLDER/update
cd $ORG_FOLDER/update
if [ -n "$1" ]; then
	echo "Using local file at: $BCK_FILE"
	cp "$BCK_FILE" "$ORG_FOLDER/update/SEPIA-Home.zip"
else
	wget https://github.com/SEPIA-Framework/sepia-installation-and-setup/releases/latest/download/SEPIA-Home.zip
fi
unzip SEPIA-Home.zip -d $ORG_FOLDER
cd ~
LAST_BACKUP=$(ls -Art SEPIA-Backup_* | tail -n 1)
unzip -o $LAST_BACKUP -d $ORG_FOLDER
cd $ORG_FOLDER
# make scripts executable again
find . -name "*.sh" -exec chmod +x {} \;
chmod +x elasticsearch/bin/elasticsearch
echo ""
echo "DONE."
echo "If everything looks good you can delete the folder '$ORG_FOLDER/update', it just contains the new installation files."
echo ""
echo "PLEASE leave this folder now (cd ..) to refresh the view before you continue !!"
echo ""
