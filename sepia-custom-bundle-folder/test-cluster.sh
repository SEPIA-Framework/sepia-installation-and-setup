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
	curl -X GET http://localhost:20721/ping
fi
echo -e "\n-----Teach API-----\n"
java -jar $TOOLS_JAR connection-check httpGetJson -url=http://localhost:20722/ping -maxTries=3 -waitBetween=1500 -expectKey=result -expectValue=success
if [ $? -eq 0 ]
then
	echo "OK"
else
	echo "Error:"
	curl -X GET http://localhost:20722/ping
fi
echo -e "\n-----Chat API - WebSocket Server-----\n"
java -jar $TOOLS_JAR connection-check httpGetJson -url=http://localhost:20723/ping -maxTries=3 -waitBetween=1500 -expectKey=result -expectValue=success
if [ $? -eq 0 ]
then
	echo "OK"
else
	echo "Error:"
	curl -X GET http://localhost:20723/ping
fi
echo -e '\n-----Database: Elasticsearch-----\n'
curl -X GET http://localhost:20724/_cluster/health?pretty
echo -e '\nDONE. Please check output for errors!\n'
echo -e "If all looks good you should be able to reach your SEPIA server via: $(hostname).local"
echo -e "Example: $(hostname).local:20721/tools/index.html"
echo -e ''
