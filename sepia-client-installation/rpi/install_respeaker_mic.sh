#!/bin/bash
# This should work for any WM8960 board (ReSpeaker (2 and 4 mic HAT), Waveshare Audio-HAT, Adafruit Voice Bonnet, etc.)
echo "This script will install WM8960 boards like ReSpeaker (2 and 4 mic HAT), Waveshare Audio-HAT, Adafruit Voice Bonnet, etc.."
echo "Please follow the instructions precisely!"
echo "The installation may require you to reboot -> install 2nd time (after kernal updates) -> reboot again."
echo ""
read -p "Press any key to continue (or CTRL+C to abort)."
echo ""
sudo apt-get update
sudo apt-get install -y git
git clone https://github.com/respeaker/seeed-voicecard
#or: https://github.com/HinTak/seeed-voicecard
cd seeed-voicecard
DRIVER_FOLDER=$(pwd)
#sed -i 's/^FORCE_KERNEL=.*/FORCE_KERNEL="1.20190925-1"/' install.sh
sudo ./install.sh
echo ""
echo "Some notes:"
echo ""
echo "If you don't see any cards after first reboot (arecord -l) try:"
echo "sudo service seeed-voicecard stop && sudo service seeed-voicecard start && arecord -l"
echo ""
echo "Check out subfolder './pulseaudio' to configure 4mic linear and 6mic devices."
echo ""
echo "Run 'pulsemixer' afterwards and change source setup (F3) to:"
echo "Multichannel Duplex (or your preferred settings)"
echo ""
echo "If that doesn't work try to run the setup once more and repeat the steps:"
echo "cd $DRIVER_FOLDER && sudo ./install.sh"
echo ""
echo "If you keep getting errors try this repository instead (remove the old one):"
echo "git clone https://github.com/HinTak/seeed-voicecard"
echo ""
