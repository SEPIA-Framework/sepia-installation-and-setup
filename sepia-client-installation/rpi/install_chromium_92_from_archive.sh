#!/bin/bash
set -e
echo "This script will try to install Chromium 92 for Raspberry OS from 'archive.raspberrypi.org'."
echo "Use it if you're having problems with newer versions (95 etc.)."
echo ""
read -p "Press any key to continue (or CTRL+C to abort)."
echo ""
mkdir -p chromium-deb-files
cd chromium-deb-files
PLATFORM=""
VERSION=""
if [ $(cat /etc/debian_version) -lt 11 ]; then
	VERSION="92.0.4515.98~buster-rpt2"
else
	VERSION="92.0.4515.98-rpt2"
fi
if [ -n "$(uname -m | grep aarch64)" ]; then
	PLATFORM="arm64"
elif [ -n "$(uname -m | grep armv7l)" ]; then
	PLATFORM="armhf"
else
	echo "Please use an ARM 32bit or 64bit OS."
	exit 1
fi
if [ $(command -v chromium-browser | grep chromium-browser | wc -l) -gt 0 ]; then
	echo "Removing old version ..."
	sudo apt-get purge chromium-browser
	echo ""
fi
echo "Downloading Chromium .deb files ..."
echo "PLATFORM: $PLATFORM"
echo "VERSION: $VERSION"
echo ""
URL="https://archive.raspberrypi.org/debian/pool/main/c/chromium-browser"
#https://archive.raspberrypi.org/debian/pool/main/c/chromium-browser/?C=M;O=A
FILE1="chromium-browser_${VERSION}_${PLATFORM}.deb"
FILE2="chromium-chromedriver_${VERSION}_${PLATFORM}.deb"
FILE3="chromium-codecs-ffmpeg_${VERSION}_${PLATFORM}.deb"
FILE4="chromium-codecs-ffmpeg-extra_${VERSION}_${PLATFORM}.deb"
FILE5="chromium-browser-l10n_${VERSION}_all.deb"
if [ ! -f "$FILE1" ]; then
	wget "${URL}/${FILE1}"
fi
if [ ! -f "$FILE2" ]; then
	wget "${URL}/${FILE2}"
fi
if [ ! -f "$FILE3" ]; then
	wget "${URL}/${FILE3}"
fi
if [ ! -f "$FILE4" ]; then
	wget "${URL}/${FILE4}"
fi
if [ ! -f "$FILE5" ]; then
	wget "${URL}/${FILE5}"
fi
echo ""
echo "Installing Chromium $VERSION for $PLATFORM ..."
echo ""
sudo dpkg -i "$FILE4"
sudo dpkg -i "$FILE1"
chromium-browser --version | grep -Eo "Chromium.*"