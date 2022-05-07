#!/bin/bash
# check: https://gitlab.freedesktop.org/pulseaudio/pulseaudio/-/tree/master/src/modules/echo-cancel for Parameters

# masters - use: 'pactl list short sources' and 'pactl list short sinks' to get names
source_master=alsa_input.platform-soc_sound.multichannel-input
sink_master=alsa_output.platform-soc_sound.multichannel-output

# names
source_name=input.aec_source
sink_name=output.aec_sink

# properties
source_properties=device.description=$source_name
sink_properties=device.description=$sink_name

# other options
aec_method='speex'
aec_args='"filter_size_ms=200 agc=0 denoise=0 dereverb=0 echo_suppress=1 echo_suppress_attenuation=0 echo_suppress_attenuation_active=0"'
#note for speex: attenuation is negative db, filtering needs channels=1
#note 2: on recording speex usually takes around 5s to calibrate ... each time!
#aec_method='webrtc'
#aec_args='"voice_detection=0 noise_suppression=1 analog_gain_control=0 digital_gain_control=0 high_pass_filter=1 drift_compensation=1 intelligibility_enhancer=1 extended_filter=0"'
#aec_args='"mobile=1 routing_mode=loud-speakerphone comfort_noise=0"'
#note for webrtc: remove channels and use master format if you want to experiment with beamforming
#aec_method='null'
#aec_args=

# more stuff to potentially improve performance:
#if [ $(pactl list modules short | grep module-suspend-on-idle | wc -l) -gt 0 ]; then
#	pactl unload-module module-suspend-on-idle
#fi

# load the module
if [ $(pactl list modules short | grep module-echo-cancel | wc -l) -gt 0 ]; then
	pactl unload-module module-echo-cancel
	echo "Pulseaudio: unloaded old instance of 'module-echo-cancel'"
fi
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

pactl set-default-source $source_name
pactl set-default-sink $sink_name
