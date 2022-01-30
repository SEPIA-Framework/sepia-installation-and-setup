#!/bin/bash
echo "This script will install the ReSpeaker Mic Array v2.0 tools to change firmware and device settings."
echo "To simply use the USB device you don't need these tools, just double check settings via 'pulsemixer'."
echo ""
echo "To learn how to control the LED array via CLEXI visit:"
echo "https://github.com/SEPIA-Framework/sepia-html-client-app/blob/master/Settings.md"
echo ""
read -p "Press any key to continue (or CTRL+C to abort)."
echo ""
sudo apt-get update
sudo apt-get install -y git
git clone https://github.com/respeaker/usb_4_mic_array.git
sudo pip3 install pyusb click
cd usb_4_mic_array
wget https://raw.githubusercontent.com/respeaker/pixel_ring/master/pixel_ring/usb_pixel_ring_v2.py
echo ""
echo "Some notes:"
echo ""
echo "To switch between firmwares use:"
echo "sudo python3 dfu.py --download 6_channels_firmware.bin"
echo "or:"
echo "sudo python3 dfu.py --download 1_channel_firmware.bin"
echo ""
echo "To show tuning options use:"
echo "python3 tuning.py -p"
echo "Tuning is usually applied using 'sudo'."
echo ""
