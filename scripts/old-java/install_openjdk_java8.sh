#!/bin/bash
echo ''
echo 'PLEASE NOTE: This script is outdated! It is now recommended to install OpenJDK Java 11.'
echo 'e.g.: sudo apt-get install -y openjdk-11-jdk-headless ca-certificates-java'
read -p "Press enter to continue or CTRL+C to quit"
echo ''
apt-get install -y --no-install-recommends openjdk-8-jdk-headless ca-certificates-java
echo "JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/" >> /etc/environment
source /etc/environment
