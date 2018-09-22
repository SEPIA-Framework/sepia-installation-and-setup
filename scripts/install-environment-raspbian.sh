#!/bin/sh

get_latest_release() {
	curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
		grep '"tag_name":' |                                          # Get tag line
		sed -E 's/.*"([^"]+)".*/\1/'                                  # Pluck JSON value
}

echo ""
echo "Welcome to the SEPIA framework!"
echo ""
echo "This little script will help you to setup your environment and download SEPIA."
echo "If you are using a fresh Raspbian (Stretch) installation please follow all points step-by-step and make sure they complete successfully."
echo "If you know what you are doing feel free to skip some steps as needed ;-)"
echo "More help can be found here: https://github.com/SEPIA-Framework/sepia-docs/wiki"
while true; do
	echo ""
	echo "Please choose your step:"
	echo "1: Install Oracle Java 8"
	echo "2: Update server-clock for precise timers"
	echo "3: Install NGINX reverse-proxy (alternative to SEPIA Reverse-Proxy)"
	echo "4: Download SEPIA Custom-Bundle"
	echo "5: Extract SEPIA Custom-Bundle"
	echo "6: Set access to SEPIA scripts and DONE"
	echo ""
	read -p "Enter a number plz (0 to exit): " option
	echo ""
	if [ $option = "0" ]
	then
		break
	elif [ $option = "1" ]
	then
		# INSTALL JAVA

		#add digital key for PPA
		echo 'Installing Oracle Java 8 ...'
		sudo apt install dirmngr
		sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
		#to skip the license agreement: https://askubuntu.com/questions/190582/installing-java-automatically-with-silent-option

		#add packets
		sudo touch /etc/apt/sources.list.d/webupd8team-java.list
		echo 'deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main' | sudo tee --append /etc/apt/sources.list.d/webupd8team-java.list
		echo 'deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main' | sudo tee --append /etc/apt/sources.list.d/webupd8team-java.list

		#install
		sudo apt-get update
		sudo apt-get install oracle-java8-installer
		sudo apt-get install oracle-java8-set-default
		echo 'Done'
		java -version

	elif [ $option = "2" ] 
	then
		# UPDATE TIME SYNC

		echo 'Installing ntpdate to sync time ...'
		sudo apt-get install ntpdate
		sudo ntpdate -u ntp.ubuntu.com

	elif [ $option = "3" ] 
	then
		# INSTALL CA-CERTIFICATES (usually already there)

		sudo apt-get install ca-certificates

		# INSTALL NGINX

		echo 'Installing nginx reverse-proxy ...'
		sudo apt-get install software-properties-common
		sudo apt-get install nginx

	elif [ $option = "4" ] 
	then
		# DOWNLOAD SEPIA Custom-Bundle

		#create tmp folder (usually done before getting this file)
		#mkdir ~/tmp
		cd ~/tmp
		SEPIA_VERSION=$(get_latest_release "SEPIA-Framework/sepia-installation-and-setup")
		#curl --silent "https://api.github.com/repos/SEPIA-Framework/sepia-installation-and-setup/releases/latest" | jq -r '.assets[] | select(.name == "SEPIA_custom-bundle.zip").browser_download_url'
		wget "https://github.com/SEPIA-Framework/sepia-installation-and-setup/releases/download/${SEPIA_VERSION}/SEPIA_custom-bundle.zip"

	elif [ $option = "5" ] 
	then
		# EXTRACT SEPIA Custom-Bundle
		
		mkdir ~/SEPIA
		cd ~/tmp
		unzip SEPIA_custom-bundle.zip -d ~/SEPIA

	elif [ $option = "6" ] 
	then	
		# SET SCRIPT ACCESS AND DONE
		
		#set scripts access
		cd ~/SEPIA
		find . -name "*sh" -exec chmod +x {} \;
		chmod +x elasticsearch/bin/elasticsearch
		
		#done
		echo "DONE :-) If you saw no errors you can now continue with 'cd ~/SEPIA' and run the './setup.sh'".
		break
		
	else
		echo "Not an option, please try again."
	fi
done

# DOWNLOAD ELASTICSEARCH (included in SEPIA custom-bundle)

#mkdir ~/SEPIA/tmp
#cd ~/SEPIA/tmp
#wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.3.3.zip
#unzip ....