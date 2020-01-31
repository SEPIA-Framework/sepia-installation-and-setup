#!/bin/bash
#parameter 1: SEPIA client git branch (e.g. dev)
set -e
this_folder=$(pwd)
is_armv6l() {
  case "$(uname -m)" in
    armv6l) return 0 ;;
    *) return 1 ;;
  esac
}
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
# Chromium
echo "Installing app environment ..."
sudo apt-get install -y --no-install-recommends xserver-xorg x11-xserver-utils xinit openbox xvfb
sudo apt-get install -y --no-install-recommends chromium-browser
mkdir -p ~/sepia/chromium
mkdir -p ~/.config/openbox
cp openbox ~/.config/openbox/autostart
startfile=~/.bashrc
if grep -q "exec startx" $startfile; then
    echo "Found 'startx' in .bashrc already"
else
    echo "# Autostart X" >> $startfile
    echo 'if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then' >> $startfile
    echo "    exec startx" >> $startfile
    echo "fi" >> $startfile
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
cd ~/clexi
sudo apt-get install -y bluetooth bluez libbluetooth-dev libudev-dev libnss3-tools libcap2-bin openssl
npm install --loglevel error
sudo setcap cap_net_raw+eip $(eval readlink -f `which node`)
cd $this_folder
echo "=========================================="
#
# SEPIA Client
echo "Downloading latest SEPIA Client version ..."
mkdir -p ~/clexi/www/sepia
mkdir -p ~/tmp
if [ -z "$1" ]; then
    git clone https://github.com/SEPIA-Framework/sepia-html-client-app.git ~/tmp/sepia-client-git
else
    git clone --single-branch -b $1 https://github.com/SEPIA-Framework/sepia-html-client-app.git ~/tmp/sepia-client-git
fi
mv ~/tmp/sepia-client-git/www/* ~/clexi/www/sepia/
rm -rf ~/tmp/sepia-client-git
echo "=========================================="
#
# Nginx
echo "Installing proxy ..."
sudo apt-get install -y nginx
sudo cp sepia-client-nginx.conf /etc/nginx/sites-enabled/sepia-fw-http.conf
sudo service nginx reload
echo "=========================================="
echo "DONE!"
echo ""
echo "Please make sure that your Raspberry automatically logs in after reboot (sudo raspi-config -> boot -> Desktop -> ...)"
echo "then reboot the RPi and after a few seconds you should here a voice saying 'just a second' followed by 'ready for setup' few seconds later."
echo "Now you can use the SEPIA Control HUB to set up your new SEPIA Client :-)"
