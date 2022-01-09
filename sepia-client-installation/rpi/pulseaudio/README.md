# Pulseaudio Audio Enhancements

## Acoustic Echo Cancellation (AEC)

The Pulseaudio AEC module substracts the output channel from the input channel (in a "smart" way) and does additional noise reduction and filtering.  
If the output is loud input will usually be distorted and wake-word detection still doesn't really work well but it will drastically reduce false-positives due to own speaker output.  
Background noise reduction is pretty good as well.

### Beamforming

Microphone arrays can try to combine multiple microphones to enhance audio quality. Depending on your array geometry the effect might be small but its worth a try.  
Geometry parameters for the 'beamforming' property are: x1,y1,z1,x2,y2,z2,... for each microphone with reference to center of array.  
'target_direction' is given as 'a,e,r' where 'a' is the azimuth (radians) of the target point relative to the center of the array, 'e' its elevation, and 'r' the radius in meter.

### Apply effects

Simply choose the 'aec_..' script that fits to your device or use an existing one as template then call for example `bash aec_respeaker_4mic_linear_array.sh`.
The script will load the Pulseaudio module until you restart the device or Pulseaudio daemon. Each script tries to unload the modul beforehand, if this creates an error just ignore it ;-).  
After you ran the script check `pulsemixer` to select the new sink and source and adjust volume.