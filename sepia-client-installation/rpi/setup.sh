#!/bin/bash
set -e

# check commandline arguments
option=""
breakafterfirst="false"
if [ -n "$1" ]; then
    option=$1
	breakafterfirst="true"
fi

# env
client_settings="$HOME/clexi/www/sepia/settings.js"
clexi_settings="$HOME/clexi/settings.json"
client_run_script="$HOME/sepia-client/run.sh"
	
# stat menu loop
while true; do
	headless_mode=$(cat "$client_run_script" | grep is_headless= | grep -o .$)
	echo "Current mode: $headless_mode (0: display, 1: headless, 2: pseudo-headless)"
	echo ""
	echo "What would you like to do?"
	echo "1: Change CLEXI ID (in CLEXI config and SEPIA Client settings.js)"
	echo "2: Set SEPIA Client mode to 'headless'"
	echo "3: Set SEPIA Client mode to 'pseudo-headless' (headless settings + display)"
	echo "4: Set SEPIA Client mode to 'display'"
	echo "5: Enter hostname of your SEPIA Server"
	echo "6: Set SEPIA Client device ID"
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
		sed -i "s/\"clexiServerId\": \".*\"/\"clexiServerId\": \"$new_id\"/" $client_settings
		sed -i "s/\"id\": \".*\"/\"id\": \"$new_id\"/" $clexi_settings
		echo "------------------------"
		echo "DONE."
		echo "------------------------"
	elif [ $option = "2" ]
	then
		echo "Setting SEPIA Client mode to 'headless'"
		sed -i 's/is_headless=./is_headless=1/' $client_run_script
		echo "------------------------"
		echo "DONE."
		echo "------------------------"
	elif [ $option = "3" ]
	then
		echo "Setting SEPIA Client mode to 'pseudo-headless'"
		sed -i 's/is_headless=./is_headless=2/' $client_run_script
		echo "------------------------"
		echo "DONE."
		echo "------------------------"
	elif [ $option = "4" ]
	then
		echo "Setting SEPIA Client mode to 'display'"
		sed -i 's/is_headless=./is_headless=0/' $client_run_script
		echo "------------------------"
		echo "DONE."
		echo "------------------------"
	elif [ $option = "5" ]
	then
		read -p "Enter new SEPIA Server host address (e.g.: localhost or IP): " new_host
		sed -i "s+\"host-name\": \".*\"+\"host-name\": \"$new_host\"+" $client_settings
		echo "------------------------"
		echo "DONE."
		echo "------------------------"
	elif [ $option = "6" ]
	then
		read -p "Enter new SEPIA Client device ID (e.g. o1): " new_device_id
		sed -i "s/\"deviceId\": \".*\"/\"deviceId\": \"$new_device_id\"/" $client_settings
		echo "------------------------"
		echo "DONE."
		echo "------------------------"
	else
		echo "------------------------"
		echo "Not an option, please try again."
		echo "------------------------"
	fi
	option=""
	if [ $breakafterfirst = "true" ]
	then
		break
	fi
done
echo "Cu :-) ... ah and don't forget to restart your client ;-)"
echo ""
