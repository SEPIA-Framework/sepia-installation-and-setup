#!/bin/bash

# sources
echo "Sources:"
pactl list short sources

# about 220%:
echo "Set both 'multichannel-input' and 'input.aec_source' to ~220%:"
pactl set-source-volume input.aec_source 150000
pactl set-source-volume alsa_input.platform-soc_sound.multichannel-input 150000
echo "If you can't hear anything anymore use lower values!"

# more stuff to potentially improve performance:
#if [ $(pactl list modules short | grep module-suspend-on-idle | wc -l) -gt 0 ]; then
#	pactl unload-module module-suspend-on-idle
#fi