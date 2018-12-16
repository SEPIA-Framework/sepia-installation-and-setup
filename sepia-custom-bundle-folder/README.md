# SEPIA-Home

This is the base folder for the SEPIA-Home (aka custom release) bundle. It contains all the start and setup scripts and certain configurations to operate your SEPIA-Framework.

## How to get started

Check-out the installation guide: https://github.com/SEPIA-Framework/sepia-installation-and-setup

## How to create a SEPIA-Home bundle release

Check out [this build script](https://github.com/SEPIA-Framework/sepia-installation-and-setup/blob/master/build_sepia_home_release_apt.sh) for the most recent procedure. It will roughly do the following:
* Copy this folder somewhere
* Create a temporary folder and use Git to clone all required repositories (tools, servers, proxy)
* Build the Java components with `maven install`
* Copy the release versions of the SEPIA servers to their respective sub-folders (assist, teach and chat each with jar, libs and Xtensions)
* Copy sepia-core-tools-*.jar from the SEPIA core-tools release to the 'sepia-assist-server' sub-folder
* Copy the release versions of the SEPIA reverse-proxy to its respective sub-folder 
* Download Elasticsearch 5.3.3: https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.3.3.zip
* Copy over the contents of the ZIP to the 'elasticsearch' sub-folder WITHOUT overwriting the 'elasticsearch/config' folder
* Copy the content of the SEPIA HTML client's 'www' folder (https://github.com/SEPIA-Framework/sepia-html-client-app/tree/master/www) to 'sepia-assist-server/Xtensions/WebContent/app'
* Copy the content of the SEPIA admin-tools folder (https://github.com/SEPIA-Framework/sepia-admin-tools/tree/master/admin-web-tools) to 'sepia-assist-server/Xtensions/WebContent/tools'
  
After the build is completed do this:
* Update the custom-bundle README and the online version if necessary: https://github.com/SEPIA-Framework/sepia-installation-and-setup/blob/master/README.md
* Test if everything works (zip the folder, copy it somewhere, do the SEPIA installation from scratch, run the client, ...)
* Upload the release
* Update social-media channels and SEPIA homepage :-)
