#!/bin/bash
set -e
ORG_FOLDER=$(pwd)
if [ -n "$1" ]; then
	echo "Welcome!"
	echo "You've selected this backup ZIP file to import: $1"
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
unzip $1 -d $ORG_FOLDER
echo ""
echo "DONE."
echo "PLEASE leave this folder now (cd ..) and reopen it to refresh the view before you continue !!"
