#!/bin/bash
# This should work for any WM8960 board (ReSpeaker (2 and 4 mic HAT), Waveshare Audio-HAT, Adafruit Voice Bonnet, etc.)
echo "This script will install WM8960 boards like ReSpeaker (2 and 4 mic HAT), Waveshare Audio-HAT, Adafruit Voice Bonnet, etc.."
echo "Please follow the instructions precisely!"
echo "The installation may require you to reboot -> install 2nd time (after kernal updates) -> reboot again."
echo ""
read -p "Press Enter to continue."
echo ""
sudo apt-get update
sudo apt-get install -y git
git clone https://github.com/respeaker/seeed-voicecard
# If you have issues try: https://github.com/HinTak/seeed-voicecard
cd seeed-voicecard
#sed -i 's/^FORCE_KERNEL=.*/FORCE_KERNEL="1.20190925-1"/' install.sh
sudo ./install.sh
