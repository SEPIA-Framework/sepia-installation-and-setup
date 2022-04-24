#!/bin/bash
REC_TIME=8
if [ ! -z "$1" ]; then
    REC_TIME=$1
fi
echo "This test will record ${REC_TIME}s of 16kHz 16bit LE mono audio."
echo "If you do not hear anything in your recording try 'pulsemixer' to set the right source and volume."
echo "Now recording ..."
NOW=$(date +"%Y_%m_%d_%H-%M-%S")
arecord -f S16_LE -r 16000 -c 1 -d $REC_TIME "test_mono_${NOW}.wav"
echo "DONE"
echo "To play your recording use: aplay test_mono_${NOW}.wav"
