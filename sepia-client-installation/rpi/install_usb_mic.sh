#!/bin/bash
echo "This script will try to set an USB microphone as default input device via ALSA config."
echo "Before you use it open 'pulsemixer' to check if Pulseaudio can already manage your mic."
echo ""
read -p "Press any key to continue (or CTRL+C to abort)."
echo ""
cp asoundrc_usb_mic ~/.asoundrc
echo "Copied ALSA config to '~/.asoundrc' to set default microphone device to USB."
echo "NOTE: If you experience problems with the new settings you can simply delete the file."
echo "Don't forget to reboot your device later so the changes can take effect."
