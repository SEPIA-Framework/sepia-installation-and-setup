#!/bin/bash
set -e

#check packages (except Java)
apt-get install -y wget maven unzip git

#make SEPIA and tmp folder and download files
mkdir -p ~/SEPIA/tmp
cd ~/SEPIA/tmp

wget -O sepia-custom-bundle-folder.zip https://github.com/SEPIA-Framework/sepia-installation-and-setup/blob/master/sepia-custom-bundle-folder.zip?raw=true
unzip -n sepia-custom-bundle-folder.zip -d ~/SEPIA

git clone https://github.com/SEPIA-Framework/sepia-core-tools-java.git
git clone https://github.com/SEPIA-Framework/sepia-websocket-server-java.git
git clone https://github.com/SEPIA-Framework/sepia-assist-server.git
git clone https://github.com/SEPIA-Framework/sepia-teach-server.git
git clone https://github.com/SEPIA-Framework/sepia-reverse-proxy.git
git clone https://github.com/SEPIA-Framework/sepia-html-client-app.git
git clone https://github.com/SEPIA-Framework/sepia-admin-tools.git

#build all modules and copy client and admin-tools
cd sepia-core-tools-java && mvn install && cp -r target/release/. ~/SEPIA/sepia-assist-server/ && cd ..
cd sepia-websocket-server-java && mvn install && cp -r target/release/. ~/SEPIA/sepia-websocket-server-java/ && cd ..
cd sepia-assist-server && mvn install && cp -r target/release/. ~/SEPIA/sepia-assist-server/ && cd ..
cd sepia-teach-server && mvn install && cp -r target/release/. ~/SEPIA/sepia-teach-server/ && cd ..
cd sepia-reverse-proxy && mvn install && cp -r target/release/. ~/SEPIA/sepia-reverse-proxy/ && cd ..
mkdir -p sepia-assist-server/Xtensions/WebContent/app
cp -r sepia-html-client-app/www/. ~/SEPIA/sepia-assist-server/Xtensions/WebContent/app/
mkdir -p sepia-assist-server/Xtensions/WebContent/tools
cp -r sepia-admin-tools/admin-web-tools/. ~/SEPIA/sepia-assist-server/Xtensions/WebContent/tools/

#download and unzip elasticsearch (keeping the existing config folder)
wget -O elasticsearch.zip https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.3.3.zip
unzip -n elasticsearch.zip
cp -rn elasticsearch-*/. ~/SEPIA/elasticsearch/

#clean up
cd ~/SEPIA
rm -r ~/SEPIA/tmp
