# SEPIA micro:bit Code and Tools

## Microbit Bluetooth LE Beacon Remote

The BLE remote is a program for the BBC micro:bit to broadcast Eddystone Beacon data on the push of a (or two) buttons.
This can be used to remotely control a SEPIA client using certain Eddystone URLs to carry the control info.  
  
A short demo video can be found on Twitter: [click me](https://twitter.com/sepia_fw/status/1111263680640008192).

### Installation

* Open the web-based microbit editor: https://makecode.microbit.org/#editor
* Drag and drop the `microbit-BLE-Beacon-remote.hex` file into the editor menu to load the program
* Connect your microbit to deploy the code  

### SEPIA Client Settings

* If you are using the DIY client make sure you have installed the CLEXI Bluetooth interface and activated it (via setup)
* Check your app settings for "remote controls" or your 'settings.js' for BLE/Bluetooth options