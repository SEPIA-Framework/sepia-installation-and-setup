# Installation + Setup Tools and Bundles

This repository includes instructions, scripts, tools and files to install, setup and run SEPIA on Windows, Mac, Raspian (Raspberry Pi) and other Linux systems.  
You can choose one of the release packages below to get right into the game :-)  

Downloads can be found on the release page: https://github.com/SEPIA-Framework/sepia-installation-and-setup/releases  
For the source code of every component in a bundle please browse the project page: https://github.com/SEPIA-Framework

# SEPIA Framework - Custom release bundle

This bundle includes everything you need to get started with the SEPIA-Framework and your own, personal, open-source voice-assistant on Windows, Mac and Linux.
NOTE: Setup and scripts included in this bundle assume you are using the framework with default settings (server ports etc.) in "custom" mode.

## Quick start

* Make sure you have Oracle Java 1.8 installed: http://www.oracle.com/technetwork/java/javase/downloads/index.html
* Place the content of this package in any folder you like. On Linux "~/SEPIA/" is recommended if you want to use the scripts to setup a web-server later.
* Run setup.bat (Windows) or setup.sh (Mac, Linux) to setup your SEPIA servers
* In the setup choose 4 to start Elasticsearch and then 1 to setup the SEPIA-Framework. Remember the passwords you set! You can skip the other options for now.
* If everything worked out (check console for errors) you can use run-sepia.bat/run-sepia.sh to start all servers
* Check with test-cluster.bat/test-cluster.sh if everything started as planned. If not check sepia-*/log.out for errors.
* You should be able to reach the web-app of SEPIA via: http://localhost:20721/app/index.html (you can use your local network IP as well instead of 'localhost'). Works best with Chrome or Chromium browser.
* For testing purposes (only!) you can use the admin-acount to log-in, by default the ID is "admin@sepia.localhost" or "uid1003" (don't use the "assistant" account). The password has been set during setup.

NOTE: Using the web-app via "localhost" will limit the functionality of some features like the speech-recognition, geo-location and notifications due to security reasons (browser restriction, requires HTTPS to work).

## Next steps

If your local tests worked well it is time to create your own (non-admin) account and scale up your server to make sure your it can be reached from outside your private network.
Creating your own web-server with SSL encryption will also make sure that you can use all features of the app without problems.

* To create new users use the SEPIA admin/developer tools page: http://localhost:20721/tools/index.html (registration via e-mail is possible but not fully implemented in the client yet in v2.0.0).
* On the "Authentication" page choose "LOCAL-HOST-20721" as server and login with your admin account.
* Go to "User-Management", choose an email (can be fake, but a real address could come in handy later for password reset etc.) then press "put on whitelist", add a password and finally press "create". Note the message at the bottom indicating your new ID.
* You should now be able to log-in with your new account (use the ID received during "create" or the email you chose).
* To upgrade you local server to a full-blown web-server with SSL we recommend to use Nginx (https://de.wikipedia.org/wiki/Nginx) and Letsencrypt. There are some scripts included to make your life easier but a detailed tutorial is in preparation.
* If you want to get started quickly (2min) without any additional configuration you can use the SEPIA Java reverse-proxy and a neat little tool called "ngrok" to create a temporary, secure web-server:
  * Download and extract ngrok for your OS: https://ngrok.com/download
  * Start the SEPIA reverse-proxy with one of the scripts inside the "sepia-reverse-proxy"-folder
  * Call `./ngrok http 20726` (or '.\ngrok.exe http 20726' in Windows) and you will get a HTTPS URL for your SEPIA server
  * Use this URL as hostname ([your-ngrok-url]/sepia) in your SEPIA web-app: [your-ngrok-url]/sepia/assist/app/index.html (or in the official, public web-app: https://sepia-framework.github.io/app/index.html)
* TO BE CONTINUED ...

## Version history

### v2.0.1a - 2018.07.07

* Updated assist-server to v2.0.1 (smaller bugfixes)
* Added SEPIA Reverse-Proxy, a tiny JAVA proxy for the custom-bundle. This will save you the installation of a 3rt-party proxy and it works well with ngrok ;-)
* Updated SEPIA HTML client to v0.11.4 (better hostname handling)
* Updated core-tools to v2.0.1 and replaced 'connection-check.jar' with 'tools-*.jar connection-check'

### v2.0.0a - 2018.07.02

First public, open-source release of SEPIA-Framework 2.0 (v1 was proprietary software).
