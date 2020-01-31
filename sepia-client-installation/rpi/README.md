# SEPIA Client Installation

## Raspberry Pi - Raspian Buster - USB Mic - Speakers via audio jack

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
* wget https://github.com/SEPIA-Framework/sepia-installation-and-setup/raw/dev/sepia-client-installation/sepia_client_rpi_raspbian_buster.zip (TODO: REPLACE WITH MASTER)
* unzip sepia_client_rpi_raspbian_buster.zip
* bash install_sepia_client.sh
* bash install_usb_mic.sh
* reboot the system
* continue setup in SEPIA Control HUB's client connections page
* CLEXI server should be reachable at `ws://[rpi-IP]:9090/clexi` (via Nginx)

## Raspberry Pi - Raspian Buster - ReSpeaker 2 Mic HAT - Speakers via ReSpeaker audio jack

Identical to USB Mic version just run the ReSpeaker installation first and DON'T use 'install_usb_mic.sh' ;-) :
* bash install_respeaker_mic.sh
* mkdir ...
* ...
* bash update_respeaker_boot.sh
* reboot the system
* ...
