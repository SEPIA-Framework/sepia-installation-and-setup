#!/bin/bash
set -e
SCRIPT_PATH="$(realpath "$BASH_SOURCE")"
ORG_FOLDER="$(dirname "$SCRIPT_PATH")"
BCK_FILE=""
cd "$ORG_FOLDER"
if [ -L "${ORG_FOLDER}/es-data" ] && [ -L "${ORG_FOLDER}/sepia-assist-server/Xtensions/assist.custom.properties" ]; then
	echo "It looks like you are using the external data folder for SEPIA."
	echo "Please use 'bash scripts/create-external-data-folder.sh' to restore external data."
	exit 1
fi
if [ -n "$1" ]; then
	BCK_FILE=$(realpath $1)
	echo "Welcome!"
	echo "You've selected this backup ZIP file to import: $BCK_FILE"
	echo "NOTE: This will overwrite your current setup. Make a backup first if you are not sure!"
else
	echo "Please add the absolute path to the backup file you want to import as first parameter."
	exit
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
unzip -o $BCK_FILE -d "$ORG_FOLDER"
echo ""
echo "DONE."
