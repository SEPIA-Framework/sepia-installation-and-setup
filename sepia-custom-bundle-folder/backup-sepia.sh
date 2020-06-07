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
mkdir -p $BCK_FOLDER/nginx
mkdir -p $BCK_FOLDER/letsencrypt
mkdir -p $BCK_FOLDER/sepia-assist-server/Xtensions/Assistant/commands
mkdir -p $BCK_FOLDER/sepia-assist-server/Xtensions/Assistant/answers
mkdir -p $BCK_FOLDER/sepia-assist-server/Xtensions/DynamicDNS
mkdir -p $BCK_FOLDER/sepia-teach-server/Xtensions
mkdir -p $BCK_FOLDER/sepia-websocket-server-java/Xtensions
mkdir -p $BCK_FOLDER/sepia-reverse-proxy/settings
cp sepia-assist-server/Xtensions/assist.custom.properties $BCK_FOLDER/sepia-assist-server/Xtensions/
cp -r sepia-assist-server/Xtensions/Plugins $BCK_FOLDER/sepia-assist-server/Xtensions/
find ./sepia-assist-server/Xtensions/Assistant/commands/ -maxdepth 1 -iname "*_custom.txt" -exec cp {} $BCK_FOLDER/sepia-assist-server/Xtensions/Assistant/commands/ \;
find ./sepia-assist-server/Xtensions/Assistant/answers/ -maxdepth 1 -iname "*_custom.txt" -exec cp {} $BCK_FOLDER/sepia-assist-server/Xtensions/Assistant/answers/ \;
cp sepia-assist-server/Xtensions/DynamicDNS/duck-dns.properties $BCK_FOLDER/sepia-assist-server/Xtensions/DynamicDNS/
cp letsencrypt/duck-dns-settings.sh $BCK_FOLDER/letsencrypt/
cp -r letsencrypt/work $BCK_FOLDER/letsencrypt/
cp -r letsencrypt/config $BCK_FOLDER/letsencrypt/
cp -r nginx/self-signed-ssl $BCK_FOLDER/nginx/
cp sepia-teach-server/Xtensions/teach.custom.properties $BCK_FOLDER/sepia-teach-server/Xtensions/
cp sepia-websocket-server-java/Xtensions/websocket.custom.properties $BCK_FOLDER/sepia-websocket-server-java/Xtensions/
cp sepia-reverse-proxy/settings/proxy.properties $BCK_FOLDER/sepia-reverse-proxy/settings/
cp -r es-data $BCK_FOLDER/
cd $BCK_FOLDER
echo "Zipping backup..."
zip -r ~/SEPIA-Backup_$NOW.zip *
cd ..
rm -r $BCK_FOLDER
echo ""
echo "Created backup for default SEPIA-Home installation at: ~/SEPIA-Backup_$NOW.zip"
echo ""
echo "The backup includes:"
echo "- Server configurations (.properties files)"
echo "- SDK services (Assist-server plugins)"
echo "- Complete Elasticsearch database"
echo "- Custom files for 'commands' and 'answers' (Assist-server)"
echo "- Duck-DNS config + Let's Encrypt files + self-signed SSL certs"
echo ""
echo "NOT included (please backup manually as required!):"
echo "- Custom modifications to 'radio-stations' and 'news-outlets'"
echo "- Custom modifications to 'common.json' Teach-UI file"
echo "- Custom web-server data from 'sepia-assist-server/Xtensions/WebContent'"
echo "- Mary-TTS server data from 'sepia-assist-server/Xtensions/TTS/marytts'"
echo "- Java installation stored in 'java' folder"
echo "- Log files and cached data (e.g. RSS feeds)"
echo "- Nginx config files, see: /etc/nginx/sites-enabled/"
echo ""
echo "DONE"