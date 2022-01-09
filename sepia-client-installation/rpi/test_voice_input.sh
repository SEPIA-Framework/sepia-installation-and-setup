#!/bin/bash
echo "This test will record 8s of 16kHz 16bit LE mono audio."
echo "Now recording ..."
NOW=$(date +"%Y_%m_%d_%H-%M-%S")
arecord -f S16_LE -r 16000 -c 1 -d 8 "test_mono_${NOW}.wav"
echo "DONE"
