#!/bin/bash
#
# set local Java path
if [ -f "java/version" ]; then
    new_java_home=$(cat java/version)
    export JAVA_HOME=$(pwd)/java/$new_java_home
    export PATH=$JAVA_HOME/bin:$PATH
	echo "Found local Java version: $JAVA_HOME"
	echo
fi
#
cd sepia-assist-server
TOOLS_JAR=$(ls | grep "^sepia-core-tools.*jar" | tail -n 1)
echo -e "\n-----Assist API-----\n"
java -jar $TOOLS_JAR connection-check httpGetJson -url=http://localhost:20721/ping -maxTries=3 -waitBetween=1500 -expectKey=result -expectValue=success
if [ $? -eq 0 ]
then
	echo "OK"
else
	echo "Error:"
	curl --silent -X GET http://localhost:20721/ping
fi
echo -e "\n-----Teach API-----\n"
java -jar $TOOLS_JAR connection-check httpGetJson -url=http://localhost:20722/ping -maxTries=3 -waitBetween=1500 -expectKey=result -expectValue=success
if [ $? -eq 0 ]
then
	echo "OK"
else
	echo "Error:"
	curl --silent -X GET http://localhost:20722/ping
fi
echo -e "\n-----Chat API - WebSocket Server-----\n"
java -jar $TOOLS_JAR connection-check httpGetJson -url=http://localhost:20723/ping -maxTries=3 -waitBetween=1500 -expectKey=result -expectValue=success
if [ $? -eq 0 ]
then
	echo "OK"
else
	echo "Error:"
	curl --silent -X GET http://localhost:20723/ping
fi
echo -e '\n-----Database: Elasticsearch-----\n'
curl --silent -X GET http://localhost:20724/_cluster/health?pretty
echo -e '\nDONE. Please check output for errors!\n'
ip_adr=""
if [ -x "$(command -v ip)" ]; then
	# old: ifconfig
	ip_adr=$(ip a | grep -E 'eth0|wlan0' | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' | head -1)
fi
if [ -z "$ip_adr" ]; then
	ip_adr="[IP]"
fi
echo -e "If all looks good you should be able to reach your SEPIA server via: $(hostname).local or $ip_adr"
echo -e ''
echo -e "Example1: http://$(hostname).local:20721/tools/index.html"
echo -e "Example2: http://$ip_adr:20721/tools/index.html"
echo -e "Example3: http://$ip_adr:20721/app/index.html"
echo -e ''
echo -e "If you've installed NGINX proxy with self-signed SSL try:"
echo -e "Example4: https://$(hostname).local:20726/sepia/assist/tools/index.html"
echo -e "Example5: https://$(hostname).local:20726/sepia/assist/app/index.html"
echo -e ''
echo -e "Please note: if this is a virtual machine the hostname might not work to contact the server!"
echo -e ''
