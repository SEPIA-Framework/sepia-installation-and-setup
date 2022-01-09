#!/bin/bash

# masters
source_master=alsa_input.platform-soc_sound.seeed-8ch

# names
source_name=input.mono_source

# properties
source_properties=device.description=$source_name

# load the module
pactl unload-module module-remap-source
pactl load-module module-remap-source \
  master=$source_master \
  source_name=$source_name \
  source_properties=$source_properties \
  master_channel_map=front-left,front-right,rear-left,rear-right,front-center,lfe,side-left,side-right \
  channel_map=mono,mono,mono,mono,mono,mono,mono,mono
  #channels=1
