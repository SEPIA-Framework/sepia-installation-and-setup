#!/bin/bash
set -e
# TODO: Option1: change CLEXI ID (in CLEXI config and client settings.js)
# TODO: Option2: switch between headless and display
# check commandline arguments
option=""
breakafterfirst="false"
if [ -n "$1" ]; then
    option=$1
	breakafterfirst="true"
fi
# stat menu loop
while true; do
	echo ""
	echo "What would you like to do?"
	echo "1: Change CLEXI ID (in CLEXI config and SEPIA Client settings.js)"
	echo "2: Set SEPIA Client mode to 'headless'"
	echo "3: Set SEPIA Client mode to 'display'"
	echo ""
	if [ -z "$option" ]; then
		read -p "Enter a number plz (0 to exit): " option
	else
		echo "Selected by cmd argument: $option"
    fi
	echo ""
	if [ -z "$option" ] || [ $option = "0" ]
	then
		break
	elif [ $option = "1" ]
	then
		read -p "Enter new CLEXI ID: " new_id
		sed -i "s/\"clexiServerId\": \".*\"/\"clexiServerId\": \"$new_id\"/" ~/clexi/www/sepia/settings.js
		sed -i "s/\"id\": \".*\"/\"id\": \"$new_id\"/" ~/clexi/settings.json
		echo "DONE"
	elif [ $option = "2" ] 
	then
		echo "Setting SEPIA Client mode to 'headless'"
		sed -i 's/is_headless=0/is_headless=1/' ~/.config/openbox/autostart
		echo "DONE"
	elif [ $option = "3" ] 
	then
		echo "Setting SEPIA Client mode to 'display'"
		sed -i 's/is_headless=1/is_headless=0/' ~/.config/openbox/autostart
		echo "DONE"
	else
		echo "Not an option, please try again."
	fi
	option=""
	if [ $breakafterfirst = "true" ]
	then
		break
	fi
done