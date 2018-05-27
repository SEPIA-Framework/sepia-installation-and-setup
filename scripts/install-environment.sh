#!/bin/sh

# INSTALL JAVA

#add digital key for PPA
echo 'Installing Oracle Java 8 ...'
sudo apt install dirmngr
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
#to skip the license agreement: https://askubuntu.com/questions/190582/installing-java-automatically-with-silent-option

#add packets
sudo touch /etc/apt/sources.list.d/webupd8team-java.list
echo 'deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main' | sudo tee --append /etc/apt/sources.list.d/webupd8team-java.list
echo 'deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main' | sudo tee --append /etc/apt/sources.list.d/webupd8team-java.list

#install
sudo apt-get update
sudo apt-get install oracle-java8-installer
sudo apt-get install oracle-java8-set-default
echo 'Done'
java -version

# UPDATE TIME SYNC

echo 'Installing ntpdate to sync time ...'
sudo apt-get install ntpdate
sudo ntpdate -u ntp.ubuntu.com

# INSTALL CA-CERTIFICATES (usually already there)

sudo apt-get install ca-certificates

# INSTALL NGINX

echo 'Installing nginx reverse-proxy ...'
sudo apt-get install software-properties-common
sudo apt-get install nginx

# INSTALL SEPIA

#create folder (usually done before getting this file)
#mkdir ~/SEPIA
#cd ~/SEPIA
#wget ...

#scripts access
find . -name "*sh" -exec chmod +x {} \;
chmod +x elasticsearch/bin/elasticsearch

