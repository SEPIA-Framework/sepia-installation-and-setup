#!/bin/bash
set -e
echo ''
echo 'PLEASE NOTE: This is Adopt OpenJDK 8 and mainly intended for building SEPIA components.'
echo 'Recommended default is OpenJDK Java 11: sudo apt-get install -y openjdk-11-jdk-headless ca-certificates-java'
read -p "Press enter to continue or CTRL+C to quit"
echo ''

#update and get required packages
sudo apt-get update
sudo apt-get install -y software-properties-common
sudo apt-get install -y gnupg2

#add digital key
wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | sudo apt-key add -

#add packages:
sudo add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/
sudo apt-get update

#install
sudo apt-get install adoptopenjdk-8-hotspot

echo 'DONE'
java -version
