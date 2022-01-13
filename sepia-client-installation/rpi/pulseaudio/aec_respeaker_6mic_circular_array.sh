#!/bin/bash
# check: ~/install/seeed-voicecard/pulseaudio/README.md for Pulseaudio configs

# masters - use: 'pactl list short sources' and 'pactl list short sinks' to get names
source_master=alsa_input.platform-soc_sound.seeed-8ch
sink_master=alsa_output.platform-soc_sound.seeed-2ch

# names
source_name=input.aec_source
sink_name=output.aec_sink

# properties
source_properties=device.description=$source_name
sink_properties=device.description=$sink_name

# other options
#aec_method='speex'
aec_method='webrtc'
#aec_method='null'
aec_args='"beamforming=1 mic_geometry=-0.045,0,0,-0.0225,0.039,0,0.0225,0.039,0,0.045,0,0,0.0225,-0.039,0,-0.0225,0.039,0 target_direction=0,0,0 voice_detection=1 noise_suppression=1 analog_gain_control=0"'
#aec_args='"voice_detection=0 noise_suppression=0 target_direction=0,0,0"'

# load the module
pactl unload-module module-echo-cancel
pactl load-module module-echo-cancel \
  source_name=$source_name \
  source_master=$source_master \
  source_properties=$source_properties \
  sink_name=$sink_name sink_master=$sink_master \
  sink_properties=$sink_properties \
  aec_method=$aec_method \
  aec_args=$aec_args
#  use_master_format=1 \
#  channels=1 \

#pactl set-default-source $source_name
#pactl set-default-sink $sink_name