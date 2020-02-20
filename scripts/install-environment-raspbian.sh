#!/bin/sh
set -e
get_latest_release() {
	curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
		grep '"tag_name":' |                                          # Get tag line
		sed -E 's/.*"([^"]+)".*/\1/'                                  # Pluck JSON value
}
echo "Welcome! Checking version number of latest SEPIA release, just a second ..."
SEPIA_VERSION=$(get_latest_release "SEPIA-Framework/sepia-installation-and-setup")
echo "Latest SEPIA-Home version is: $SEPIA_VERSION"
echo ""
echo "Welcome to the SEPIA-Framework!"
echo ""
echo "This little script will help you to setup your environment and download SEPIA-Home (the server stack of SEPIA)."
echo "If you are using a fresh Raspbian installation please follow steps 1 to 4 and make sure they complete successfully."
echo "If you know what you are doing feel free to skip some steps as needed ;-)"
echo "More help can be found here: https://github.com/SEPIA-Framework/sepia-docs/wiki"
echo ""
echo "Tested with: Raspian Buster (30-01-2020)"
while true; do
	echo ""
	echo "Please choose next step:"
	echo "1: Install Java OpenJDK 11 globally (alternative: download SEPIA-Home first and use local Java installation)"
	echo "2: Install required packages and update server-clock for precise timers"
	echo "3: Download SEPIA-Home bundle version: $SEPIA_VERSION"
	echo "4: Extract SEPIA-Home to '~/SEPIA' (currently required home folder for SEPIA)"
	echo "5: Optional: Install NGINX reverse-proxy (recommended alternative to SEPIA Reverse-Proxy)"
	echo "6: Optional: Download and deploy NGINX proxy config for SEPIA"
	echo ""
	read -p "Enter a number plz (0 to exit): " option
	echo ""
	if [ $option = "0" ]
	then
		break
	elif [ $option = "1" ]
	then
		# INSTALL JAVA OPENJDK 11
		sudo apt-get update
		sudo apt-get install -y openjdk-11-jdk-headless ca-certificates-java
		echo "------------------------"
		echo "DONE."
		java -version
		echo "------------------------"
	
	elif [ $option = "2" ] 
	then
		# INSTALL zip, unzip, curl, procps, etc.
		sudo apt-get install -y zip unzip curl procps ca-certificates espeak-ng espeak-ng-espeak
		
		# UPDATE TIME SYNC
		echo 'Installing ntpdate to sync time ...'
		sudo apt-get install -y ntpdate
		sudo ntpdate -u ntp.ubuntu.com
		echo "------------------------"
		echo "DONE."
		echo "------------------------"

	elif [ $option = "3" ] 
	then
		# DOWNLOAD SEPIA Custom-Bundle

		#create tmp folder (usually done before getting this file)
		mkdir -p ~/SEPIA/tmp
		cd ~/SEPIA/tmp
		#curl --silent "https://api.github.com/repos/SEPIA-Framework/sepia-installation-and-setup/releases/latest" | jq -r '.assets[] | select(.name == "SEPIA-Home.zip").browser_download_url'
		#wget "https://github.com/SEPIA-Framework/sepia-installation-and-setup/releases/download/${SEPIA_VERSION}/SEPIA-Home.zip"
		wget "https://github.com/SEPIA-Framework/sepia-installation-and-setup/releases/latest/download/SEPIA-Home.zip"
		echo "------------------------"
		echo "DONE."
		echo "------------------------"

	elif [ $option = "4" ] 
	then
		# EXTRACT SEPIA-Home bundle
		
		cd ~/SEPIA/tmp
		unzip SEPIA-Home.zip -d ~/SEPIA
		
		# SET SCRIPT ACCESS AND DONE
		
		#set scripts access
		cd ~/SEPIA
		find . -name "*.sh" -exec chmod +x {} \;
		chmod +x elasticsearch/bin/elasticsearch
		
		#done
		echo ""
		echo "------------------------"
		echo "DONE :-) If you saw no errors you can exit now and continue with 'cd ~/SEPIA' and 'bash setup.sh'".
		echo "------------------------"

	elif [ $option = "5" ] 
	then
		# INSTALL NGINX

		echo 'Installing nginx reverse-proxy ...'
		sudo apt-get install software-properties-common
		sudo apt-get install nginx
		echo "------------------------"
		echo "DONE."
		echo "------------------------"

	elif [ $option = "6" ] 
	then
		# INSTALL NGINX HTTP CONFIG FOR SEPIA

		#echo 'Downloading nginx reverse-proxy HTTP config for SEPIA ...'
		echo "------------------------"
		echo "UNDER CONSTRUCTION - For now please run 'bash setup-nginx.sh' inside your SEPIA-Home folder"
		echo "------------------------"

	else
		echo "------------------------"
		echo "Not an option, please try again."
		echo "------------------------"
	fi
done
