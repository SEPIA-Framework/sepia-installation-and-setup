#!/bin/bash
set -e
javaurl="https://api.adoptium.net/v3/binary/latest/11/ga/linux/aarch64/jdk/hotspot/normal/eclipse?project=jdk"
echo "Downloading Java OpenJDK 11. This might take a few minutes ..."
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


