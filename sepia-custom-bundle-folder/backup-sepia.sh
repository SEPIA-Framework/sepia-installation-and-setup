#!/bin/bash
set -e
echo "Creating backup for default(!) SEPIA-Home installation..."
if command -v zip &> /dev/null;
then
    echo ""
else
    echo "Need to install zip package first:"
	sudo apt-get install -y zip unzip
fi
NOW=$(date +"%Y_%m_%d_%H%M%S")
BCK_FOLDER=SEPIA_backup_$NOW
mkdir $BCK_FOLDER
cp -r es-data $BCK_FOLDER/
mkdir -p $BCK_FOLDER/sepia-assist-server/Xtensions
mkdir -p $BCK_FOLDER/sepia-teach-server/Xtensions
mkdir -p $BCK_FOLDER/sepia-websocket-server-java/Xtensions
mkdir -p $BCK_FOLDER/sepia-reverse-proxy/settings
cp sepia-assist-server/Xtensions/assist.custom.properties $BCK_FOLDER/sepia-assist-server/Xtensions/
cp -r sepia-assist-server/Xtensions/Plugins $BCK_FOLDER/sepia-assist-server/Xtensions/
cp sepia-teach-server/Xtensions/teach.custom.properties $BCK_FOLDER/sepia-teach-server/Xtensions/
cp sepia-websocket-server-java/Xtensions/websocket.custom.properties $BCK_FOLDER/sepia-websocket-server-java/Xtensions/
cp sepia-reverse-proxy/settings/proxy.properties $BCK_FOLDER/sepia-reverse-proxy/settings/
cd $BCK_FOLDER
echo "Zipping backup..."
zip -r ~/SEPIA-Backup_$NOW.zip *
cd ..
rm -r $BCK_FOLDER
echo "Created backup for default SEPIA-Home installation at: ~/SEPIA-Backup_$NOW.zip"
echo "'default' means the backup includes: property files, installed plugins and the database."
echo "Note: DNS, Letsencrypt settings and custom modifications to e.g. 'radio-stations' or 'news-outlets' are NOT included, please backup manually!"