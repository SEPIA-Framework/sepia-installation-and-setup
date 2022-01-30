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
	echo "1b: Install hardware: IQ Audio Zero HAT"
	echo "2: Install hardware: Hyperpixel touchscreen"
	echo "2b: Install hardware: Waveshare HDMI touchscreen"
	echo "2c: Install hardware: Official 7inch RPi LCD"
	echo "3: Run SEPIA Client installation"
	echo "4: Run SEPIA Client installation but skip CLEXI Bluetooth module"
	echo "5: Install SEPIA STT-Server locally"
	echo "6: Import self-signed SSL certificates (e.g. from SEPIA-Home server)"
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
		clear
		bash install_respeaker_mic.sh
		break
	elif [ $option = "1b" ]
	then
		clear
		echo "Command: bash install_iqaudio_zero_hat.sh"
		echo ""
		echo "This script will try to install the IQAudio Zero mic HAT."
		echo ""
		read -p "Press any key to continue (or CTRL+C to abort)."
		clear
		bash install_iqaudio_zero_hat.sh
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
		clear
		curl https://get.pimoroni.com/hyperpixel4 | bash
		break
	elif [ $option = "2b" ] 
	then
		clear
		echo "Command: bash install_hdmi_LCD_waveshare_h.sh"
		echo ""
		echo "This command will try to install the Waveshare HDMI LCD model H."
		echo ""
		read -p "Press any key to continue (or CTRL+C to abort)."
		clear
		sudo bash install_hdmi_LCD_waveshare_h.sh
		break
	elif [ $option = "2c" ] 
	then
		clear
		echo "Command: bash install_rpi_7_inch_LCD.sh"
		echo ""
		echo "This command will show some manual steps to set up the official Raspberry Pi 7inch LCD touchscreen."
		echo ""
		read -p "Press any key to continue (or CTRL+C to abort)."
		clear
		bash install_rpi_7_inch_LCD.sh
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
		clear
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
		clear
		bash install_sepia_client.sh $BRANCH skipBLE
		break
	elif [ $option = "5" ] 
	then
		clear
		echo "This script will create the folder '~/sepia-stt' and try to install the STT server."
		echo "Please make sure that the folder does not already exist before you continue!"
		echo ""
		echo "If the installation fails check the Docker version inside the folder 'sepia-stt-docker'."
		echo ""
		read -p "Press any key to continue (or CTRL+C to abort)."
		clear
		cp -r sepia-stt ~/
		cd ~/sepia-stt
		bash install.sh
		break
	elif [ $option = "6" ] 
	then
		clear
		echo "If your SEPIA-Home server uses self-signed SSL certificates you can use the SSL script to import them:"
		echo ""
		bash import_self_signed_SSL_cert.sh
		echo ""
		break
	else
		clear
		echo "Not an option, please try again."
	fi
	option=""
done