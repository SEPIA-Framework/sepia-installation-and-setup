# Installation + Setup Tools and Bundles

This repository includes instructions, scripts, tools and files to install, setup and run SEPIA on Windows, Mac, Raspian (Raspberry Pi) and other Linux systems.  
You can choose one of the release packages below to get right into the game :-)  

Downloads can be found on the release page: https://github.com/SEPIA-Framework/sepia-installation-and-setup/releases  
For the source code of every component in a bundle please browse the project page: https://github.com/SEPIA-Framework

# SEPIA-Home - SEPIA Framework release bundle for private home server

This bundle includes everything you need to get started with the SEPIA-Framework and your own, personal, open-source voice-assistant on Windows, Mac and Linux.  
NOTE: Setup and scripts included in this bundle assume you are using the framework with default settings (server ports etc.) in "custom" mode.

## Quick start
  
If you are using Raspian for Raspberry Pi check out the more detailed [guide](https://github.com/SEPIA-Framework/sepia-docs/wiki/Installation) including an installation script.  
  
* Make sure you have at least Java 8 installed (tested extensively with [Oracle Java 8](http://www.oracle.com/technetwork/java/javase/downloads/index.html) and OpenJDK 11 (recommended))
* Optional: Update your local clock for precise timers (Linux), e.g.: with `sudo apt-get install ntpdate` and `sudo ntpdate -u ntp.ubuntu.com`
* Place the content of the [SEPIA-Home bundle](https://github.com/SEPIA-Framework/sepia-installation-and-setup/releases) in any folder you like. On Linux "~/SEPIA/" is (highly) recommended if you want to use the boot and SSL scripts later: `unzip SEPIA-Home.zip -d ~/SEPIA`.
* Run `setup.bat` (Windows) or `bash setup.sh` (Mac, Linux) to setup your SEPIA servers
* Inside the setup choose 4 to start Elasticsearch and then 1 to setup the SEPIA-Framework. Remember the passwords you set! Optionally install the TTS engine (recommended for Linux). You can skip the other options for now.
* If everything worked out (check console for errors) you can use "run-sepia" (.bat for Windows, .sh for Linux/Mac) to start all servers.
* The run-script will ping the servers to see if everything started as planned. You can repeat this test with test-cluster.bat/test-cluster.sh to make sure. If you see errors check sepia-*/log.out.
* You should be able to reach the web-app of SEPIA via one of the URLs suggested at the end of the run-script, e.g.: http://localhost:20721/app/index.html (replace 'localhost' with the server IP if you are on a different machine).
* Extend the now visible login-box to verify the hostname field. The hostname should point to your SEPIA server (e.g. localhost or an IP like 192.168.0.10).
* For testing purposes (only!) you can use the admin-acount to log-in, by default the ID is "admin@sepia.localhost" or "uid1003" (don't use the "assistant" account). The password has been set during setup.
  
NOTE: Using the web-app via local network IPs (except 127.0.0.1 aka localhost) will limit the functionality of some features like the speech-recognition, geo-location and notifications due to security reasons (browser restriction, requires HTTPS to work).
See the "Secure server" section below for further instructions on how to set up your own HTTPS web-server, BUT if you are just using your own local servers there is another solution that will work fine. You can add exceptions 
to your browser as well :-) see [this guide](https://github.com/SEPIA-Framework/sepia-docs/wiki/Set-up-web-browser-to-treat-your-local-IP-as-secure-origin).

## Next steps

If your local tests worked well it is time to create your own (non-admin) account:

* To create new users ([detailed tutorial](https://github.com/SEPIA-Framework/sepia-docs/wiki/Create-and-Edit-Users)) use the SEPIA Control-HUB (aka tools page or admin-tools): http://localhost:20721/tools/index.html (registration via 'real' e-mail is possible in theory but not fully implemented in the clients right now).
* Login to the Control-HUB using your admin account. By extending the login-box you can check if the right server for authentication is selected (very similar to the hostname above) it should look like this 'http://localhost:20721' or this 'http://192.168.0.10:20721' for example.
* Open the menu (top-left) and go to the "User Management" page. Choose an email (can be fake, but a real address could come in handy later for password reset etc.) then press "put on whitelist", add a password and finally press "create". Note the message in the result-box indicating your new ID.
* You should now be able to log-in with your new account (use the ID received during "create" or the email you chose).

## Secure server

Creating your own web-server with SSL encryption will make sure that you can use all features of the app without problems and will also make your server reachable from outside your network (e.g. when you're using the mobile app and want to check your shopping-list inside a supermarket).
To upgrade you local server to a full-blown web-server with SSL it is recommended to use [Nginx](https://de.wikipedia.org/wiki/Nginx) and [Letsencrypt](https://letsencrypt.org/). There are some scripts included in the SEPIA-Home release to make your life easier, to get started check the Wiki entry [here](https://github.com/SEPIA-Framework/sepia-docs/wiki/SSL-for-your-Server).  
  
If you want a super-fast (2min), zero-configuration solution you can use the included SEPIA Reverse-Proxy (Java) together with a neat little tool called "ngrok" to create a temporary, secure web-server:
* Download and extract ngrok for your OS: https://ngrok.com/download
* Start the SEPIA Reverse-Proxy with one of the scripts inside the "sepia-reverse-proxy"-folder
* Call `./ngrok http 20726` (or `.\ngrok.exe http 20726` in Windows) and you will get a HTTPS URL for your SEPIA server
* Use this URL as hostname ([your-ngrok-url]/sepia) in your SEPIA web-app: [your-ngrok-url]/sepia/assist/app/index.html (or in the official, public web-app: https://sepia-framework.github.io/app/index.html)
* ***The drawback:*** your ngrok-server will expire after a while (~7h) and you need to manually restart it. In this process your URL will change as well.
* TO BE CONTINUED ...

## Build-your-own release (for experts)

Since everything in SEPIA is open-source you can always build the whole framework from scratch using the Github repositories.
A rough list of the requirements to do so can be found [here](https://github.com/SEPIA-Framework/sepia-docs/wiki/Requirements).  
  
There is a [setup script](scripts/install-debian-build-environment.sh) that helps to setup a build environment on Debian based Linux and
there is [another script](build_sepia_home_release_apt.sh) to check the environment (except Java) and build SEPIA-Home (custom bundle release).
You can run the first using a Debian based Linux:
```
wget https://raw.githubusercontent.com/SEPIA-Framework/sepia-installation-and-setup/master/scripts/install-debian-build-environment.sh
sudo bash install-debian-build-environment.sh
```
You can run the latter (if you have Java already installed) via:  
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
