#!/bin/bash
set -e
clear
echo "Welcome to the SEPIA Framework Client Installer :-)"
echo ""
echo "This little menu will try to guide you through the SEPIA Client installation for Raspberry Pi."
echo "NOTE: It is inteded to be used with a fresh and clean Raspberry Pi OS Lite and might fail if you've already installed other components."
echo ""
echo "More info: https://github.com/SEPIA-Framework/sepia-installation-and-setup/"
# Use master or dev?
BRANCH="master"
if [ -n "$1" ] && [ "$1" = "dev" ]; then
	BRANCH="dev"
fi
while true; do
	echo ""
	echo "What would you like to do?"
	echo "1: Install hardware: WM8960 microphone HAT like ReSpeaker, Waveshare etc."
	echo "2: Install hardware: Hyperpixel touchscreen"
	echo "3: Run SEPIA Client installation"
	echo "4: Run SEPIA Client installation but skip CLEXI Bluetooth module"
	echo "0: Exit and continue manually"
	echo ""
	read -p "Enter a number plz: " option
	echo ""
	if [ -z "$option" ] || [ $option = "0" ]
	then
		break
	elif [ $option = "1" ]
	then
		clear
		echo "Command: bash install_respeaker_mic.sh"
		echo ""
		echo "This script will try to install a WM8960 compatible mic HAT."
		echo "Please see the SEPIA installation info page for more info:"
		echo "https://github.com/SEPIA-Framework/sepia-installation-and-setup/"
		echo ""
		read -p "Press any key to continue (or CTRL+C to abort)."
		bash install_respeaker_mic.sh
		break
	elif [ $option = "2" ] 
	then
		clear
		echo "Command: curl https://get.pimoroni.com/hyperpixel4 | bash"
		echo ""
		echo "This command will try to install a Hyperpixel touchscreen for RPi."
		echo "Please see the SEPIA installation info page for more info:"
		echo "https://github.com/SEPIA-Framework/sepia-installation-and-setup/"
		echo ""
		read -p "Press any key to continue (or CTRL+C to abort)."
		curl https://get.pimoroni.com/hyperpixel4 | bash
		break
	elif [ $option = "3" ] 
	then
		clear
		echo "Command: bash install_sepia_client.sh $BRANCH"
		echo ""
		echo "This script will run the SEPIA Client installation."
		echo "Please see the SEPIA installation info page for more info:"
		echo "https://github.com/SEPIA-Framework/sepia-installation-and-setup/"
		echo ""
		read -p "Press any key to continue (or CTRL+C to abort)."
		bash install_sepia_client.sh $BRANCH
		break
	elif [ $option = "4" ] 
	then
		clear
		echo "Command: bash install_sepia_client.sh $BRANCH skipBLE"
		echo ""
		echo "This script will run the SEPIA Client installation with 'skipBLE' flag."
		echo "Please see the SEPIA installation info page for more info:"
		echo "https://github.com/SEPIA-Framework/sepia-installation-and-setup/"
		echo ""
		read -p "Press any key to continue (or CTRL+C to abort)."
		bash install_sepia_client.sh $BRANCH skipBLE
		break
	else
		clear
		echo "Not an option, please try again."
	fi
	option=""
done