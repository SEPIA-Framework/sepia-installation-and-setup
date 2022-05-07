#!/bin/bash
echo "This script will try to install RNNoise module for the use with Pulseaudio on Raspberry Pi 4."
read -p "Press any key to continue (or CTRL+C to abort)."
echo ""
sudo apt-get install build-essential cmake
git clone https://github.com/werman/noise-suppression-for-voice
cd noise-suppression-for-voice
#64bit and 32bit?:
cmake -Bbuild -H. -DCMAKE_BUILD_TYPE=Release -DBUILD_VST_PLUGIN=OFF
cd build
make
echo ""
echo "DONE. You should find the plugin file at:"
echo "$(pwd)/bin/ladspa/librnnoise_ladspa.so"
