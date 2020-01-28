#!/bin/bash
sudo apt-get update
sudo apt-get install -y git
git clone https://github.com/respeaker/seeed-voicecard
cd seeed-voicecard
#sed -i 's/^FORCE_KERNEL=.*/FORCE_KERNEL="1.20190925-1"/' install.sh
sudo ./install.sh
