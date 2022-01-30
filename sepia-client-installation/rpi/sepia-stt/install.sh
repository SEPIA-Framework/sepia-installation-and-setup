#!/bin/bash
set -e
echo "Installing Linux packages ..."
sudo apt-get update
sudo apt-get install -y python3-pip python3-dev python3-setuptools python3-wheel libffi-dev unzip
echo "Downloading STT-Server ..."
STT_BRANCH=master
git clone --single-branch --depth 1 -b $STT_BRANCH https://github.com/SEPIA-Framework/sepia-stt-server.git
mv sepia-stt-server/src ./server
rm -rf sepia-stt-server
echo "Installing Python requirements ..."
ENGINE="vosk"
echo "Engine: $ENGINE"
PLATFORM=""
WHL_FILE=""
if [ -n "$(uname -m | grep aarch64)" ]; then
	PLATFORM=aarch64
	wget https://github.com/SEPIA-Framework/sepia-stt-server/releases/download/v0.9.5/vosk-0.3.30-py3-none-linux_aarch64.whl
	WHL_FILE="vosk-0.3.30-py3-none-linux_aarch64.whl"
elif [ -n "$(uname -m | grep armv7l)" ]; then
	PLATFORM=armv7l
	wget https://github.com/SEPIA-Framework/sepia-stt-server/releases/download/v0.9.5/vosk-0.3.30-py3-none-linux_armv7l.whl
	WHL_FILE="vosk-0.3.30-py3-none-linux_armv7l.whl"
elif [ -n "$(uname -m | grep x86_64)" ]; then
	PLATFORM=amd64
	wget https://github.com/SEPIA-Framework/sepia-stt-server/releases/download/v0.9.5/vosk-0.3.30-py3-none-linux_x86_64.whl
	WHL_FILE="vosk-0.3.30-py3-none-linux_x86_64.whl"
elif [ -n "$(uname -m | grep armv6l)" ]; then
	echo "Platform: armv6l - NOT SUPPORTED"
	exit 1
else
	echo "Platform: x86_32 - NOT SUPPORTED"
	exit 1
fi
echo "Platform: $PLATFORM"
pip3 install "$WHL_FILE"
cd server
pip3 install -r requirements.txt
#pip3 install cffi fastapi uvicorn[standard] aiofiles vosk
cd ..
echo "Downloading basic models ..."
mkdir -p models
mkdir -p downloads
cd downloads
wget https://github.com/SEPIA-Framework/sepia-stt-server/releases/download/v0.9.5/vosk-model-small-en-us-0.15.zip
wget https://github.com/SEPIA-Framework/sepia-stt-server/releases/download/v0.9.5/vosk-model-small-de-0.15.zip
wget https://github.com/SEPIA-Framework/sepia-stt-server/releases/download/v0.9.5/vosk-model-spk-0.4.zip
unzip vosk-model-small-en-us-0.15.zip && mv vosk-model-small-en-us-0.15 ../models/vosk-model-small-en-us
unzip vosk-model-small-de-0.15.zip && mv vosk-model-small-de-0.15 ../models/vosk-model-small-de
unzip vosk-model-spk-0.4.zip && mv vosk-model-spk-0.4 ../models/vosk-model-spk
cd ..
echo "Downloading Adapt-LM scripts ..."
ADAPT_LM_BRANCH=master
git clone --single-branch --depth 1 -b $ADAPT_LM_BRANCH https://github.com/fquirin/kaldi-adapt-lm.git
#cd kaldi-adapt-lm
#bash 1-download-requirements.sh
#rm *.tar.gz
#cd ..