#!/bin/sh
set -e
echo "This script has been tested with: Debian 10 (slim)"
echo ""

# UPDATE PACKAGE SOURCES
echo 'Updating package sources ...'
sudo apt-get update
echo 'Done'
echo ''

# INSTALL JAVA OPENJDK 11
echo 'Installing OpenJDK 11 ...'
sudo apt-get install -y openjdk-11-jdk-headless ca-certificates-java
echo 'Done'
java -version
echo ''
	
# INSTALL REQUIRED PACKAGES
echo 'Installing required packages ...'
sudo apt-get install -y wget curl nano unzip zip git procps maven ca-certificates
echo 'Done'
echo ''

# CLEAN UP
echo 'Cleaning up ...'
sudo apt-get clean && sudo apt-get autoclean && sudo apt-get autoremove -y
echo 'Done'
echo ''

echo 'Please note: SEPIA components built with this version are based on OpenJDK Java 11 an thus might require the same or higher versions to run!'
echo 'As of February 2020 Java version 12 and higher are not yet supported due to Elasticsearch conflicts!'
echo ''
echo 'You can start building your own SEPIA version now :-)'
echo ''
echo 'Suggestions to continue:'
echo 'wget https://raw.githubusercontent.com/SEPIA-Framework/sepia-installation-and-setup/master/build_sepia_home_release_apt.sh'
echo 'sudo bash build_sepia_home_release_apt.sh'
echo 'or (for dev builds):'
echo 'sudo bash build_sepia_home_release_apt.sh dev'
echo ''