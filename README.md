# Installation + Setup Tools and Bundles

This repository includes instructions, scripts, tools and files to install, setup and run SEPIA on Windows, Mac, Raspian (Raspberry Pi) and other Linux systems.  
You can choose one of the release packages below to get right into the game :-)  

Downloads can be found on the release page: https://github.com/SEPIA-Framework/sepia-installation-and-setup/releases  
For the source code of every component in a bundle please browse the project page: https://github.com/SEPIA-Framework

# SEPIA-Home - SEPIA Framework release bundle for private home server

This bundle includes everything you need to get started with the SEPIA-Framework and your own, personal, open-source voice-assistant on Windows, Mac and Linux.  
NOTE: Setup and scripts included in this bundle assume you are using the framework with default settings (server ports etc.) in "custom" mode.

## Quick start
  
If you are using Raspian for Raspberry Pi check out the more detailed [guide](https://github.com/SEPIA-Framework/sepia-docs/wiki/Installation#raspberry-pi-3) including a help script.  
  
* Make sure you have at least Java 8 installed (tested extensively with [Oracle Java 8](http://www.oracle.com/technetwork/java/javase/downloads/index.html) but OpenJDK 8+ should work as well)
* Optionally update your local clock for precise timers (Linux), e.g.: with `sudo apt-get install ntpdate` and `sudo ntpdate -u ntp.ubuntu.com`
* Place the content of the SEPIA-Home bundle in any folder you like. On Linux "~/SEPIA/" is recommended (`unzip SEPIA-Home.zip -d ~/SEPIA`) if you want to use the scripts to setup a web-server later.
* Run `setup.bat` (Windows) or `bash setup.sh` (Mac, Linux) to setup your SEPIA servers
* Inside the setup choose 4 to start Elasticsearch and then 1 to setup the SEPIA-Framework. Remember the passwords you set! You can skip the other options for now.
* If everything worked out (check console for errors) you can use "run-sepia" (.bat for Windows, .sh for Linux/Mac) to start all servers
* Check with test-cluster.bat/test-cluster.sh if everything started as planned. If not check sepia-*/log.out for errors.
* You should be able to reach the web-app of SEPIA via: http://localhost:20721/app/index.html (or the server IP instead of 'localhost').
* If your browser is not on the same machine replace 'localhost' (similar to the previous step) in the hostname field during login with the IP of your server (e.g. localhost -> 192.168.0.10).
* For testing purposes (only!) you can use the admin-acount to log-in, by default the ID is "admin@sepia.localhost" or "uid1003" (don't use the "assistant" account). The password has been set during setup.
  
NOTE: Using the web-app via "localhost" will limit the functionality of some features like the speech-recognition, geo-location and notifications due to security reasons (browser restriction, requires HTTPS to work).
See "Next steps" below for further instructions on how to setup your own HTTPS web-server.

## Next steps

If your local tests worked well it is time to create your own (non-admin) account and scale up your server to make sure your it can be reached from outside your private network.
Creating your own web-server with SSL encryption will also make sure that you can use all features of the app without problems.

* To create new users use the SEPIA admin/developer tools page: http://localhost:20721/tools/index.html (registration via e-mail is possible but not fully implemented in the client yet in v2.0.0).
* On the "Authentication" page choose "LOCAL-HOST-20721" as server and login with your admin account.
* Go to "User-Management", choose an email (can be fake, but a real address could come in handy later for password reset etc.) then press "put on whitelist", add a password and finally press "create". Note the message at the bottom indicating your new ID.
* You should now be able to log-in with your new account (use the ID received during "create" or the email you chose).
* To upgrade you local server to a full-blown web-server with SSL we recommend to use [Nginx](https://de.wikipedia.org/wiki/Nginx) (or the integrated SEPIA-Proxy) and [Letsencrypt](https://letsencrypt.org/). There are some scripts included in the release bundle to make your life easier, to get started check the Wiki entry [here](https://github.com/SEPIA-Framework/sepia-docs/wiki/SSL-for-your-Server).
* If you want to get started quickly (2min) without any additional configuration you can use the included SEPIA Reverse-Proxy (Java) and a neat little tool called "ngrok" to create a temporary, secure web-server:
  * Download and extract ngrok for your OS: https://ngrok.com/download
  * Start the SEPIA Reverse-Proxy with one of the scripts inside the "sepia-reverse-proxy"-folder
  * Call `./ngrok http 20726` (or `.\ngrok.exe http 20726` in Windows) and you will get a HTTPS URL for your SEPIA server
  * Use this URL as hostname ([your-ngrok-url]/sepia) in your SEPIA web-app: [your-ngrok-url]/sepia/assist/app/index.html (or in the official, public web-app: https://sepia-framework.github.io/app/index.html)
* TO BE CONTINUED ...

## Build-your-own release (for experts)

Since everything in SEPIA is open-source you can always build the whole framework from scratch using the Github repositories.
A first draft of the requirements to do so can be found [here](https://github.com/SEPIA-Framework/sepia-docs/wiki/Requirements).  
  
There is a [Dockerfile](https://github.com/SEPIA-Framework/sepia-installation-and-setup/blob/master/Dockerfile) that describes all steps to build SEPIA-Home (custom bundle release) on Debian9 (tested with amd64).  
There is also a build script doing the same (and even a bit more, except installing Java). You can run it in Linux (needs sudo):  
```
wget https://raw.githubusercontent.com/SEPIA-Framework/sepia-installation-and-setup/master/build_sepia_home_release_apt.sh
sudo bash build_sepia_home_release_apt.sh
```
You can also build the dev branch if you want to test the latest changes (may have more bugs or other issues ^^):  
```
sudo bash build_sepia_home_release_apt.sh dev
```
You will get a ZIP-file in the end with the new release build (as well).

## Version history

### v2.1.3 - 2018.12.16

Updated client to v0.15.2 with following changes:
* Added drag & drop module and applied it to shopping and to-do list for sorting (activate via long-press on item check-button)
* Added 3-states support for to-do lists (similar to Kanban-cards: open/in-progress/done)
* Updated to-do/shopping list design and list context-menu in general
* Updated tutorial with new list features and generally more info
* Added a help and support button to settings menu (pointing to SEPIA docs page)
* Improved alarms during AlwaysOn-mode
* Introduced smart-microphone toggle (enable in settings) that auto-activates mic on voice based questions (beta)
* Added new skins 'Study', 'Odyssey1', 'Odyssey2', 'Professional' (with less rounded corners ^^), reworked 'NeoSepiaDark' and changed old one to 'Malachite', updated 'Grid' and tweaked other styles
* Fixed some bugs in GPS event handling
* Improved handling of large lists to show them more often in 'big-results'-view and sorted time-events by date
* Split Alarms/Timers button in shortcuts into 2 buttons
* Introduced upper limit for maximal visible chat entries (to improve performance)
* Added mood indicator to AlwaysOn-mode avatar (mouth angle ^_^)
* Improved hotkeys/gamepad config menu
* Reworked AudioRecorder module to support different recorder types
* Introduced new WakeTriggers module and added new config options (e.g. (dis)allow remote hotkey)
* Improved file reader to handle array-buffers so that we can import WebAssembly code
* Added Porcupine JS wake-word tool as 'xtension' and beta-test view to experiment with 'Hey SEPIA' (access from settings)
* Added embedded module with (very) basic offline NLU and services (currently only used for demo-mode e.g. to load a demo list)
* Updated demo mode with offline custom buttons
* Fixed a bug that crashed app when a Bluetooth devices was (dis)connected
Updated Assist-server to v2.1.4:
* Read more than 10 lists with one request (handle paging in service)
* Improved lists NLU ('show me my A and B lists'), radio NLU ('play radio with songs of BAND'), time/date and location parameters
* Updated news-outlets, Wired Germany will close down end of 2018 :-(
Other changes:
* Improved installation scripts

### v2.1.2 - 2018.11.xx (internal version)

Updated client to v0.14.3 with some nice upgrades, e.g.:
* Define custom button for your own commands via the Teach-UI
* Add music stream commands via Teach-UI
* Always-On view with animated avatar and controls (beta)
* Power-events e.g. open AO-mode on power plugin
* Gamepad and hotkey support for remote microphone trigger and other controls (beta)
* Design update of quick-access menu (bottom left) and additional smaller changes (skins etc.)
* Fixed bug where radio won't turn off via voice
* Fixed a bug that prevented timer stop via voice
* Many smaller fixes
Other changes:
* Teach-server update to v2.0.2 with custom buttons support for personal commands
* Assist-server update to v2.1.3 with reworked radio stations (external, curated file), time/date answers and fixes
* Admin-Tools support for server URL parameters
* Added server backup script (Unix) and updated Windows setup and run
* Fixed a UTF-8 encoding bug for Windows

### v2.1.0a - 2018.10.26

Updated assist-server to v2.1.0 with numerous improvements, e.g.:
* Added smart home NLU, parameters (device, room) and service BETA via openHAB integration (currently testing Hue lights)
* Updated news service and exported the hard-coded outlet data to external .json file for easier editing and fixing
* Updated Bundesliga soccer service with data of new season
* Updated and improved setup scripts (e.g. for admin password reset)
* Fixes in NLU and parameter extractions (e.g. for location parameter)
* Improved handling of internal error with proper client message
Other changes:
* Upgraded dependencies, mainly: Java Spark (2.5.4 -> 2.8.0) and Jetty Server (9.3 -> 9.4)
* Updated SEPIA Reverse-Proxy to use external properties file and added some features
* Added new menues to Admin-Tools (e.g. smart home configuration and speech recognition)
* Many smaller bugfixes

### v2.0.1a - 2018.07.07

* Updated assist-server to v2.0.1 (smaller bugfixes)
* Added SEPIA Reverse-Proxy, a tiny JAVA proxy for the custom-bundle. This will save you the installation of a 3rt-party proxy and it works well with ngrok ;-)
* Updated SEPIA HTML client to v0.11.4 (better hostname handling)
* Updated core-tools to v2.0.1 and replaced 'connection-check.jar' with 'sepia-core-tools-*.jar connection-check'

### v2.0.0a - 2018.07.02

First public, open-source release of SEPIA-Framework 2.0 (v1 was proprietary software).
