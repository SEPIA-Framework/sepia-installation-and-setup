#!/bin/bash
#For Pulseaudio config see: ~/install/seeed-voicecard/pulseaudio/README.md
#For echo-cancel module see: https://gitlab.freedesktop.org/pulseaudio/pulseaudio/-/tree/master/src/modules/echo-cancel

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
aec_method='speex'
aec_args='"filter_size_ms=200 frame_size_ms=20 agc=0 denoise=1 dereverb=1 echo_suppress=1 echo_suppress_attenuation=0 echo_suppress_attenuation_active=0"'
#note for speex: attenuation is negative db, filtering needs channels=1
#aec_method='webrtc'
#aec_args='"beamforming=1 mic_geometry=-0.075,0,0,-0.025,0,0,0.025,0,0,0.075,0,0 target_direction=1.57,0,0 voice_detection=0 noise_suppression=0 analog_gain_control=0 digital_gain_control=0 high_pass_filter=0"'
#aec_args='"beamforming=1 mic_geometry=-0.075,0,0,-0.025,0,0,0.025,0,0,0.075,0,0 target_direction=1.57,0,0 voice_detection=0 noise_suppression=1 analog_gain_control=1 digital_gain_control=0 high_pass_filter=1 mobile=1 routing_mode=loud-speakerphone comfort_noise=0"'
#aec_args='"voice_detection=0 noise_suppression=1 analog_gain_control=0 digital_gain_control=0 high_pass_filter=1 mobile=1 routing_mode=loud-speakerphone comfort_noise=0"'
#aec_args='"voice_detection=0 noise_suppression=1 analog_gain_control=0 digital_gain_control=0 high_pass_filter=1 drift_compensation=1"'
#aec_args='"voice_detection=0 noise_suppression=1 analog_gain_control=0 digital_gain_control=0 high_pass_filter=1 drift_compensation=1 intelligibility_enhancer=1 extended_filter=0"'
#aec_args='"mobile=1 routing_mode=loud-speakerphone comfort_noise=0"'
#note for webrtc: remove channels and use master format if you want to experiment with beamforming
#aec_method='null'
#aec_args=

# load the module
pactl unload-module module-echo-cancel
pactl load-module module-echo-cancel \
  source_name=$source_name \
  source_master=$source_master \
  source_properties=$source_properties \
  sink_name=$sink_name sink_master=$sink_master \
  sink_properties=$sink_properties \
  rate=32000 \
  channels=1 \
  use_master_format=0 \
  aec_method=$aec_method \
  aec_args=$aec_args

#pactl set-default-source $source_name
#pactl set-default-sink $sink_name
