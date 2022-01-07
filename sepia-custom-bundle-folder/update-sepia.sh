#!/bin/bash
set -e
ORG_FOLDER=$(pwd)
NOW=$(date +"%Y_%m_%d_%H%M%S")
OLD_FOLDER=SEPIA_old_$NOW
get_latest_release() {
	curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
		grep '"tag_name":' |                                          # Get tag line
		sed -E 's/.*"([^"]+)".*/\1/'                                  # Get JSON value
}
if [ -n "$1" ]; then
	echo "Welcome!"
	echo "You've selected a custom file to update SEPIA: $1"
	echo "NOTE: use ONLY absolute paths please and put the file OUTSIDE of '~/SEPIA'!"
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
echo ""
read -p "Press any key to continue with update (CTRL+C to exit)" anykey
echo ""
cd ..
if [ -n "$ISDOCKER" ]; then
	echo "NOTE: Due to the Docker environment the old SEPIA folder will be cleared not moved!"
	rm -rf $ORG_FOLDER/*
else
	mv $ORG_FOLDER $OLD_FOLDER
fi
mkdir -p $ORG_FOLDER/update
cd $ORG_FOLDER/update
if [ -n "$1" ]; then
	echo "Using local file at: $1"
	cp "$1" "$ORG_FOLDER/update/SEPIA-Home.zip"
else
	wget https://github.com/SEPIA-Framework/sepia-installation-and-setup/releases/latest/download/SEPIA-Home.zip
fi
unzip SEPIA-Home.zip -d $ORG_FOLDER
cd ~
LAST_BACKUP=$(ls -Art SEPIA-Backup_* | tail -n 1)
unzip $LAST_BACKUP -d $ORG_FOLDER
cd $ORG_FOLDER
# make scripts executable again
find . -name "*.sh" -exec chmod +x {} \;
chmod +x elasticsearch/bin/elasticsearch
echo ""
echo "DONE."
echo "If everything looks good you can delete the folder '$ORG_FOLDER/update', it just contains the new installation files."
echo "PLEASE leave this folder now (cd ..) and reopen it to refresh the view before you continue !!"
