#!/bin/bash
#usage examples: 
#bash install_sepia_client.sh dev 			-> CLIENT_BRANCH=dev, 		SKIP_BLE=false
#bash install_sepia_client.sh skipBLE 		-> CLIENT_BRANCH=master, 	SKIP_BLE=true
#bash install_sepia_client.sh dev skipBLE 	-> CLIENT_BRANCH=dev, 		SKIP_BLE=true
set -e
SCRIPT_PATH="$(realpath "$BASH_SOURCE")"
LOG="$(dirname "$SCRIPT_PATH")""/log-install.out"
log_date() {
	local NOW=$(date +"%Y_%m_%d_%H:%M:%S")
	echo "$NOW"
}
this_folder="$(dirname "$SCRIPT_PATH")"
cd "$this_folder"
echo "Installation started: $(log_date)" > "$LOG"

# kind of clumsy but easy way to allow combination of arguments CLIENT_BRANCH, SKIP_BLE
CLIENT_BRANCH="master"
SKIP_BLE="false"
if [ -n "$1" ]; then
    if [ "$1" = "skipBLE" ]; then
		SKIP_BLE="true"
	else
		CLIENT_BRANCH="$1"
	fi
fi
if [ -n "$2" ]; then
    if [ "$2" = "skipBLE" ]; then
		SKIP_BLE="true"
	fi
fi
echo "$(log_date) - Branch: $CLIENT_BRANCH, skipBLE=$SKIP_BLE" >> "$LOG"
#
# Prepare
echo "Preparing installation of SEPIA Client for Raspberry Pi ..."
echo "$(log_date) - Updating/installing required Linux packages ..." >> "$LOG"
sudo apt update
sudo apt-get install -y git ca-certificates
mkdir -p tmp
rm -rf tmp/*
echo "=========================================="
#
# Voices
echo "Installing TTS voices ..."
echo "$(log_date) - Installing TTS voices ..." >> "$LOG"
sudo apt-get install -y espeak-ng espeak-ng-espeak
echo "$(log_date) - Installed: espeak-ng" >> "$LOG"
sudo apt-get install -y --no-install-recommends flite-dev flite
echo "$(log_date) - Installed: flite" >> "$LOG"
# picoTTS - common:
if [ $(command -v pico2wave | wc -l) -eq 0 ]; then
	cd tmp
	wget http://ftp.de.debian.org/debian/pool/non-free/s/svox/libttspico-data_1.0+git20130326-9_all.deb
	sudo dpkg -i libttspico-data_1.0+git20130326-9_all.deb
	if [ -n "$(uname -m | grep aarch64)" ]; then
		echo "Platform: aarch64"
		echo "$(log_date) - Platform: aarch64" >> "$LOG"
		wget http://ftp.de.debian.org/debian/pool/non-free/s/svox/libttspico0_1.0+git20130326-9_arm64.deb
		wget http://ftp.de.debian.org/debian/pool/non-free/s/svox/libttspico-utils_1.0+git20130326-9_arm64.deb
		sudo dpkg -i libttspico0_1.0+git20130326-9_arm64.deb
		sudo dpkg -i libttspico-utils_1.0+git20130326-9_arm64.deb
	elif [ -n "$(uname -m | grep armv7l)" ]; then
		echo "Platform: armv7l"
		echo "$(log_date) - Platform: armv7l" >> "$LOG"
		wget http://ftp.de.debian.org/debian/pool/non-free/s/svox/libttspico0_1.0+git20130326-9_armhf.deb
		wget http://ftp.de.debian.org/debian/pool/non-free/s/svox/libttspico-utils_1.0+git20130326-9_armhf.deb
		sudo dpkg -i libttspico0_1.0+git20130326-9_armhf.deb
		sudo dpkg -i libttspico-utils_1.0+git20130326-9_armhf.deb
	elif [ -n "$(uname -m | grep x86_64)" ]; then
		echo "Platform: x86_64"
		echo "$(log_date) - Platform: x86_64" >> "$LOG"
		wget http://ftp.de.debian.org/debian/pool/non-free/s/svox/libttspico0_1.0+git20130326-9_amd64.deb
		wget http://ftp.de.debian.org/debian/pool/non-free/s/svox/libttspico-utils_1.0+git20130326-9_amd64.deb
		sudo dpkg -i libttspico0_1.0+git20130326-9_amd64.deb
		sudo dpkg -i libttspico-utils_1.0+git20130326-9_amd64.deb
	elif [ -n "$(uname -m | grep armv6l)" ]; then
		echo "Platform: armv6l - Process skipped"
		echo "$(log_date) - Platform: armv6l - Process skipped" >> "$LOG"
	else
		echo "Platform: x86_32"
		echo "$(log_date) - Platform: x86_32" >> "$LOG"
		wget http://ftp.de.debian.org/debian/pool/non-free/s/svox/libttspico0_1.0+git20130326-9_i386.deb
		wget http://ftp.de.debian.org/debian/pool/non-free/s/svox/libttspico-utils_1.0+git20130326-9_i386.deb
		sudo dpkg -i libttspico0_1.0+git20130326-9_i386.deb
		sudo dpkg -i libttspico-utils_1.0+git20130326-9_i386.deb
	fi
	echo "$(log_date) - Installed: pico2wave" >> "$LOG"
else
	echo "Already installed: pico2wave"
	echo "$(log_date) - Already installed: pico2wave" >> "$LOG"
fi
cd $this_folder
echo "=========================================="
#
# Openbox with Chromium
echo "Installing app environment ..."
echo "$(log_date) - Installing app environment (X-Server, Xvfb, Openbox, Chromium, etc.) ..." >> "$LOG"
sudo apt-get install -y --no-install-recommends xserver-xorg x11-xserver-utils xinit openbox xvfb xterm xinput xdg-utils
# NOTE: 'chromium' can be an alternative if 'chromium-browser' has issues but currently 'chromium' has graphic glitches :-/
sudo apt-get install -y --no-install-recommends chromium-browser chromium-codecs-ffmpeg-extra
echo "$(log_date) - If you're having trouble with the current version of Chromium try: 'bash install_chromium_92_from_archive.sh'" >> "$LOG"
if [ $(sudo apt-cache search unclutter | grep ^unclutter-xfixes | wc -l) -eq 0 ]; then
	sudo apt-get install -y --no-install-recommends unclutter
else
	sudo apt-get install -y --no-install-recommends unclutter-xfixes unclutter-startup
fi
# Some fixes (previously not required - pulseaudio fixes Chromium IPC semaphore errors and should be new default now):
sudo apt-get install -y --no-install-recommends libgtk-3-0 libgtk-3-bin libgtk-3-common libgles2-mesa upower pulseaudio pulsemixer
mkdir -p ~/sepia-client/chromium
mkdir -p ~/sepia-client/chromium-extensions
cp sepia-client/* ~/sepia-client/
mkdir -p ~/.config/openbox
echo "$(log_date) - Copying Openbox autostart to ~/.config/openbox/autostart" >> "$LOG"
cp openbox ~/.config/openbox/autostart
startfile=~/.bashrc
echo "$(log_date) - Updating $startfile ..." >> "$LOG"
if grep -q "sepia_run_on_login" $startfile; then
	echo "Found 'sepia_run_on_login' in $startfile already"
	echo "$(log_date) - Skipped: Found 'sepia_run_on_login' in $startfile already" >> "$LOG"
else
	echo '' >> $startfile
	echo '# Run SEPIA-Client on login?' >> $startfile
	echo 'sepia_run_on_login="$HOME/sepia-client/on-login.sh"' >> $startfile
	echo 'if [ -f "$sepia_run_on_login" ]; then' >> $startfile
	echo '    bash $sepia_run_on_login' >> $startfile
	echo 'fi' >> $startfile
	echo "$(log_date) - Added 'sepia_run_on_login' section" >> "$LOG"
fi
echo "=========================================="
#
# CLEXI
echo "Installing Node.js and CLEXI ..."
echo "$(log_date) - Installing Node.js ..." >> "$LOG"
if [ -n "$(command -v node)" ] && [ -n "$(command -v npm)" ]; then
	echo "Found Node.js and skipped installation - Recommended Node.js is 14, please double-check!"
	echo "$(log_date) - Skipped: Found Node.js: $(node -v), npm: $(npm -v)" >> "$LOG"
	echo "$(log_date) - NOTE: Recommended Node.js is 14 - Please double-check!" >> "$LOG"
else
	# Node.js 14 LTS
	curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
	sudo apt-get install -y nodejs
	echo "$(log_date) - Installed Node.js: $(node -v), npm: $(npm -v)" >> "$LOG"
fi
echo "Node.js: $(node -v) - npm: $(npm -v)"
echo "$(log_date) - Installing CLEXI" >> "$LOG"
if [ -d ~/clexi ]; then
	echo "Found CLEXI home folder, skipped download - To update CLEXI remove ~/clexi before running this script"
	echo "$(log_date) - Found CLEXI home folder, skipped download - To update CLEXI remove ~/clexi before running this script" >> "$LOG"
else
	echo "Cloning CLEXI into ~/clexi from branch $CLIENT_BRANCH ..."
	echo "$(log_date) - Cloning CLEXI into ~/clexi from branch $CLIENT_BRANCH ..." >> "$LOG"
	git clone --single-branch -b $CLIENT_BRANCH https://github.com/bytemind-de/nodejs-client-extension-interface.git ~/clexi
	cp clexi_settings.json ~/clexi/settings.json
fi
# copy additional runtime commands
echo "$(log_date) - Updating CLEXI runtime_commands" >> "$LOG"
mkdir -p ~/clexi/runtime_commands
cp runtime_commands/* ~/clexi/runtime_commands/
cd ~/clexi
if [ "$SKIP_BLE" != "true" ]; then
	echo "$(log_date) - Installing required packages including Bluetooth ..." >> "$LOG"
	sudo apt-get install -y bluetooth bluez libbluetooth-dev libudev-dev libnss3-tools libcap2-bin openssl
else
	# Skip Bluetooth
	echo "$(log_date) - Installing required packages skipping Bluetooth ..." >> "$LOG"
	sed -ri "s|\"node-beacon-scanner\".*||" package.json
	sudo apt-get install -y libudev-dev libnss3-tools libcap2-bin openssl
fi
npm install --loglevel error
sudo setcap cap_net_raw+eip $(eval readlink -f `which node`)
cd $this_folder
echo "=========================================="
#
# SEPIA Client
echo "Downloading latest SEPIA Client version ..."
echo "$(log_date) - Downloading SEPIA Client version from branch $CLIENT_BRANCH ..." >> "$LOG"
if [ -d ~/clexi/www/sepia ]; then
	echo "$(log_date) - Cleaning up existing folder ~/clexi/www/sepia ..." >> "$LOG"
	rm -rf ~/clexi/www/sepia/*
else
	mkdir -p ~/clexi/www/sepia
fi
if [ -d ~/sepia-client/chromium-extensions/sepia-fw ]; then
	echo "$(log_date) - Cleaning up existing folder ~/sepia-client/chromium-extensions/sepia-fw ..." >> "$LOG"
	rm -rf ~/sepia-client/chromium-extensions/sepia-fw/*
else
	mkdir -p ~/sepia-client/chromium-extensions/sepia-fw
fi
git clone --single-branch -b $CLIENT_BRANCH https://github.com/SEPIA-Framework/sepia-html-client-app.git tmp/sepia-client-git
echo "$(log_date) - Downloading SEPIA Client browser extension from branch master ..." >> "$LOG"
git clone --single-branch -b master https://github.com/SEPIA-Framework/sepia-browser-extensions tmp/sepia-client-browser-ex-git
mv tmp/sepia-client-git/www/* ~/clexi/www/sepia/
mv tmp/sepia-client-browser-ex-git/chromium/* ~/sepia-client/chromium-extensions/sepia-fw/
rm -rf tmp/sepia-client-git
rm -rf tmp/sepia-client-browser-ex-git
echo "=========================================="
#
# Nginx
echo "Installing proxy ..."
echo "$(log_date) - Installing Nginx proxy ..." >> "$LOG"
if [ $(command -v nginx | wc -l) -eq 0 ]; then
	sudo apt-get install -y nginx
else
	echo "$(log_date) - Found Nginx and skipped installation" >> "$LOG"
fi
echo "$(log_date) - Copying Nginx config (sepia-client-nginx.conf) to /etc/nginx/sites-enabled/" >> "$LOG"
if [ ! -f "/etc/nginx/sites-enabled/sepia-client-nginx.conf" ]; then
	sudo cp sepia-client-nginx.conf /etc/nginx/sites-enabled/
	sudo nginx -t
else
	echo "$(log_date) - Config already exists. Keeping old one." >> "$LOG"
fi
if [ -f "/etc/nginx/sites-enabled/default" ]; then
	echo "$(log_date) - Removing Nginx default config: '/etc/nginx/sites-enabled/default'" >> "$LOG"
	sudo rm /etc/nginx/sites-enabled/default
fi
echo "$(log_date) - (Re)starting Nginx ..." >> "$LOG"
sudo nginx -s reload
echo "=========================================="
echo "DONE!"
echo "Installation log: $LOG"
echo "$(log_date) - DONE" >> "$LOG"
echo ""
echo "Please make sure that your Raspberry automatically logs in after reboot (sudo raspi-config -> boot -> Desktop -> ...)"
echo "then reboot the RPi and after a few seconds you should hear a voice saying 'just a second' followed by 'ready for setup' few seconds later."
echo "Now you can use the SEPIA Control HUB to set up your new SEPIA Client :-)"
