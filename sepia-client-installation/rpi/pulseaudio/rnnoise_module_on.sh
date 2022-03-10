#!/bin/bash

# masters - use: 'pactl list short sources' and 'pactl list short sinks' to get names
source_master=alsa_input.platform-soc_sound.seeed-8ch
sink_master=alsa_output.platform-soc_sound.seeed-2ch

# names and properties
null_sink="rnnoise_out"
null_sink_prop=device.description="rnnoise_out"
mic_sink="mic_proxy"
mic_sink_prop=device.description="mic_proxy"
plug_label="noise_suppressor_mono" #noise_suppressor_stereo"
chan=1 #2
sampler=48000

# load module

# proxy sink 1 - final output
pacmd load-module module-null-sink sink_name=$null_sink sink_properties=$null_sink_prop rate=$sampler

# proxy sink 2 - process mic input and send to proxy sink 1
pacmd load-module module-ladspa-sink \
    sink_name=$mic_sink \
    sink_properties=$mic_sink_prop \
    sink_master=$null_sink \
    label=$plug_label \
    plugin="$HOME/install/pulseaudio/noise-suppression-for-voice/build/bin/ladspa/librnnoise_ladspa.so" \
    control=50

# send raw mic to proxy sink 2
pacmd load-module module-loopback \
    source=$source_master \
    sink=$mic_sink \
    source_dont_move=true \
    sink_dont_move=true \
    channels=$chan

# remap so Chromium can use the "monitor"
pacmd load-module module-remap-source source_name="rnnoise_mic" master="$null_sink".monitor channels=$chan

#pactl set-default-source $source_name
#pactl set-default-sink $sink_name
