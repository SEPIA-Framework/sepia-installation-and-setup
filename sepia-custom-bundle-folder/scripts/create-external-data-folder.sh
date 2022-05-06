#!/bin/bash
set -e
# make sure we have the right folders
SCRIPT_PATH="$(realpath "$BASH_SOURCE")"
SEPIA_FOLDER="$(dirname $(dirname "$SCRIPT_PATH"))"
SEPIA_DATA="$HOME/sepia-home-data"
# skip confirm question?
autoconfirm=""
silent=""
skip_shutdown=""
while getopts yhsup: opt; do
	case $opt in
		y) autoconfirm=1;;
		p) SEPIA_DATA="$(realpath $OPTARG)";;
		s) silent=1;;
		u) skip_shutdown=1;;
		?|h) printf "Usage: %s [-y] [-s] [-u] [-p target-path]\n" $0; exit 2;;
	esac
done
if [ -z "$autoconfirm" ]; then
	echo "This script will reorganize your SEPIA folder moving most of the user data"
	echo "to '$SEPIA_DATA' and create symlinks for the original files and folders."
	echo "If symlinks already exist you will be asked to confirm or skip restoration."
	echo "Use the '-y' flag to automatically confirm all questions."
	echo ""
	echo "NOTE: Your backup and update scripts might be affected by this!"
	echo ""
	read -p "Enter 'ok' to continue: " okabort
	echo ""
	if [ -n "$okabort" ] && [ $okabort = "ok" ]; then
		echo "Ok. Good luck ;-)"
	else
		echo "Np. Maybe later :-)"
		exit
	fi
	echo ""
fi
cd "$SEPIA_FOLDER"
if [ -z "$skip_shutdown" ]; then
	# make sure SEPIA server if OFF
	echo "Making sure SEPIA is OFF..."
	bash shutdown-sepia.sh
	echo ""
fi
# start
echo "Creating external data folder and/or symlinks for SEPIA-Home..."
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
		if [ -e "$2" ]; then
			# make sure existing symlink is up-to-date
			ln -snf "$2" "$1"
			if [ -z "$silent" ]; then
				echo "Refreshed symlink for: $1"
			fi
		else
			echo "Target does not exist: $2"
			exit 1
		fi
	elif [ -e "$2" ]; then
		if [ -e "$1" ] && [ -z "$autoconfirm" ]; then
			echo "External file or folder already exists: $2"
			# ask to restore symlink
			read -p "Restore symlink (delete internal)? (Y/n): " yesno
			if [ -z "$yesno" ] || [ $yesno = "y" ]; then
				rm -rf "$1"
				ln -sn "$2" "$1"
				echo "Restored symlink"
			else
				echo "Skipped"
			fi
		else
			# restore symlink
			if [ -z "$silent" ]; then
				echo "Restoring symlink for: $1"
			fi
			rm -rf "$1"
			ln -sn "$2" "$1"
		fi
	else
		if [ -z "$silent" ]; then
			echo "Moving data and creating symlink: $1 --> $2"
		fi
		mv "$1" "$2"
		ln -sn "$2" "$1"
	fi
}
create_file_and_link () {
	if [ -L "$1" ] || [ -f "$1" ]; then
		# internal file exists or is symlink so hand over
		create_link "$1" "$2/$(basename $1)"
	elif [ -f "$2/$(basename $1)" ]; then
		# nothing internal but external file exists - create symlink (overwrite)
		ln -snf "$2/$(basename $1)" "$1"
	else
		# create file then hand over
		if [ -z "$silent" ]; then
			echo "Creating file: $1"
		fi
		touch $1
		create_link "$1" "$2/$(basename $1)"
	fi
}
create_link "${SEPIA_FOLDER}/automatic-setup" "${SEPIA_DATA_AUTO_SET}"
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
# create all custom files if they don't exist yet and link them right away (or restore link if already exists)
find "${SEPIA_FOLDER}/sepia-assist-server/Xtensions/Assistant/commands/" -maxdepth 1 -regex '.*_\w\w\.txt'\
 | while read file; do create_file_and_link "${SEPIA_FOLDER}/sepia-assist-server/Xtensions/Assistant/commands/$(basename $file .txt)_custom.txt" "$SEPIA_DATA_AS_COMMANDS"; done
find "${SEPIA_FOLDER}/sepia-assist-server/Xtensions/Assistant/answers/" -maxdepth 1 -regex '.*_\w\w\.txt'\
 | while read file; do create_file_and_link "${SEPIA_FOLDER}/sepia-assist-server/Xtensions/Assistant/answers/$(basename $file .txt)_custom.txt" "$SEPIA_DATA_AS_ANSWERS"; done
#
echo ""
echo "DONE"
echo ""
if [ -z "$silent" ]; then
	echo "NOTE: The following data is NOT yet included in external data folder:"
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
fi