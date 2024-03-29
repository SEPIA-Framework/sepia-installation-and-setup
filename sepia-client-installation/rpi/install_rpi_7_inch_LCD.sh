#!/bin/bash
echo ""
echo "Setup for: Official Raspberry Pi 7inch LCD touchscreen"
echo ""
echo "This will fix touch input and other issues. Tested on Raspberry Pi OS Bullseye at 2022.01.07."
echo "Older OS versions (Buster etc.) might work without some of the steps."
echo ""
echo "Please open your '/boot/config.txt' and follow these steps:"
echo ""
echo "Set framebuffer with correct resolution:"
echo ""
echo "framebuffer_width=800"
echo "framebuffer_height=444"
echo "framebuffer_aspect=-1"
echo ""
echo "Replace 'dtoverlay=vc4-kms-v3d' with 'dtoverlay=vc4-fkms-v3d'"
echo ""
echo "Inside your '~/.config/openbox/autostart' enable: 'xrandr --output DSI-1 --scale 1.081x1.0'"
echo "to fix screen ascpect ratio."
echo ""
echo "To control screen brightness (example 140) use:"
echo "sudo sh -c 'echo \"140\" > /sys/class/backlight/rpi_backlight/brightness'"
echo ""
echo "Reboot Pi"
echo ""
