# SEPIA Client Installation - Raspberry Pi

## Common Instructions

### 1) Install Raspbian Buster Lite

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
* Connect via SSH with RPi
* If required finish your RPi setup with `sudo raspi-config` (for headless client set up auto-login after boot later)

### 2) Remote Connection to Client

* After installation of one of the variants below continue setup in SEPIA Control HUB's client connections page
* CLEXI server should be reachable at `ws://[rpi-IP]:9090/clexi` (via Nginx)
* ...

## Variant 1: USB Mic - Speakers via audio jack

Tested with: Raspian Buster, RPi3, RPi4

### Install

* Create installation folder `mkdir -p ~/install` and switch to directory `cd ~/install`
* Download scripts `wget https://github.com/SEPIA-Framework/sepia-installation-and-setup/raw/dev/sepia-client-installation/sepia_client_rpi_raspbian_buster.zip` (TODO: REPLACE WITH MASTER)
* `unzip sepia_client_rpi_raspbian_buster.zip`
* `bash install_sepia_client.sh`
* `bash install_usb_mic.sh`
* Reboot the system
* Remote connect to client via SEPIA Control HUB (see above)

## Variant 2: ReSpeaker 2 Mic HAT - Speakers via ReSpeaker audio jack

Tested with: Raspian Buster, RPi3, RPi Zero

### Install

* Download scripts as described in variant 1 (wget ...)
* Run the ReSpeaker installation first: `bash install_respeaker_mic.sh`
* Continue with variant 1 installation procedure
* DON'T use 'install_usb_mic.sh' at the end ;-)
* Run `bash update_respeaker_boot.sh` to deactivate unused RPi default audio jack
* Reboot the system
* Remote connect to client via SEPIA Control HUB (see above)

## Variant 3: Hyperpixel 4.0 Touchscreen - USB Mic - Speakers via audio jack

Tested with: Raspian Buster, RPi4

### Install

* Install the Hyperpixel touchscreen first: `curl https://get.pimoroni.com/hyperpixel4 | bash`
* Continue with variant 1 installation procedure
* If you have problems with the touchscreen (swapped axis etc.) run `bash update_hyperpixel4_boot.sh`
* Use `bash setup.sh` to switch between 'display' and 'headless' mode
* Remote connect to client via SEPIA Control HUB (see above) or configure system via display/touchscreen
