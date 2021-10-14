#!/bin/bash
set -e
echo "This script has been tested with: Raspbian Stretch/Buster (slim, RPi3), Debian 10 (slim)"
echo ""

#check packages (except Java)
echo "Checking packages ..."
sudo apt-get update
sudo apt-get install -y wget maven zip unzip git curl procps
echo "Checking Java ..."
java -version

#backup if folder exists
if [ -d "$HOME/SEPIA" ]; then
	NOW=$(date +"%Y_%m_%d_%H%M%S")
	mv ~/SEPIA ~/SEPIA_backup_$NOW
	echo "Made a backup of previous SEPIA folder at: $HOME/SEPIA_backup_$NOW" 
fi

#make new SEPIA and tmp folder and download files
mkdir -p ~/SEPIA/tmp
cd ~/SEPIA/tmp

if [ -z "$1" ]; then
	echo "Fetching master bundle folder zip..."
	wget -O sepia-custom-bundle-folder.zip https://github.com/SEPIA-Framework/sepia-installation-and-setup/blob/master/sepia-custom-bundle-folder.zip?raw=true
	unzip -n sepia-custom-bundle-folder.zip -d ~/SEPIA
	echo "Cloning master branches..."
	git clone https://github.com/SEPIA-Framework/sepia-core-tools-java.git
	git clone https://github.com/SEPIA-Framework/sepia-websocket-server-java.git
	git clone https://github.com/SEPIA-Framework/sepia-assist-server.git
	git clone https://github.com/SEPIA-Framework/sepia-teach-server.git
	#git clone https://github.com/SEPIA-Framework/sepia-reverse-proxy.git
	git clone https://github.com/SEPIA-Framework/sepia-mesh-nodes.git
	git clone https://github.com/SEPIA-Framework/sepia-html-client-app.git
	git clone https://github.com/SEPIA-Framework/sepia-admin-tools.git
else
	echo "Fetching $1 bundle folder zip..."
	wget -O sepia-custom-bundle-folder.zip https://github.com/SEPIA-Framework/sepia-installation-and-setup/blob/$1/sepia-custom-bundle-folder.zip?raw=true
	unzip -n sepia-custom-bundle-folder.zip -d ~/SEPIA
	echo "Cloning $1 branches..."
	git clone --single-branch -b $1 https://github.com/SEPIA-Framework/sepia-core-tools-java.git
	git clone --single-branch -b $1 https://github.com/SEPIA-Framework/sepia-websocket-server-java.git
	git clone --single-branch -b $1 https://github.com/SEPIA-Framework/sepia-assist-server.git
	git clone --single-branch -b $1 https://github.com/SEPIA-Framework/sepia-teach-server.git
	#git clone --single-branch -b $1 https://github.com/SEPIA-Framework/sepia-reverse-proxy.git
	git clone --single-branch -b $1 https://github.com/SEPIA-Framework/sepia-mesh-nodes.git
	git clone --single-branch -b $1 https://github.com/SEPIA-Framework/sepia-html-client-app.git
	git clone --single-branch -b $1 https://github.com/SEPIA-Framework/sepia-admin-tools.git
fi

#build all modules and copy client and admin-tools
cd sepia-core-tools-java && mvn install && cp -r target/release/. ~/SEPIA/sepia-assist-server/ && cd ..
cd sepia-websocket-server-java && mvn install && cp -r target/release/. ~/SEPIA/sepia-websocket-server-java/ && cd ..
cd sepia-assist-server && mvn install && cp -r target/release/. ~/SEPIA/sepia-assist-server/ && cd ..
cd sepia-teach-server && mvn install && cp -r target/release/. ~/SEPIA/sepia-teach-server/ && cd ..
#cd sepia-reverse-proxy && mvn install && cp -r target/release/. ~/SEPIA/sepia-reverse-proxy/ && cd ..
cd sepia-mesh-nodes/java && mvn install && cp -r target/release/. ~/SEPIA/sepia-mesh-nodes/ && cd ../..
mkdir -p sepia-assist-server/Xtensions/WebContent/app
cp -r sepia-html-client-app/www/. ~/SEPIA/sepia-assist-server/Xtensions/WebContent/app/
mkdir -p sepia-assist-server/Xtensions/WebContent/tools
cp -r sepia-admin-tools/admin-web-tools/. ~/SEPIA/sepia-assist-server/Xtensions/WebContent/tools/

#download and unzip elasticsearch (keeping the existing config folder)
wget -O elasticsearch.zip https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.3.3.zip
unzip -n elasticsearch.zip
cp -rn elasticsearch-*/. ~/SEPIA/elasticsearch/

#clean up
cd ~/SEPIA
rm -rf ~/SEPIA/tmp

#create release zip-file
if [ -z "$2" ]; then
	zip -r SEPIA-Home.zip *
	echo "Bundle created as ZIP at: $HOME/SEPIA/SEPIA-Home.zip"
else
	zip -r $2/SEPIA-Home.zip *
	echo "Bundle created as ZIP at: $2/SEPIA-Home.zip"
fi

#final note
echo "Java version:"
java -version
echo 'Please note: SEPIA components built with this version require the same (or a higher version) to run. As of February 2020 Java 12+ is not yet supported!'
