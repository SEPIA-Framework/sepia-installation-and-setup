#!/bin/bash
# This should work for any WM8960 board (ReSpeaker (2 and 4 mic HAT), Waveshare Audio-HAT, Adafruit Voice Bonnet, etc.)
sudo apt-get update
sudo apt-get install -y git
git clone https://github.com/respeaker/seeed-voicecard
cd seeed-voicecard
#sed -i 's/^FORCE_KERNEL=.*/FORCE_KERNEL="1.20190925-1"/' install.sh
sudo ./install.sh
