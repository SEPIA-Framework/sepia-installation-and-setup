#!/bin/bash

cd $HOME
mkdir -p sepia-stt
git clone --single-branch --depth 1 -b master https://github.com/SEPIA-Framework/sepia-stt-server.git
mv sepia-stt-server/src sepia-stt/server
rm -rf sepia-stt-server
cd $HOME/sepia-stt

sudo pacman -S python-pip python-setuptools python-wheel libffi
pip3 install cffi fastapi uvicorn[standard] aiofiles
wget https://github.com/alphacep/vosk-api/releases/download/v0.3.32/vosk-0.3.32-py3-none-linux_aarch64.whl
pip3 install vosk-0.3.32-py3-none-linux_aarch64.whl

mkdir -p models
mkdir -p downloads
cd downloads
wget https://github.com/SEPIA-Framework/sepia-stt-server/releases/download/v0.9.5/vosk-model-small-en-us-0.15.zip
wget https://github.com/SEPIA-Framework/sepia-stt-server/releases/download/v0.9.5/vosk-model-small-de-0.15.zip
wget https://github.com/SEPIA-Framework/sepia-stt-server/releases/download/v0.9.5/vosk-model-spk-0.4.zip
unzip vosk-model-small-en-us-0.15.zip && mv vosk-model-small-en-us-0.15 ../models/vosk-model-small-en-us
unzip vosk-model-small-de-0.15.zip && mv vosk-model-small-de-0.15 ../models/vosk-model-small-de
unzip vosk-model-spk-0.4.zip && mv vosk-model-spk-0.4 ../models/vosk-model-spk