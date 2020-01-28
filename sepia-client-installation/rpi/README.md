# SEPIA Client Installation

## Raspberry Pi - Raspian Buster - USB Mic

### Install Raspbian Buster Lite

* Download Raspbian Buster
* Flash MicroSD with Etcher
* Remove MicroSD and replug (to reload filesystem)
* Add an empty file called "ssh" to boot partition ([microSD]/boot) to enable SSH
* Add a file called "wpa_supplicant.conf" to boot with content:
```
country=US
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
network={
    ssid="NETWORK-NAME"
    psk="NETWORK-PASSWORD"
}
```
* Eject MicroSD and plug into RPi

### Install SEPIA Client

* connect via SSH with RPi
* if required finish your RPi setup with `sudo raspi-config` (for headless client set up auto-login after boot later)
* create installation folder `mkdir -p ~/install` and switch to directory `cd ~/install`
* wget ...
* unzip ...
* bash ...
* TBD

## Raspberry Pi - Raspian Buster - ReSpeaker 2 Mic HAT

Identical to USB Mic version just run the ReSpeaker installation first:
* wget ...
* bash ...
* TBD
