#!/bin/bash
set -e

#add digital key for PPA
apt-get install -y dirmngr debconf-utils
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886

#add packages:
touch /etc/apt/sources.list.d/webupd8team-java.list && \
echo 'deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main' | tee --append /etc/apt/sources.list.d/webupd8team-java.list && \
echo 'deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main' | tee --append /etc/apt/sources.list.d/webupd8team-java.list

#update and install
echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
mkdir -p /usr/share/man/man1
apt-get update && \
apt-get install -y oracle-java8-installer oracle-java8-set-default

echo 'DONE - For the Oracle Java license please see: http://www.java.com/license'
java -version
