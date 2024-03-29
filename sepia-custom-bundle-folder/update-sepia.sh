#!/bin/bash
set -e
#
# make sure we are in the right folder
SCRIPT_PATH="$(realpath "$BASH_SOURCE")"
SEPIA_FOLDER="$(dirname "$SCRIPT_PATH")"
cd "$SEPIA_FOLDER"
#
ORG_FOLDER=$(pwd)
NOW=$(date +"%Y_%m_%d_%H%M%S")
OLD_FOLDER=SEPIA_old_$NOW
UP_FILE=""
HAS_EXT_DATA="false"
get_latest_release() {
	curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
		grep '"tag_name":' |                                          # Get tag line
		sed -E 's/.*"([^"]+)".*/\1/'                                  # Get JSON value
}
if [ -n "$1" ]; then
	UP_FILE=$(realpath $1)
	echo "Welcome!"
	echo "You've selected a custom file to update SEPIA: $UP_FILE"
	if [ -f "$UP_FILE" ]; then
		echo "NOTE: Please make sure the file is OUTSIDE of $ORG_FOLDER!"
	else
		echo "File does NOT exist! END."
		exit 1
	fi
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
if [ -L "${SEPIA_FOLDER}/es-data" ] && [ -L "${SEPIA_FOLDER}/sepia-assist-server/Xtensions/assist.custom.properties" ]; then
	echo "It looks like you are using the external data folder for SEPIA."
	echo "The script will skip the backup part and try to restore your symlinks after the update process is done."
	echo ""
	HAS_EXT_DATA="true"
elif [ -n "$ISDOCKER" ]; then
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
# make sure SEPIA server is OFF
bash shutdown-sepia.sh
if [ $HAS_EXT_DATA = "false" ]; then
	# backup
	echo "Starting backup ..."
	bash backup-sepia.sh
	echo "BACKUP finished. Next step: UPDATE."
	echo ""
	read -p "Press any key to continue (CTRL+C to exit)" anykey
else
	echo "BACKUP skipped. Next step: UPDATE."
fi
echo ""
cd ..
# move or clear folder
if [ -n "$ISDOCKER" ]; then
	echo "NOTE: Due to the Docker environment the old SEPIA folder will be cleared not moved!"
	rm -rf "$ORG_FOLDER"/*
else
	mv "$ORG_FOLDER" "$OLD_FOLDER"
	# to prevent runing the wrong version after update we put everything in a sub-folder
	mkdir -p "$OLD_FOLDER/backup"
	find "$OLD_FOLDER"/* -maxdepth 0 -not -name backup -exec mv '{}' "$OLD_FOLDER/backup/" \;
fi
mkdir -p "$ORG_FOLDER"/update
cd "$ORG_FOLDER"/update
# get and unzip update
if [ -n "$UP_FILE" ]; then
	echo "Using local file at: $UP_FILE"
	cp "$UP_FILE" "$ORG_FOLDER/update/SEPIA-Home.zip"
else
	wget https://github.com/SEPIA-Framework/sepia-installation-and-setup/releases/latest/download/SEPIA-Home.zip
fi
unzip SEPIA-Home.zip -d "$ORG_FOLDER"
if [ $HAS_EXT_DATA = "false" ]; then
	# restore last backup
	echo ""
	cd $HOME
	LAST_BACKUP=$(ls -Art SEPIA-Backup_* | tail -n 1)
	echo "Restoring backup: $LAST_BACKUP"
	unzip -o $LAST_BACKUP -d "$ORG_FOLDER"
fi
cd "$ORG_FOLDER"
# make scripts executable again
find . -name "*.sh" -exec chmod +x {} \;
chmod +x elasticsearch/bin/elasticsearch
echo ""
if [ $HAS_EXT_DATA = "true" ]; then
	# restore external data
	echo "Restoring symlinks to external data folder ..."
	bash scripts/create-external-data-folder.sh -y
	echo ""
fi
echo "DONE."
echo "If everything looks good you can delete the folder '$ORG_FOLDER/update', it just contains the new installation files."
echo ""
echo "PLEASE leave this folder now (cd ..) to refresh the view before you continue !!"
echo ""
