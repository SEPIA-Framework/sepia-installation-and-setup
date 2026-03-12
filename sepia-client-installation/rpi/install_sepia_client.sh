#!/bin/bash
#usage examples: 
#bash install_sepia_client.sh dev 			-> CLIENT_BRANCH=dev, 		SKIP_BLE=false
#bash install_sepia_client.sh skipBLE 		-> CLIENT_BRANCH=master, 	SKIP_BLE=true
#bash install_sepia_client.sh dev skipBLE 	-> CLIENT_BRANCH=dev, 		SKIP_BLE=true
set -e
SCRIPT_PATH="$(realpath "$BASH_SOURCE")"
LOG="$(dirname "$SCRIPT_PATH")""/log-install.out"
#
# return current date/time
log_date() {
	local NOW=$(date +"%Y_%m_%d_%H:%M:%S")
	echo "$NOW"
}
# check version - returns 0 if actual version >= required version, 1 if too old
# Usage: check_version "1.2.3" "1.1.0"
check_version() {
	local actual="$1"
	local required="$2"
	# extract only the numeric version part e.g. "20.19.2+dfsg-1" -> "20.19.2"
	actual=$(echo "$actual" | grep -oP '\d+[.]\d+[.]\d+' | head -1)
	local actual_major=$(echo "$actual"  | grep -oP '^\d+')
	local actual_minor=$(echo "$actual"  | grep -oP '(?<=\.)\d+' | head -1)
	local actual_patch=$(echo "$actual"  | grep -oP '(?<=\.)\d+' | tail -1)
	local req_major=$(echo "$required"   | grep -oP '^\d+')
	local req_minor=$(echo "$required"   | grep -oP '(?<=\.)\d+' | head -1)
	local req_patch=$(echo "$required"   | grep -oP '(?<=\.)\d+' | tail -1)
	actual_minor=${actual_minor:-0}
	actual_patch=${actual_patch:-0}
	req_minor=${req_minor:-0}
	req_patch=${req_patch:-0}
	if   [ "$actual_major" -gt "$req_major" ]; then return 0
	elif [ "$actual_major" -lt "$req_major" ]; then return 1
	elif [ "$actual_minor" -gt "$req_minor" ]; then return 0
	elif [ "$actual_minor" -lt "$req_minor" ]; then return 1
	elif [ "$actual_patch" -ge "$req_patch" ]; then return 0
	else return 1
	fi
}
#
# Start
this_folder="$(dirname "$SCRIPT_PATH")"
cd "$this_folder"
echo "Installation started: $(log_date)" > "$LOG"
#
# kind of clumsy but easy way to allow combination of arguments CLIENT_BRANCH, SKIP_BLE
CLIENT_BRANCH="master"
SKIP_BLE="false"
# Display mode: "xserver" (X11 + Openbox) or "wayland" (Wayland + labwc)
DISPLAY_MODE="xserver"
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
echo "$(log_date) - Branch: $CLIENT_BRANCH, skipBLE=$SKIP_BLE, displayMode=$DISPLAY_MODE" >> "$LOG"
#
# Prepare
echo "Preparing installation of SEPIA Client for Raspberry Pi ..."
echo "$(log_date) - Updating/installing required Linux packages ..." >> "$LOG"
sudo apt update
sudo apt install -y curl git ca-certificates build-essential
mkdir -p tmp
rm -rf tmp/*
echo "=========================================="
#
# Voices
echo "Installing TTS voices ..."
echo "$(log_date) - Installing TTS voices ..." >> "$LOG"
# espeak-ng
if [ $(command -v espeak-ng | wc -l) -eq 0 ]; then
	{
		sudo apt install -y espeak-ng espeak-ng-espeak
		echo "$(log_date) - Installed: espeak-ng" >> "$LOG"
	} || {
		echo "WARNING: espeak-ng installation failed - continuing without it"
		echo "$(log_date) - WARNING: espeak-ng installation failed" >> "$LOG"
	}
else
	echo "Already installed: espeak-ng"
	echo "$(log_date) - Already installed: espeak-ng" >> "$LOG"
fi
# flite
if [ $(command -v flite | wc -l) -eq 0 ]; then
	{
		sudo apt install -y --no-install-recommends flite-dev flite
		echo "$(log_date) - Installed: flite" >> "$LOG"
	} || {
		echo "WARNING: flite installation failed - continuing without it"
		echo "$(log_date) - WARNING: flite installation failed" >> "$LOG"
	}
else
	echo "Already installed: flite"
	echo "$(log_date) - Already installed: flite" >> "$LOG"
fi
# picoTTS
if [ $(command -v pico2wave | wc -l) -eq 0 ]; then
	{
		sudo apt install -y libttspico-data libttspico0 libttspico-utils
		echo "$(log_date) - Installed: pico2wave" >> "$LOG"
	} || {
		echo "WARNING: picoTTS installation failed - continuing without it"
		echo "$(log_date) - WARNING: picoTTS installation failed" >> "$LOG"
	}
else
	echo "Already installed: pico2wave"
	echo "$(log_date) - Already installed: pico2wave" >> "$LOG"
fi
echo "=========================================="
#
# Display server installation
install_xserver() {
	echo "Installing X11 display server environment (Openbox) ..."
	echo "$(log_date) - Installing app environment (X-Server, Xvfb, Openbox, Chromium, etc.) ..." >> "$LOG"
	# NOTE: using xserver-xorg-core instead of xserver-xorg meta-package to avoid pulling in
	# xserver-xorg-video-fbdev which conflicts with vc4-kms-v3d on Pi 5
	# old: sudo apt install -y --no-install-recommends xserver-xorg x11-xserver-utils xinit openbox xvfb xterm xinput xdg-utils
	sudo apt install -y --no-install-recommends \
		xserver-xorg-core \
		xserver-xorg-input-all \
		xserver-xorg-legacy \
		x11-xserver-utils \
		xinit \
		openbox \
		xvfb \
		xterm \
		xinput \
		xdg-utils
	# Copy Openbox autostart
	mkdir -p ~/.config/openbox
	echo "$(log_date) - Copying Openbox autostart to ~/.config/openbox/autostart" >> "$LOG"
	cp openbox ~/.config/openbox/autostart
}

install_wayland() {
	echo "Installing Wayland display server environment (labwc) ..."
	echo "$(log_date) - Installing app environment (Wayland, labwc, Chromium, etc.) ..." >> "$LOG"
	sudo apt install -y --no-install-recommends \
		labwc \
		xvfb \
		xterm \
		xdg-utils \
		wlr-randr
	# Set DISPLAY_MODE in on-login.sh
	echo "$(log_date) - Setting DISPLAY_MODE=wayland in on-login.sh ..." >> "$LOG"
	sed -i 's/^DISPLAY_MODE="xserver"/DISPLAY_MODE="wayland"/' ~/sepia-client/on-login.sh
	# Copy labwc autostart
	mkdir -p ~/.config/labwc
	echo "$(log_date) - Copying labwc autostart to ~/.config/labwc/autostart" >> "$LOG"
	cp labwc-autostart ~/.config/labwc/autostart
	chmod +x ~/.config/labwc/autostart
	# Copy labwc config
	echo "$(log_date) - Copying labwc rc.xml to ~/.config/labwc/rc.xml" >> "$LOG"
	cp labwc-rc.xml ~/.config/labwc/rc.xml
	# Copy labwc environment
	echo "$(log_date) - Copying labwc environment to ~/.config/labwc/environment" >> "$LOG"
	cp labwc-environment ~/.config/labwc/environment
}

echo "Installing display server: $DISPLAY_MODE ..."
echo "$(log_date) - Installing display server: $DISPLAY_MODE ..." >> "$LOG"
if [ "$DISPLAY_MODE" = "wayland" ]; then
	install_wayland
else
	install_xserver
fi
#
# Chromium
echo "$(log_date) - Installing Chromium ..." >> "$LOG"
# NOTE: 'chromium' is the default package but in the past it had graphic glitches :-/. In this case you might need to try the old 'chromium-browser'
# TODO: check graphic glitches
if [ -n "$(command -v chromium)" ]; then
	echo "Already installed: chromium"
	echo "$(log_date) - Already installed: chromium" >> "$LOG"
elif [ -n "$(command -v chromium-browser)" ]; then
	echo "Already installed: chromium-browser"
	echo "$(log_date) - Already installed: chromium-browser" >> "$LOG"
else
	sudo apt install -y --no-install-recommends chromium
fi
echo "$(log_date) - If you're having trouble with the current version of Chromium try: 'bash install_chromium_92_from_archive.sh'" >> "$LOG"
if [ $(sudo apt-cache search unclutter | grep ^unclutter-xfixes | wc -l) -eq 0 ]; then
	sudo apt install -y --no-install-recommends unclutter
else
	sudo apt install -y --no-install-recommends unclutter-xfixes unclutter-startup
fi
# Some fixes:
# - GTK3 for chromium
if [ $(sudo apt-cache search libgtk-3-0t64 | wc -l) -eq 0 ]; then
	sudo apt install -y --no-install-recommends libgtk-3-0
else
	sudo apt install -y --no-install-recommends libgtk-3-0t64
fi
# - pulseaudio was needed in the past to fix Chromium IPC semaphore errors (probably resolved as it is working with ALSA on RPI OS 13)
sudo apt install -y --no-install-recommends upower pulseaudio pulsemixer
mkdir -p ~/sepia-client/chromium
mkdir -p ~/sepia-client/chromium-extensions
cp sepia-client/* ~/sepia-client/
#
# Auto-login setup
echo "$(log_date) - Setting up auto-login ..." >> "$LOG"
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
# Node.js installer - currently we need at least 20.19.0 for CLEXI (GPIO, BLE etc.)
install_nodejs() {
	local min_version="20.19.0"
	local install_major="22"
	if [ -n "$(command -v node)" ] && [ -n "$(command -v npm)" ]; then
		if check_version "$(node -v)" "$min_version"; then
			echo "Found Node.js $(node -v) - OK"
			echo "$(log_date) - Skipped: Found Node.js: $(node -v), npm: $(npm -v)" >> "$LOG"
			return 0
		else
			echo "Found Node.js $(node -v) but need >=${min_version} - upgrading via NodeSource ..."
			echo "$(log_date) - Node.js $(node -v) too old, upgrading via NodeSource ..." >> "$LOG"
		fi
	else
		local apt_version=$(apt-cache policy nodejs | grep Candidate | grep -oP '\d+[.]\d+[.]\d+' | head -1)
		if [ -n "$apt_version" ] && check_version "$apt_version" "$min_version"; then
			echo "Installing Node.js ${apt_version} via apt ..."
			echo "$(log_date) - Installing Node.js ${apt_version} via apt ..." >> "$LOG"
			sudo apt install -y nodejs npm || return 1
			echo "$(log_date) - Installed Node.js: $(node -v), npm: $(npm -v)" >> "$LOG"
			return 0
		else
			echo "apt has Node.js ${apt_version:-unknown} - need >=${min_version}, using NodeSource ..."
			echo "$(log_date) - apt Node.js too old (${apt_version:-unknown}), installing via NodeSource ..." >> "$LOG"
		fi
	fi
	curl -fsSL https://deb.nodesource.com/setup_${install_major}.x | sudo -E bash - || return 1
	sudo apt install -y nodejs || return 1
	echo "$(log_date) - Installed Node.js: $(node -v), npm: $(npm -v)" >> "$LOG"
}
# run installer
install_nodejs || {
	echo "WARNING: Node.js installation failed"
	echo "$(log_date) - WARNING: Node.js installation failed" >> "$LOG"
}
#
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
	sudo apt install -y bluetooth bluez libbluetooth-dev libudev-dev libgpiod-dev libnss3-tools libcap2-bin openssl
else
	# Skip Bluetooth
	echo "$(log_date) - Installing required packages skipping Bluetooth ..." >> "$LOG"
	sed -ri "s|\"node-beacon-scanner\".*||" package.json
	sudo apt install -y libudev-dev libgpiod-dev libnss3-tools libcap2-bin openssl
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
	sudo apt install -y nginx
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
echo "$(log_date) - DONE" >> "$LOG"
echo "=========================================="
echo "Summary:"
cat "$LOG"
echo "=========================================="
echo "Installation log: $LOG"
echo ""
echo "If the installation was successful, please reboot your device first, then go to"
echo "'$HOME/sepia-client/' and run 'bash setup.sh'."
echo ""
echo "NOTE: Headless clients can be started using the 'run.sh' script, but for other setups"
echo "(display, pseudo-headless) please make sure that your OS uses the automatic login"
echo "(sudo raspi-config -> system options -> auto-login) to always start 'kiosk' mode after boot."
echo ""
echo "When the client is loading you should hear a voice saying 'just a second' followed"
echo "by 'ready for setup' after the start-up was completed. Then you can use the touchscreen"
echo "or the SEPIA Control HUB (headless mode) to log in and enjoy your new SEPIA Client :-)"
