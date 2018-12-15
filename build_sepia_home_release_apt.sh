#!/bin/bash
set -e

#check packages (except Java)
apt-get update
apt-get install -y wget maven zip unzip git curl procps

#backup if folder exists
if [ -d "$HOME/SEPIA" ]; then
	NOW=$(date +"%Y_%m_%d_%H%M%S")
	mv ~/SEPIA ~/SEPIA_backup_$NOW
	echo "Made a backup of previous SEPIA folder at: $HOME/SEPIA_backup_$NOW" 
fi

#make new SEPIA and tmp folder and download files
mkdir -p ~/SEPIA/tmp
cd ~/SEPIA/tmp

wget -O sepia-custom-bundle-folder.zip https://github.com/SEPIA-Framework/sepia-installation-and-setup/blob/master/sepia-custom-bundle-folder.zip?raw=true
unzip -n sepia-custom-bundle-folder.zip -d ~/SEPIA

if [ -z "$1" ]; then
	echo "Cloning master branches..."
	git clone https://github.com/SEPIA-Framework/sepia-core-tools-java.git
	git clone https://github.com/SEPIA-Framework/sepia-websocket-server-java.git
	git clone https://github.com/SEPIA-Framework/sepia-assist-server.git
	git clone https://github.com/SEPIA-Framework/sepia-teach-server.git
	git clone https://github.com/SEPIA-Framework/sepia-reverse-proxy.git
	git clone https://github.com/SEPIA-Framework/sepia-html-client-app.git
	git clone https://github.com/SEPIA-Framework/sepia-admin-tools.git
else
	echo "Cloning $1 branches..."
	git clone --single-branch -b $1 https://github.com/SEPIA-Framework/sepia-core-tools-java.git
	git clone --single-branch -b $1 https://github.com/SEPIA-Framework/sepia-websocket-server-java.git
	git clone --single-branch -b $1 https://github.com/SEPIA-Framework/sepia-assist-server.git
	git clone --single-branch -b $1 https://github.com/SEPIA-Framework/sepia-teach-server.git
	git clone --single-branch -b $1 https://github.com/SEPIA-Framework/sepia-reverse-proxy.git
	git clone --single-branch -b $1 https://github.com/SEPIA-Framework/sepia-html-client-app.git
	git clone --single-branch -b $1 https://github.com/SEPIA-Framework/sepia-admin-tools.git
fi

#build all modules and copy client and admin-tools
cd sepia-core-tools-java && mvn install && cp -r target/release/. ~/SEPIA/sepia-assist-server/ && cd ..
cd sepia-websocket-server-java && mvn install && cp -r target/release/. ~/SEPIA/sepia-websocket-server-java/ && cd ..
cd sepia-assist-server && mvn install && cp -r target/release/. ~/SEPIA/sepia-assist-server/ && cd ..
cd sepia-teach-server && mvn install && cp -r target/release/. ~/SEPIA/sepia-teach-server/ && cd ..
cd sepia-reverse-proxy && mvn install && cp -r target/release/. ~/SEPIA/sepia-reverse-proxy/ && cd ..
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
rm -r ~/SEPIA/tmp

#create release zip-file
if [ -z "$2" ]; then
	zip -r SEPIA-Home.zip *
	echo "Bundle created as ZIP at: $HOME/SEPIA/SEPIA-Home.zip"
else
	zip -r $2/SEPIA-Home.zip *
	echo "Bundle created as ZIP at: $2/SEPIA-Home.zip"
fi
