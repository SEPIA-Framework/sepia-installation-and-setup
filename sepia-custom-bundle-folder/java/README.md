# Local Java Installation

Use the scripts in this folder to download a local version of Java JDK for your system that will be used together with SEPIA.
If a script for your system is missing or the script doesn't work you can download Java JDK manually from [adoptium.net](https://adoptium.net/de/temurin/archive/?version=11)  
You can download an installer as well but for our local version choose a ZIP or TAR file and extract the compressed file to 
`[SEPIA]/java/` so you get for example `[SEPIA]/java/jdk-11.0.5+10`.
  
NOTE: During start SEPIA will search the folder defined in `[SEPIA]/java/version` for a valid JAVA version!
  
TODO: Add download scripts and implement local version check in setup/start/test/... for Mac
