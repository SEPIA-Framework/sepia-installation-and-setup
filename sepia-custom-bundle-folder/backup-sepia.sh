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
#
# make sure we are in the right folder
SCRIPT_PATH="$(realpath "$BASH_SOURCE")"
SEPIA_FOLDER="$(dirname "$SCRIPT_PATH")"
cd "$SEPIA_FOLDER"
if [ -L "${SEPIA_FOLDER}/es-data" ]; then
	echo "It looks like you are using the external data folder for SEPIA."
	echo "The backup process for this setting is still UNDER CONSTRUCTION, sorry!"
	echo "But: You can simply make a copy the external folder :-)."
	exit 1
fi
#
NOW=$(date +"%Y_%m_%d_%H%M%S")
BCK_FOLDER=SEPIA_backup_$NOW
mkdir $BCK_FOLDER
mkdir -p $BCK_FOLDER/nginx
mkdir -p $BCK_FOLDER/letsencrypt
mkdir -p $BCK_FOLDER/sepia-assist-server/Xtensions/Assistant/commands
mkdir -p $BCK_FOLDER/sepia-assist-server/Xtensions/Assistant/answers
mkdir -p $BCK_FOLDER/sepia-assist-server/Xtensions/DynamicDNS
mkdir -p $BCK_FOLDER/sepia-assist-server/Xtensions/WebContent/views
mkdir -p $BCK_FOLDER/sepia-assist-server/Xtensions/WebContent/widgets
mkdir -p $BCK_FOLDER/sepia-teach-server/Xtensions
mkdir -p $BCK_FOLDER/sepia-websocket-server-java/Xtensions
#mkdir -p $BCK_FOLDER/sepia-reverse-proxy/settings
cp sepia-assist-server/Xtensions/assist.custom.properties $BCK_FOLDER/sepia-assist-server/Xtensions/
if [ -d "sepia-assist-server/Xtensions/Plugins" ]; then
	cp -r sepia-assist-server/Xtensions/Plugins $BCK_FOLDER/sepia-assist-server/Xtensions/
fi
if [ -d "sepia-assist-server/Xtensions/WebContent/views/custom" ]; then
	cp -r sepia-assist-server/Xtensions/WebContent/views/custom $BCK_FOLDER/sepia-assist-server/Xtensions/WebContent/views/
fi
if [ -d "sepia-assist-server/Xtensions/WebContent/widgets/custom" ]; then
	cp -r sepia-assist-server/Xtensions/WebContent/widgets/custom $BCK_FOLDER/sepia-assist-server/Xtensions/WebContent/widgets/
fi
find ./sepia-assist-server/Xtensions/Assistant/commands/ -maxdepth 1 -iname "*_custom.txt" -exec cp {} $BCK_FOLDER/sepia-assist-server/Xtensions/Assistant/commands/ \;
find ./sepia-assist-server/Xtensions/Assistant/answers/ -maxdepth 1 -iname "*_custom.txt" -exec cp {} $BCK_FOLDER/sepia-assist-server/Xtensions/Assistant/answers/ \;
cp sepia-assist-server/Xtensions/DynamicDNS/duck-dns.properties $BCK_FOLDER/sepia-assist-server/Xtensions/DynamicDNS/
cp letsencrypt/duck-dns-settings.sh $BCK_FOLDER/letsencrypt/
cp -r letsencrypt/work $BCK_FOLDER/letsencrypt/
cp -r letsencrypt/config $BCK_FOLDER/letsencrypt/
cp -r nginx/self-signed-ssl $BCK_FOLDER/nginx/
cp sepia-teach-server/Xtensions/teach.custom.properties $BCK_FOLDER/sepia-teach-server/Xtensions/
cp sepia-websocket-server-java/Xtensions/websocket.custom.properties $BCK_FOLDER/sepia-websocket-server-java/Xtensions/
#cp sepia-reverse-proxy/settings/proxy.properties $BCK_FOLDER/sepia-reverse-proxy/settings/
cp -r es-data $BCK_FOLDER/
cd $BCK_FOLDER
echo "Zipping backup..."
zip -r "${HOME}/SEPIA-Backup_$NOW.zip" *
cd ..
rm -rf $BCK_FOLDER
echo ""
echo "Created backup for default SEPIA-Home installation at: ~/SEPIA-Backup_$NOW.zip"
if [ -n "$ISDOCKER" ]; then
	echo ""
	echo "NOTE: Due to the Docker environment the backup file will not be persistent unless you copy it to a shared volume!"
fi
echo ""
echo "The backup includes:"
echo "- Server configurations (.properties files)"
echo "- Complete Elasticsearch database (accounts, user data, Teach-UI commands, smart-home settings, etc.)"
echo "- SDK services (Assist-server plugins)"
echo "- Custom files for 'commands' and 'answers' (Assist-server)"
echo "- Custom views for HTML services (Assist-server 'Xtensions/WebContent/views/custom/')"
echo "- Custom widgets for media-players etc. (Assist-server 'Xtensions/WebContent/widgets/custom/')"
echo "- Self-signed SSL certs + Duck-DNS config + Let's Encrypt files"
echo ""
echo "NOT included (please backup manually as required!):"
echo "- Custom views for HTML services outside of 'custom' folder (see above)"
echo "- Custom widgets for media-players etc. outside of 'custom' folder (see above)"
echo "- Custom web-server data from (Assist-server 'Xtensions/WebContent/...')"
echo "- Custom modifications to 'radio-stations' and 'news-outlets' (Assist-server)"
echo "- Custom modifications to TTS voices or Mary-TTS data (Assist-server 'Xtensions/TTS')"
echo "- Custom modifications to 'common.json' Teach-UI file (Teach-server)"
echo "- Java installation stored in 'java' folder"
echo "- Log files and cached data (e.g. RSS feed cache)"
echo "- Nginx config files, see: /etc/nginx/sites-enabled/"
echo "- Other custom modifications (tbd)"
echo ""
echo "DONE"