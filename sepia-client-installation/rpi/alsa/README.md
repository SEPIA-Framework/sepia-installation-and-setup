# ALSA Configuration

This folder contains some examples and tips to configure devices via ALSA.

## Docs to read:

- https://wiki.archlinux.org/title/Advanced_Linux_Sound_Architecture#Set_the_default_sound_card
- https://wiki.archlinux.org/title/Advanced_Linux_Sound_Architecture/Configuration_examples
- https://www.alsa-project.org/main/index.php/Asoundrc
- https://alsa.opensrc.org/Dsnoop

## Where to put the config files

Place the configuration either in `/etc/asound.conf` or `~/.asoundrc`.
Your home folder will have higher priority.

## Simple config

The simplest possible configuration will just set the correct card and done:
```
defaults.pcm.card 2
defaults.ctl.card 2
```

## Detailed config

In this example we explicitly define playback and capture device and use resampling for the mic.

```
#Define the soundcard to use
pcm.snd_card {
    type hw
    card 1
    #card "card ID"
    device 0
}
#Default controls
ctl.!default {
    type hw
    card 1
    #card "card ID"
    device 0
}
# NOTE: to use 'card' IDs check 'aplay -l' and 'cat /proc/asound/card*/id'

#Resampler
pcm_slave.s16_16khz_mono {
    pcm "snd_card"
    format S16_LE
    channels 1
    rate 16000
}

#Default, split for playback and capture
pcm.!default {
    type asym
    playback.pcm {
        type plug
        slave {
            pcm "snd_card"
        }
    }
    capture.pcm {
        type dsnoop
        ipc_key 20721
        slave s16_16khz_mono
    } 
}
```

## Advanced examples

The custom Proto Voice HAT has a more complex config showing the use of plugins and filters:
- https://github.com/SEPIA-Framework/sepia-open-hardware/tree/main/proto-voice-HAT/alsa-config
