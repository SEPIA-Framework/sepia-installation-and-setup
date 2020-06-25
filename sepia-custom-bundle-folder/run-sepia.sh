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
cd elasticsearch
./run.sh
# echo -e 'Waiting for Elasticsearch...\n'
./wait.sh
echo "Checking Elasticsearch setup ..."
es_check=$(curl --silent http://127.0.0.1:20724/users | grep mappings)
if [ -z "$es_check" ]; then
	echo "Elasticsearch is NOT yet setup (or not running with default settings)! Run setup.sh first."
	exit 1
else
	echo "Elasticsearch looks GOOD."
fi
cd ..
if [ -f "sepia-assist-server/Xtensions/TTS/marytts/bin/marytts-server" ]; then
	echo -e '\nChecking extensions ...\n'
	STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:59125/voices)
	if [ $STATUS -eq 200 ]; then
		echo "MaryTTS server is running."
	else
		echo "Starting MaryTTS server, please wait ..."
		echo "INFO: This extension is recommended for systems with 2GB memory or more."
		cd sepia-assist-server/Xtensions/TTS/marytts/bin
		bash marytts-server > /dev/null 2>&1 &
		n=0
		while [ $n -le 30 ]
		do
			STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:59125/voices)
			if [ $STATUS -eq 200 ]; then
				break
			else
				printf "."
				sleep 2
			fi
			n=$(( $n + 1 ))
		done
		if [ $STATUS -eq 200 ]; then
			if [ $n -le 10 ]; then
				echo "MaryTTS server looks GOOD."
			else
				echo "MaryTTS server looks OK but took quite long to start."
			fi
		else
			echo "MaryTTS server did NOT respond, ignoring it for now."
			echo "Plz check 'sepia-assist-server\Xtensions\TTS\marytts' for more info."
			pkill -f 'java .*sepia-assist.*marytts.server.*'
		fi
		cd ../../../../..
	fi
fi
sleep 2
echo -e '\nStarting SEPIA servers ...\n'
cd sepia-assist-server
./run.sh
cd ..
#wait for server to be active
sleep 4
#sleep 15
cd sepia-assist-server
TOOLS_JAR=$(ls | grep "^sepia-core-tools.*jar" | tail -n 1)
java -jar $TOOLS_JAR connection-check httpGetJson -url=http://localhost:20721/ping -maxTries=10 -waitBetween=2500 -expectKey=result -expectValue=success
if [ $? -eq 0 ]
then
	printf ""
else
	echo "TIMEOUT - It took too long to start the server. Please check error logs at 'sepia-assist-server/log.out'."
	exit 1
fi
cd ..
cd sepia-websocket-server-java
./run.sh
cd ..
sleep 2
cd sepia-teach-server
./run.sh
cd ..
sleep 2
echo -e '\n---- Wait a second (or 5) ----\n'
sleep 5
echo -e '---- Testing cluster ----\n'
./test-cluster.sh
