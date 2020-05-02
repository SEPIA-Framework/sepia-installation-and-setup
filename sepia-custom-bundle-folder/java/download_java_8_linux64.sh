#!/bin/bash
set -e
javaurl="https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u252-b09/OpenJDK8U-jdk_x64_linux_hotspot_8u252b09.tar.gz"
echo "Downloading Java OpenJDK 8. This might take a few minutes ..."
echo
echo "URL: $javaurl"
echo
wget -O "java_tmp.tar.gz" "$javaurl"
echo "Extracting Zip file ..."
tar -zxvf "java_tmp.tar.gz"
echo "Cleaning up ..."
rm "java_tmp.tar.gz"
javaversion=$(find -maxdepth 1 ! -path . -type d -name '*' -print -quit | cut -c3-)
echo $javaversion> version
# sudo apt-get install ca-certificates-java
# ln -sf "/etc/ssl/certs/java/cacerts" "~/SEPIA/java/${javaversion}/lib/security/cacerts"
echo "Set Java version to: $javaversion"
echo "DONE"


