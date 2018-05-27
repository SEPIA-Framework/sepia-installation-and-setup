#!/bin/sh

#add digital key for PPA
sudo apt install dirmngr
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886

#add packages:
sudo touch /etc/apt/sources.list.d/webupd8team-java.list
echo 'deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main' | sudo tee --append /etc/apt/sources.list.d/webupd8team-java.list
echo 'deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main' | sudo tee --append /etc/apt/sources.list.d/webupd8team-java.list

#install Java 8
sudo apt-get update
sudo apt-get install oracle-java8-installer
sudo apt-get install oracle-java8-set-default

echo 'DONE'
java -version
