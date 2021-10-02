#!/bin/bash
#usage examples: 
#bash install_sepia_client.sh dev 			-> CLIENT_BRANCH=dev, 		SKIP_BLE=false
#bash install_sepia_client.sh skipBLE 		-> CLIENT_BRANCH=master, 	SKIP_BLE=true
#bash install_sepia_client.sh dev skipBLE 	-> CLIENT_BRANCH=dev, 		SKIP_BLE=true
set -e
this_folder=$(pwd)
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
#
# Prepare
echo "Preparing installation of SEPIA Client for Raspberry Pi ..."
sudo apt-get update
sudo apt-get install -y git
echo "=========================================="
#
# Voices
echo "Installing TTS voices ..."
sudo apt-get install -y espeak-ng espeak-ng-espeak
sudo apt-get install -y --no-install-recommends flite-dev flite libttspico-data
mkdir -p tmp
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
sudo apt-get install -y --no-install-recommends xserver-xorg x11-xserver-utils xinit openbox xvfb
# NOTE: 'chromium-browser' has been replaced with 'chromium' for now:
sudo apt-get install -y --no-install-recommends chromium unclutter
mkdir -p ~/sepia-client/chromium
mkdir -p ~/sepia-client/chromium-extensions
cp sepia-client/* ~/sepia-client/
mkdir -p ~/.config/openbox
cp openbox ~/.config/openbox/autostart
startfile=~/.bashrc
if grep -q "sepia_run_on_login" $startfile; then
    echo "Found 'sepia_run_on_login' in .bashrc already"
else
	echo '' >> $startfile
	echo '# Run SEPIA-Client on login?' >> $startfile
	echo 'sepia_run_on_login="$HOME/sepia-client/on-login.sh"' >> $startfile
	echo 'if [ -f "$sepia_run_on_login" ]; then' >> $startfile
	echo '    bash $sepia_run_on_login' >> $startfile
	echo 'fi' >> $startfile
fi
echo "=========================================="
#
# CLEXI
echo "Installing Node.js and CLEXI ..."
if is_armv6l;
then
    f=$(wget -qO- https://nodejs.org/download/release/latest-dubnium/ | grep "armv6l.tar.gz" | cut -d '"' -f 2);
    wget -O tmp/nodejs-armv6l-v10.x.tar.gz https://nodejs.org/dist/latest-v10.x/$f
    sudo tar -zxf tmp/nodejs-armv6l-v10.x.tar.gz --strip-components=1 -C /usr
else
    curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi
echo "node.js $(node -v)"
git clone https://github.com/bytemind-de/nodejs-client-extension-interface.git ~/clexi
cp clexi_settings.json ~/clexi/settings.json
# copy additional runtime commands
mkdir -p ~/clexi/runtime_commands
cp runtime_commands/* ~/clexi/runtime_commands/
cd ~/clexi
if [ "$SKIP_BLE" != "true" ]; then
    sudo apt-get install -y bluetooth bluez libbluetooth-dev libudev-dev libnss3-tools libcap2-bin openssl
else
	# Skip Bluetooth
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
mkdir -p ~/clexi/www/sepia
mkdir -p ~/sepia-client/chromium-extensions/sepia-fw
mkdir -p ~/tmp
git clone --single-branch -b $CLIENT_BRANCH https://github.com/SEPIA-Framework/sepia-html-client-app.git ~/tmp/sepia-client-git
git clone --single-branch -b master https://github.com/SEPIA-Framework/sepia-browser-extensions ~/tmp/sepia-client-browser-ex-git
mv ~/tmp/sepia-client-git/www/* ~/clexi/www/sepia/
mv ~/tmp/sepia-client-browser-ex-git/chromium/* ~/sepia-client/chromium-extensions/sepia-fw/
rm -rf ~/tmp/sepia-client-git
rm -rf ~/tmp/sepia-client-browser-ex-git
echo "=========================================="
#
# Nginx
echo "Installing proxy ..."
sudo apt-get install -y nginx
sudo cp sepia-client-nginx.conf /etc/nginx/sites-enabled/
sudo nginx -t
sudo nginx -s reload
echo "=========================================="
echo "DONE!"
echo ""
echo "Please make sure that your Raspberry automatically logs in after reboot (sudo raspi-config -> boot -> Desktop -> ...)"
echo "then reboot the RPi and after a few seconds you should hear a voice saying 'just a second' followed by 'ready for setup' few seconds later."
echo "Now you can use the SEPIA Control HUB to set up your new SEPIA Client :-)"
