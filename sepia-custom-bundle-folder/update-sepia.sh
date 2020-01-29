#!/bin/bash
set -e
ORG_FOLDER=$(pwd)
NOW=$(date +"%Y_%m_%d_%H%M%S")
OLD_FOLDER=SEPIA_old_$NOW
echo "-- BETA VERSION, USE AT OWN RISK ^^ --"
echo "This script will try to update your default(!) SEPIA-Home installation."
echo "What it does is it:"
echo "1) uses the 'backup-sepia.sh' script to backup your current installation"
echo "2) moves your old installation to '../$OLD_FOLDER'"
echo "3) downloads the newest SEPIA-Home release from GitHub and extracts it to this folder"
echo "4) restores the latest backup"
echo "NOTE: Step 4 will restore your old property files (your SEPIA server settings) removing any newly added property entries. This is usually ok since they have default values, but a proper file merge would be better!"
echo "Do you want to continue?"
read -p "Enter 'yes' to continue: " yesno
echo ""
if [ -n "$yesno" ] && [ $yesno = "yes" ]; then
	echo "Ok. Good luck ;-)"
else
	echo "Ok. Maybe later :-)"
	exit
fi
echo ""
bash backup-sepia.sh
echo ""
cd ..
mv $ORG_FOLDER $OLD_FOLDER
mkdir -p $ORG_FOLDER/update
cd $OLD_FOLDER/update
wget https://github.com/SEPIA-Framework/sepia-installation-and-setup/releases/latest/download/SEPIA-Home.zip
unzip SEPIA-Home.zip -d $OLD_FOLDER
cd ~
LAST_BACKUP=$(ls -Art SEPIA-Backup_* | tail -n 1)
unzip $LAST_BACKUP -d $OLD_FOLDER
echo ""
echo "DONE"