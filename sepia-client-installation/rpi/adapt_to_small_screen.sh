#!/bin/bash
SHIFT=20
SEPIA_CLIENT_ROOT="$HOME/clexi/www/sepia"
if [ -n "$1" ]; then
    SHIFT=$1
fi
if [ -n "$2" ]; then
    SEPIA_CLIENT_ROOT=$2
fi
echo "This script will try to compensate the 500px minimum-size \"bug\" of Chromium browsers by shifting the HTML element inside the client index.html."
echo "Shift: $SHIFT pixel - File: $SEPIA_CLIENT_ROOT"
echo "NOTE: You can call this script with a custom number as parameter 1 to set a custom shift (e.g 500-320=180). ALL old 'style' entries will be removed!"
echo ""
echo "ALTERNATIVE: Try the \"launcher\" mode of the client (currently requires manual run.sh edit)."
echo ""
echo "Are you sure that you want to continue?"
read -p "Enter 'yes' to continue: " yesno
echo ""
if [ -n "$yesno" ] && [ $yesno = "yes" ]; then
	echo "Ok. Let's go ;-)"	
else
	echo "Ok, cu later :-)"
	exit
fi
echo "Shifting screen by $SHIFT pixel to the left."
sed -ri "s/<html (.*?) style=.*?>/<html \1>/" "${SEPIA_CLIENT_ROOT}/index.html"
sed -ri "s/<html (.*?)>/<html \1 style=\"margin-right: ${SHIFT}px; width: calc(100% - ${SHIFT}px);\">/" "${SEPIA_CLIENT_ROOT}/index.html"
echo "DONE"
