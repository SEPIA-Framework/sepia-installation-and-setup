#!/bin/bash
set -e
echo "Creating external data folder and symlinks for SEPIA-Home..."
#
# make sure we are in the right folder
SCRIPT_PATH="$(realpath "$BASH_SOURCE")"
SEPIA_FOLDER="$(dirname $(dirname "$SCRIPT_PATH"))"
SEPIA_DATA="$HOME/sepia-home-data"
#
mkdir -p "$SEPIA_DATA"
echo "Data folder location: $SEPIA_DATA"
#
SEPIA_DATA_NW_NGINX=$SEPIA_DATA/network/nginx
SEPIA_DATA_NW_LETSENCRYPT=$SEPIA_DATA/network/letsencrypt
SEPIA_DATA_NW_DYNDNS=$SEPIA_DATA/network/DynamicDNS
SEPIA_DATA_AS_COMMANDS=$SEPIA_DATA/assistant/commands
SEPIA_DATA_AS_ANSWERS=$SEPIA_DATA/assistant/answers
SEPIA_DATA_FS_VIEWS=$SEPIA_DATA/files/views
SEPIA_DATA_FS_WIDGETS=$SEPIA_DATA/files/widgets
SEPIA_DATA_FS_SERVICES=$SEPIA_DATA/files/services
SEPIA_DATA_CFG=$SEPIA_DATA/settings
#SEPIA_DATA_LOGS=$SEPIA_DATA/logs
SEPIA_DATA_DB=$SEPIA_DATA/database
SEPIA_DATA_AUTO_SET=$SEPIA_DATA/automatic-setup
mkdir -p "$SEPIA_DATA_NW_NGINX"
mkdir -p "$SEPIA_DATA_NW_LETSENCRYPT"
mkdir -p "$SEPIA_DATA_NW_DYNDNS"
mkdir -p "$SEPIA_DATA_AS_COMMANDS"
mkdir -p "$SEPIA_DATA_AS_ANSWERS"
mkdir -p "$SEPIA_DATA_FS_VIEWS"
mkdir -p "$SEPIA_DATA_FS_WIDGETS"
mkdir -p "$SEPIA_DATA_FS_SERVICES"
mkdir -p "$SEPIA_DATA_CFG"
#mkdir -p "$SEPIA_DATA_LOGS"
mkdir -p "$SEPIA_DATA_DB"
mkdir -p "$SEPIA_DATA_AUTO_SET"
#
create_link () {
	if [ -L "$1" ]; then
		echo "Already a symlink: $1"
	else
		echo "Moving data and creating symlink: $1 --> $2"
		mv "$1" "$2" && ln -s "$2" "$1"
	fi
}
create_file () {
	if [ -L "$1" ]; then
		echo "File already exists as symlink: $1"
	elif [ -f "$1" ]; then
		echo "File already exists: $1"
	else
		echo "Creating file: $1"
		touch $1
	fi
}
create_link "${SEPIA_FOLDER}/automatic-setup" "${SEPIA_DATA_DB}/automatic-setup"
create_link "${SEPIA_FOLDER}/es-data" "${SEPIA_DATA_DB}/es-data"
create_link "${SEPIA_FOLDER}/sepia-assist-server/Xtensions/Plugins/net/b07z/sepia/sdk" "${SEPIA_DATA_FS_SERVICES}/sdk"
create_link "${SEPIA_FOLDER}/sepia-assist-server/Xtensions/WebContent/views/custom" "${SEPIA_DATA_FS_VIEWS}/custom"
create_link "${SEPIA_FOLDER}/sepia-assist-server/Xtensions/WebContent/widgets/custom" "${SEPIA_DATA_FS_WIDGETS}/custom"
create_link "${SEPIA_FOLDER}/sepia-assist-server/Xtensions/assist.custom.properties" "${SEPIA_DATA_CFG}/assist.custom.properties"
create_link "${SEPIA_FOLDER}/sepia-teach-server/Xtensions/teach.custom.properties" "${SEPIA_DATA_CFG}/teach.custom.properties"
create_link "${SEPIA_FOLDER}/sepia-websocket-server-java/Xtensions/websocket.custom.properties" "${SEPIA_DATA_CFG}/websocket.custom.properties"
create_link "${SEPIA_FOLDER}/sepia-assist-server/Xtensions/DynamicDNS/duck-dns.properties" "${SEPIA_DATA_NW_DYNDNS}/duck-dns.properties"
create_link "${SEPIA_FOLDER}/letsencrypt/duck-dns-settings.sh" "${SEPIA_DATA_NW_LETSENCRYPT}/duck-dns-settings.sh"
create_link "${SEPIA_FOLDER}/letsencrypt/work" "${SEPIA_DATA_NW_LETSENCRYPT}/work"
create_link "${SEPIA_FOLDER}/letsencrypt/config" "${SEPIA_DATA_NW_LETSENCRYPT}/config"
create_link "${SEPIA_FOLDER}/nginx/self-signed-ssl" "${SEPIA_DATA_NW_NGINX}/self-signed-ssl"
# create all custom files if they don't exist yet to link them right away
find "${SEPIA_FOLDER}/sepia-assist-server/Xtensions/Assistant/commands/" -maxdepth 1 -regex '.*_\w\w\.txt'\
 | while read file; do create_file "${SEPIA_FOLDER}/sepia-assist-server/Xtensions/Assistant/commands/$(basename $file .txt)_custom.txt"; done
find "${SEPIA_FOLDER}/sepia-assist-server/Xtensions/Assistant/answers/" -maxdepth 1 -regex '.*_\w\w\.txt'\
 | while read file; do create_file "${SEPIA_FOLDER}/sepia-assist-server/Xtensions/Assistant/answers/$(basename $file .txt)_custom.txt"; done
# now create the links
find "${SEPIA_FOLDER}/sepia-assist-server/Xtensions/Assistant/commands/" -maxdepth 1 -iname "*_custom.txt"\
 | while read file; do create_link "$file" "${SEPIA_DATA_AS_COMMANDS}/$(basename $file)"; done
find "${SEPIA_FOLDER}/sepia-assist-server/Xtensions/Assistant/answers/" -maxdepth 1 -iname "*_custom.txt"\
 | while read file; do create_link "$file" "${SEPIA_DATA_AS_ANSWERS}/$(basename $file)"; done
#
echo ""
echo "DONE"
echo ""
echo "NOTE: The following data is NOT yet included:"
echo "- Custom views for HTML services outside of 'custom' folder"
echo "- Custom widgets for media-players etc. outside of 'custom' folder"
echo "- Custom web-server data from (Assist-server 'Xtensions/WebContent/...')"
echo "- Custom modifications to 'radio-stations' and 'news-outlets' (Assist-server)"
echo "- Custom modifications to TTS voices or Mary-TTS data (Assist-server 'Xtensions/TTS')"
echo "- Custom modifications to 'common.json' Teach-UI file (Teach-server)"
echo "- Log files and cached data (e.g. RSS feed cache)"
echo "- Nginx config files, see: /etc/nginx/sites-enabled/"
echo "- Other custom modifications (tbd)"
echo ""