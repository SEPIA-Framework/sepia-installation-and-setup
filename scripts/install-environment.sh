#!/bin/sh

# INSTALL JAVA

#add digital key for PPA
sudo apt install dirmngr
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
#to skip the license agreement: https://askubuntu.com/questions/190582/installing-java-automatically-with-silent-option

#add packets:
sudo touch /etc/apt/sources.list.d/webupd8team-java.list
echo 'deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main' | sudo tee --append /etc/apt/sources.list.d/webupd8team-java.list
echo 'deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main' | sudo tee --append /etc/apt/sources.list.d/webupd8team-java.list

#install Java 8
sudo apt-get update
sudo apt-get install oracle-java8-installer
sudo apt-get install oracle-java8-set-default
java -version

# UPDATE TIME

sudo apt-get install ntpdate
sudo ntpdate -u ntp.ubuntu.com

# INSTALL DEFAULT SSL CERTIFICATES

sudo apt-get install ca-certificates

# NGINX:

sudo apt-get install software-properties-common
sudo apt-get install nginx

# DOWNLOAD SEPIA

#mkdir ~/SEPIA
#cd ~/SEPIA
#wget ...

# SCRIPTS ACCESS

find . -name "*sh" -exec chmod +x {} \;
chmod +x elasticsearch/bin/elasticsearch
#chmod +x *.sh
#chmod +x assist/*.sh
#chmod +x teach/*.sh
#chmod +x chat/*.sh
#chmod +x elasticsearch/*.sh

# SETUP SEPIA

#cd elasticsearch
#./run.sh
#sleep 12
#cd ..
#cd sepia-assist-server
#java -jar sepia-assist-v2.0.x.jar setup --my
#cd ..
#cd elasticsearch
#./shutdown.sh
#sleep 3
#cd ..
