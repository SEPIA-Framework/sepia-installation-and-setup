#!/bin/bash
cp asoundrc_usb_mic ~/.asoundrc
echo "Copied ALSA config to '~/.asoundrc' to set default microphone device to USB."
echo "NOTE: This does not work for some setups or might not be required at all. In this case either edit '~/.asoundrc' or simply delete it."
echo "NOTE2: You should check your volume settings via 'alsamixer' as well."
