# SEPIA Client Installation - Raspberry Pi

## Common Instructions

Tested with Raspberry Pi OS Buster (recommended) and Bullseye on RPi4 B 2GB and 4GB.  
Works on RPi3 1GB and maybe even on RPi Zero 512GB if wake-word and display are disabled.

### 1) Install Raspberry Pi OS Lite

* Download the official [Raspberry Pi Imager](https://www.raspberrypi.com/software/) and start it
* Choose Raspberry Pi OS Lite (from 'other' menu) - Currently recommended: **32Bit Buster ('Legacy')**
* Press 'Ctrl + Shift + X' to open Imager expert settings
* Activate SSH (required), set your time zone (important for timers) and optionally configure Wifi, hostname, etc.
* Flash the SD card
* Eject the Micro-SD and plug it into your RPi
* Connect to your RPi via SSH (in Windows you can use [putty](https://www.putty.org/)) with the username and password previously set

### 2a) SEPIA Client Installation

* Connect your hardware to the RPi (USB mic, ReSpeaker HAT, Hyperpixel touchscreen, etc.)
* To help with the setup download the RPi client script: `wget https://sepia-framework.github.io/install/sepia-client-rpi.sh`
* Run the script `bash sepia-client-rpi.sh` (use the `dev` argument if you want the latest, experimental version)
* Go to the new folder `cd ~/install`
* If you have hardware like a ReSpeaker mic HAT or Hyperpixel touchscreen etc. consider to run step "2b) Install Hardware" (see below) first
* Run `bash menu.sh` or `bash menu.sh dev` (latest, experimental version) to open the installation helper
* Choose your installation method (skip Bluetooth if you are not planning to use any BLE devices)
* **Reboot** the system

### 2b) Install Hardware (optional)

Use `bash menu.sh` to choose a specific hardware installation script or run them manually. Here you'll find a few more tips:

* **USB microphone** and the audio jack for sound:
  * `pulsemixer` should be enough to set up your devices.
  * Alternatively try `bash install_usb_mic.sh` and check the audio settings via `sudo raspi-config`
* For **WM8960 microphone boards** like ReSpeaker (2 and 4 mic HAT), Waveshare Audio-HAT, Adafruit Voice Bonnet:
  * Install drivers: `bash install_respeaker_mic.sh`
  * **Reboot** the system and check settings via `pulsemixer`
* For **Hyperpixel** touchscreen:
  * Install drivers: `curl https://get.pimoroni.com/hyperpixel4 | bash`
  * **Reboot** the system
  * If you have problems with the touchscreen (swapped axis etc.) run `bash update_hyperpixel4_boot.sh`
* There are more hardware scripts available in the 'install' folder
* Tweak for small displays to fix Chromium "bug" (use AFTER step "2a SEPIA Client Installation" is finished):
  * If your screen width is smaller than 500px, e.g. 480px (typical Hyperpixel width) you can use `bash adapt_to_small_screen.sh 20` to shift the screen by 20px

### 3) Run SEPIA Client Setup

* Run `bash setup.sh` from the `~/sepia-client` folder
* Select your mode: 'display' (manual setup), 'headless' (no display, auto-setup) or 'pseudo-headless' (auto-setup but keep using display)
* Set SEPIA server host address (as you would inside your SEPIA app login box)
* Optional: Define a unique device ID (default is 'o1', Android apps have 'a1' and browsers 'b1' by default)
* Optional: Define a new CLEXI-ID (this can be used as password for the remote terminal later, default is: clexi-123)
* Optional: Set input/output volume (via `pulsemixer` if Pulseaudio is active or `alsamixer` if not)
* Finish your setup by setting automatic login via `sudo raspi-config` (Boot options - Desktop/CLI - Console Autologin)
* **Reboot** your system 
* Your headless client should automatically start and notify you via a short audio message that he'll be "right there"

### 4) Configure the (headless) Client via Remote Connection

* Continue the setup in your [SEPIA Control HUB](https://github.com/SEPIA-Framework/sepia-admin-tools/tree/master/admin-web-tools) by opening the 'client connections' page. Make sure to use the HTTP address (not HTTPS) to avoid mixed-content errors due to the 'ws://' URL below!
* The CLEXI server of your newly installed SEPIA Client should be reachable at `ws://[rpi-IP]:9090/clexi` (via Nginx proxy)
* Enter your CLEXI-ID from the previous step (or use the default) and press the 'CONNECT' button. The remote terminal window at the bottom will show the status of the connection.
* By default your headless client will start the 'setup mode'. This might take a while, depending on your RPi model. You should hear the audio message "ready for setup" at some point
* Use the remote terminal to ping all connected clients by typing `ping all` or use the shortcut button right above the terminal input field
* Your SEPIA Client should answer with client info, device ID and a short message. If this is not the case something went wrong during the setup. Try to reboot your RPi and observe your CLEXI connection status.
* Copy the device ID into the field with the same name (right above the shortcut buttons)
* Use the remote terminal command `call login user [user-ID] password [user-pwd]` (message type: 'SEPIA Client') to login your user
* You should see a "login successful" message in the terminal. If not you can use the command `call ping` to see if the client can reach the SEPIA server. Check your "hostname" settings from the previous step (Client Setup) if ping fails
* Use the command `call test` (message type: 'SEPIA Client') or corresponding shortcut button 'test client' to ... test your client. You should hear an acoustic confirmation
* **Reboot** your system one last time to finish the configuration (NOTE: your **microphone** will only have access permission **AFTER the reboot**)
* AFTER the reboot you can connect via CLEXI again to test your microphone. See the "?" help button for examples.

### 5) Fine Tuning

* Optional: Open the settings file located at `~/clexi/www/sepia/settings.js` to tweak your client (e.g. activate "Hey SEPIA" or other wake-words). NOTE: please do this AFTER a successful configuration and reboot (previous step)
* The `settings.js` has many available options. To make life easier you can open the SEPIA client in your browser, configure it there and then go to 'settings -> account' and look for the export button. It will show you a popup with settings that you can copy over to your DIY client.
* There are a few [examples available](https://github.com/SEPIA-Framework/sepia-html-client-app/blob/master/Settings.md) for microphone, wake-word and LED control configuration.
* Done. Enjoy! :-)

## Basic uninstallation steps

There is an `uninstall.sh` script inside the `install/` folder but some things might depend on your specific installation so the easiest way is to simply flash a new image but here is a rough list of the required steps:
* Open the folder `~/sepia-client` and run `shutdown.sh`
* Delete folder `~/sepia-client`
* Delete folder `~/clexi`
* Delete folder `~/.config/openbox` and remove 'openbox' via `sudo apt-get remove openbox`
* Remove (any) Chromium via `sudo apt-get remove chromium chromium-browser`
* Open `~/.bashrc` and remove the SEPIA entry below '# Run SEPIA-Client on login?'
* Delete, check or adjust your ALSA config `~/.asoundrc`
* Remove Nginx config at `/etc/nginx/sites-enabled/sepia-client*` and restart Nginx

Whats left are packages like Node.js, Xserver and hardware related stuff (if you've installed a touchscreen or microphone HAT etc.).
