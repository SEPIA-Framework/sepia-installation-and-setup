#!/bin/bash
echo "This script will install the IQAudio Pi Codec Zero HAT using the on-board mic and speaker connector."
echo "Please reboot after installation."
echo ""
read -p "Press any key to continue (or CTRL+C to abort)."
echo ""
sudo apt-get update
sudo apt-get install -y git
git clone https://github.com/iqaudio/Pi-Codec.git
cd Pi-Codec
sudo alsactl restore -f IQaudIO_Codec_OnboardMIC_record_and_SPK_playback.state
#DRIVER_FOLDER=$(pwd)
echo ""
echo "Some notes:"
echo ""
echo "After setup (and reboot) check: raspi-config -> system options -> audio"
echo ""
#echo "If no soundcard is found try adding 'dtoverlay=iqaudio-codec' to your /boot/config"
#echo ""
echo "You might need to run 'pulsemixer' afterwards and change source setup (F3) to:"
echo "Multichannel Duplex"
echo ""

