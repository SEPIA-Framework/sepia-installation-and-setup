#!/bin/bash
#usage examples: 
#bash install_sepia_client.sh dev 			-> CLIENT_BRANCH=dev, 		SKIP_BLE=false
#bash install_sepia_client.sh skipBLE 		-> CLIENT_BRANCH=master, 	SKIP_BLE=true
#bash install_sepia_client.sh dev skipBLE 	-> CLIENT_BRANCH=dev, 		SKIP_BLE=true
set -e
SCRIPT_PATH="$(realpath "$BASH_SOURCE")"
LOG="$(dirname "$SCRIPT_PATH")""/log-install.out"
NOW=$(date +"%Y_%m_%d_%H:%M:%S")
this_folder="$(dirname "$SCRIPT_PATH")"
cd "$this_folder"
echo "Installation started: $NOW" > "$LOG"

is_armv6l() {
  case "$(uname -m)" in
    armv6l) return 0 ;;
    *) return 1 ;;
  esac
}

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
echo "$NOW - Branch: $CLIENT_BRANCH, skipBLE=$SKIP_BLE" >> "$LOG"
#
# Prepare
echo "Preparing installation of SEPIA Client for Raspberry Pi ..."
echo "$NOW - Updating/installing required Linux packages ..." >> "$LOG"
sudo apt-get update
sudo apt-get install -y git
mkdir -p tmp
rm -rf tmp/*
echo "=========================================="
#
# Voices
echo "Installing TTS voices ..."
echo "$NOW - Installing TTS voices ..." >> "$LOG"
sudo apt-get install -y espeak-ng espeak-ng-espeak
sudo apt-get install -y --no-install-recommends flite-dev flite libttspico-data
cd tmp
wget http://ftp.de.debian.org/debian/pool/non-free/s/svox/libttspico0_1.0+git20130326-9_armhf.deb
wget http://ftp.de.debian.org/debian/pool/non-free/s/svox/libttspico-utils_1.0+git20130326-9_armhf.deb
# apt-get install -f ./libttspico0_1.0+git20130326-9_armhf.deb ./libttspico-utils_1.0+git20130326-9_armhf.deb
sudo dpkg -i libttspico0_1.0+git20130326-9_armhf.deb
sudo dpkg -i libttspico-utils_1.0+git20130326-9_armhf.deb
cd $this_folder
echo "=========================================="
#
# Openbox with Chromium
echo "Installing app environment ..."
echo "$NOW - Installing app environment (X-Server, Xvfb, Openbox, Chromium, etc.) ..." >> "$LOG"
sudo apt-get install -y --no-install-recommends xserver-xorg x11-xserver-utils xinit openbox xvfb xterm
# NOTE: 'chromium' can be an alternative if 'chromium-browser' has issues but currently 'chromium' has graphic glitches :-/
sudo apt-get install -y --no-install-recommends chromium-browser libgtk-3-0 libgtk-3-bin libgtk-3-common unclutter
mkdir -p ~/sepia-client/chromium
mkdir -p ~/sepia-client/chromium-extensions
cp sepia-client/* ~/sepia-client/
mkdir -p ~/.config/openbox
echo "$NOW - Copying Openbox autostart to ~/.config/openbox/autostart" >> "$LOG"
cp openbox ~/.config/openbox/autostart
startfile=~/.bashrc
echo "$NOW - Updating $startfile ..." >> "$LOG"
if grep -q "sepia_run_on_login" $startfile; then
    echo "Found 'sepia_run_on_login' in $startfile already"
	echo "$NOW - Skipped: Found 'sepia_run_on_login' in $startfile already" >> "$LOG"
else
	echo '' >> $startfile
	echo '# Run SEPIA-Client on login?' >> $startfile
	echo 'sepia_run_on_login="$HOME/sepia-client/on-login.sh"' >> $startfile
	echo 'if [ -f "$sepia_run_on_login" ]; then' >> $startfile
	echo '    bash $sepia_run_on_login' >> $startfile
	echo 'fi' >> $startfile
	echo "$NOW - Added 'sepia_run_on_login' section" >> "$LOG"
fi
echo "=========================================="
#
# CLEXI
echo "Installing Node.js and CLEXI ..."
echo "$NOW - Installing Node.js ..." >> "$LOG"
if [ -n "$(command -v node)" ] && [ -n "$(command -v npm)" ]; then
	echo "Found Node.js and skipped installation - Recommended Node.js is 10, please double-check!"
	echo "$NOW - Skipped: Found Node.js: $(node -v), npm: $(npm -v)" >> "$LOG"
	echo "$NOW - NOTE: Recommended Node.js is 10 - Please double-check!" >> "$LOG"
else
	if is_armv6l;
	then
		f=$(wget -qO- https://nodejs.org/download/release/latest-dubnium/ | grep "armv6l.tar.gz" | cut -d '"' -f 2);
		wget -O tmp/nodejs-armv6l-v10.x.tar.gz https://nodejs.org/dist/latest-v10.x/$f
		sudo tar -zxf tmp/nodejs-armv6l-v10.x.tar.gz --strip-components=1 -C /usr
	else
		curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
		sudo apt-get install -y nodejs
	fi
	echo "$NOW - Installed Node.js: $(node -v), npm: $(npm -v)" >> "$LOG"
fi
echo "Node.js: $(node -v) - npm: $(npm -v)"
echo "$NOW - Installing CLEXI ..." >> "$LOG"
if [ -d ~/clexi ]; then
	echo "Found CLEXI home folder, skipped download - To update CLEXI remove ~/clexi before running this script"
	echo "$NOW - Found CLEXI home folder, skipped download - To update CLEXI remove ~/clexi before running this script" >> "$LOG"
else
	git clone https://github.com/bytemind-de/nodejs-client-extension-interface.git ~/clexi
	cp clexi_settings.json ~/clexi/settings.json
fi
# copy additional runtime commands
echo "$NOW - Updating CLEXI runtime_commands" >> "$LOG"
mkdir -p ~/clexi/runtime_commands
cp runtime_commands/* ~/clexi/runtime_commands/
cd ~/clexi
if [ "$SKIP_BLE" != "true" ]; then
	echo "$NOW - Installing required packages including Bluetooth ..." >> "$LOG"
    sudo apt-get install -y bluetooth bluez libbluetooth-dev libudev-dev libnss3-tools libcap2-bin openssl
else
	# Skip Bluetooth
	echo "$NOW - Installing required packages skipping Bluetooth ..." >> "$LOG"
	# TODO: if CLEXI changes the package.json this will break ...
	sed -ri "s|\"node-beacon-scanner.*github:bytemind-de/node-beacon-scanner\"||" package.json
	sed -ri "s|1.0.1\",|1.0.1\"|" package.json
	sudo apt-get install -y libnss3-tools libcap2-bin openssl
fi
npm install --loglevel error
sudo setcap cap_net_raw+eip $(eval readlink -f `which node`)
cd $this_folder
echo "=========================================="
#
# SEPIA Client
echo "Downloading latest SEPIA Client version ..."
echo "$NOW - Downloading SEPIA Client version from branch $CLIENT_BRANCH ..." >> "$LOG"
if [ -d ~/clexi/www/sepia ]; then
	echo "$NOW - Cleaning up existing folder ~/clexi/www/sepia ..." >> "$LOG"
	rm -rf ~/clexi/www/sepia/*
else
	mkdir -p ~/clexi/www/sepia
fi
if [ -d ~/sepia-client/chromium-extensions/sepia-fw ]; then
	echo "$NOW - Cleaning up existing folder ~/sepia-client/chromium-extensions/sepia-fw ..." >> "$LOG"
	rm -rf ~/sepia-client/chromium-extensions/sepia-fw/*
else
	mkdir -p ~/sepia-client/chromium-extensions/sepia-fw
fi
git clone --single-branch -b $CLIENT_BRANCH https://github.com/SEPIA-Framework/sepia-html-client-app.git tmp/sepia-client-git
echo "$NOW - Downloading SEPIA Client browser extension from branch master ..." >> "$LOG"
git clone --single-branch -b master https://github.com/SEPIA-Framework/sepia-browser-extensions tmp/sepia-client-browser-ex-git
mv tmp/sepia-client-git/www/* ~/clexi/www/sepia/
mv tmp/sepia-client-browser-ex-git/chromium/* ~/sepia-client/chromium-extensions/sepia-fw/
rm -rf tmp/sepia-client-git
rm -rf tmp/sepia-client-browser-ex-git
echo "=========================================="
#
# Nginx
echo "Installing proxy ..."
echo "$NOW - Installing Nginx proxy ..." >> "$LOG"
sudo apt-get install -y nginx
echo "$NOW - Copying Nginx config (sepia-client-nginx.conf) to /etc/nginx/sites-enabled/" >> "$LOG"
sudo cp sepia-client-nginx.conf /etc/nginx/sites-enabled/
sudo nginx -t
echo "$NOW - Starting Nginx ..." >> "$LOG"
sudo nginx -s reload
echo "=========================================="
echo "DONE!"
echo "$NOW - DONE" >> "$LOG"
echo ""
echo "Please make sure that your Raspberry automatically logs in after reboot (sudo raspi-config -> boot -> Desktop -> ...)"
echo "then reboot the RPi and after a few seconds you should hear a voice saying 'just a second' followed by 'ready for setup' few seconds later."
echo "Now you can use the SEPIA Control HUB to set up your new SEPIA Client :-)"
