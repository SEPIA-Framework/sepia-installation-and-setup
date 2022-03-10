#!/bin/bash
echo "This script will install the Raspiaudio MIC+ HAT with on-board speakers."
echo ""
echo "NOTE: It will download and execute the official script via 'sudo'."
echo ""
read -p "Press any key to continue (or CTRL+C to abort)."
echo ""
sudo wget -O - mic.raspiaudio.com | sudo bash
echo ""
echo "Some notes:"
echo ""
echo "Volume of the mic seems to be very low at least on RPi OS Bullseye."
echo "You might need to set a high gain value via client settings."
echo ""
echo "Run 'pulsemixer' afterwards and change source setup (F3) to:"
echo "Multichannel Duplex"
echo ""

