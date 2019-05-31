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
* The run-script will ping the servers to see if everything started as planned. You can repeat this test with test-cluster.bat/test-cluster.sh to make sure. If you see errors check sepia-*/log.out.
* You should be able to reach the web-app of SEPIA via: http://localhost:20721/app/index.html (or the server IP instead of 'localhost').
* If your browser is not on the same machine replace 'localhost' (similar to the previous step) in the hostname field during login with the IP of your server (e.g. localhost -> 192.168.0.10).
* For testing purposes (only!) you can use the admin-acount to log-in, by default the ID is "admin@sepia.localhost" or "uid1003" (don't use the "assistant" account). The password has been set during setup.
  
NOTE: Using the web-app via "localhost" will (depending on the browser) limit the functionality of some features like the speech-recognition, geo-location and notifications due to security reasons (browser restriction, requires HTTPS to work).
See "Secure server" below for further instructions on how to setup your own HTTPS web-server.

## Next steps

If your local tests worked well it is time to create your own (non-admin) account:

* To create new users use the SEPIA tools page (aka Control-HUB): http://localhost:20721/tools/index.html (registration via 'real' e-mail is possible in theory but not fully implemented in the clients right now).
* Login to the Control-HUB using your admin account. By extending the login-box you can check if the right server is selected it should look like this 'http://localhost:20721' or this 'http://192.168.0.10:20721' for example.
* Open the menu (top-left) and go to the "User Management" page. Choose an email (can be fake, but a real address could come in handy later for password reset etc.) then press "put on whitelist", add a password and finally press "create". Note the message in the result-box indicating your new ID.
* You should now be able to log-in with your new account (use the ID received during "create" or the email you chose).

## Secure server

Creating your own web-server with SSL encryption will make sure that you can use all features of the app without problems and will also make your server reachable from outside your network (e.g. when you're using the mobile app and want to check your shopping-list inside a supermarket).
To upgrade you local server to a full-blown web-server with SSL it is recommended to use [Nginx](https://de.wikipedia.org/wiki/Nginx) or the integrated SEPIA-Proxy and [Letsencrypt](https://letsencrypt.org/). There are some scripts included in the SEPIA-Home release to make your life easier, to get started check the Wiki entry [here](https://github.com/SEPIA-Framework/sepia-docs/wiki/SSL-for-your-Server).  
  
If you want a super-fast (2min), zero-configuration solution you can use the included SEPIA Reverse-Proxy (Java) together with a neat little tool called "ngrok" to create a temporary, secure web-server:
* Download and extract ngrok for your OS: https://ngrok.com/download
* Start the SEPIA Reverse-Proxy with one of the scripts inside the "sepia-reverse-proxy"-folder
* Call `./ngrok http 20726` (or `.\ngrok.exe http 20726` in Windows) and you will get a HTTPS URL for your SEPIA server
* Use this URL as hostname ([your-ngrok-url]/sepia) in your SEPIA web-app: [your-ngrok-url]/sepia/assist/app/index.html (or in the official, public web-app: https://sepia-framework.github.io/app/index.html)
* ***The drawback:*** your ngrok-server will expire after a while (~7h) and you need to manually restart it. In this process your URL will change as well.
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

For a detailed list of updates and new features please see the [CHANGELOG](CHANGELOG.md)
