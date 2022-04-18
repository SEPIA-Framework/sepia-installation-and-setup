#!/bin/bash
#
# make sure we are in the right folder
SCRIPT_PATH="$(realpath "$BASH_SOURCE")"
SEPIA_FOLDER="$(dirname "$SCRIPT_PATH")"
LOG="${SEPIA_FOLDER}/startup-log.out"
cd "$SEPIA_FOLDER"
echo "$(date +'%Y_%m_%d_%H:%M:%S') - Starting SEPIA-Home ..." > "$LOG"
#
# set local Java path
if [ -f "java/version" ]; then
    new_java_home=$(cat java/version)
    export JAVA_HOME=$(pwd)/java/$new_java_home
    export PATH=$JAVA_HOME/bin:$PATH
	echo "Found local Java version: $JAVA_HOME"
	echo "$(date +'%Y_%m_%d_%H:%M:%S') - Found local Java version: $JAVA_HOME" >> "$LOG"
	echo ""
elif [ $(command -v java | wc -l) -gt 0 ]; then
	java -version
	echo "$(date +'%Y_%m_%d_%H:%M:%S') - Found system Java version: $(javac -version)" >> "$LOG"
	echo ""
else
	echo "No Java version found! Please install Java JDK 11 (e.g.: openjdk-11-jdk-headless)."
	echo "Check SEPIA installer or setup scripts for more info."
	echo "$(date +'%Y_%m_%d_%H:%M:%S') - No Java version found! Please install Java JDK 11 (e.g.: openjdk-11-jdk-headless)" >> "$LOG"
	exit 1
fi
#
SEPIA_VER=$(cat version | grep SEPIA)
echo "Running: $SEPIA_VER"
echo "$(date +'%Y_%m_%d_%H:%M:%S') - Running: $SEPIA_VER" >> "$LOG"
echo ""
#
cd elasticsearch
if [ $(sysctl vm.max_map_count | grep 262144 | wc -l) -eq 0 ]; then
	echo "WARNING: Elasticsearch requires 'vm.max_map_count=262144' to run stable."
	echo "To set it once use this (on your host machine):"
	echo "sudo sysctl -w vm.max_map_count=262144"
	echo "To set it permanently you can try:"
	echo "sudo su -c \"echo 'vm.max_map_count=262144' >> /etc/sysctl.d/99-sysctl.conf\""
	echo "$(date +'%Y_%m_%d_%H:%M:%S') - WARNING: Elasticsearch requires 'vm.max_map_count=262144' to run stable." >> "$LOG"
	echo ""
fi
./run.sh
# echo -e 'Waiting for Elasticsearch...\n'
./wait.sh
echo "Checking Elasticsearch setup ..."
echo "$(date +'%Y_%m_%d_%H:%M:%S') - Checking Elasticsearch setup ..." >> "$LOG"
es_check=$(curl --silent http://127.0.0.1:20724/users | grep mappings)
if [ -z "$es_check" ]; then
	echo "Elasticsearch is NOT yet setup (or not running with default settings)! Run setup.sh first."
	echo "$(date +'%Y_%m_%d_%H:%M:%S') - Elasticsearch is NOT yet setup (or not running with default settings)! Run setup.sh first" >> "$LOG"
	exit 1
else
	echo "Elasticsearch looks GOOD."
	echo "$(date +'%Y_%m_%d_%H:%M:%S') - Elasticsearch looks GOOD" >> "$LOG"
fi
sleep 2
cd ..
if [ -f "sepia-assist-server/Xtensions/TTS/marytts/bin/marytts-server" ]; then
	echo -e '\nChecking extensions ...\n'
	echo "$(date +'%Y_%m_%d_%H:%M:%S') - Checking MaryTTS server ..." >> "$LOG"
	STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:59125/voices)
	if [ $STATUS -eq 200 ]; then
		echo "MaryTTS server is running."
		echo "$(date +'%Y_%m_%d_%H:%M:%S') - MaryTTS server is running" >> "$LOG"
	else
		echo "$(date +'%Y_%m_%d_%H:%M:%S') - Starting MaryTTS server, please wait ..." >> "$LOG"
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
				echo "$(date +'%Y_%m_%d_%H:%M:%S') - MaryTTS server looks GOOD" >> "$LOG"
			else
				echo "MaryTTS server looks OK but took quite long to start."
				echo "$(date +'%Y_%m_%d_%H:%M:%S') - MaryTTS server looks OK but took quite long to start" >> "$LOG"
			fi
		else
			echo "$(date +'%Y_%m_%d_%H:%M:%S') - MaryTTS server did NOT respond, ignoring it for now" >> "$LOG"
			echo "MaryTTS server did NOT respond, ignoring it for now."
			echo "Plz check 'sepia-assist-server\Xtensions\TTS\marytts' for more info."
			pkill -f 'java .*sepia-assist.*marytts.server.*'
		fi
		cd ../../../../..
	fi
	sleep 2
fi
echo -e '\nStarting SEPIA servers ...\n'
echo "$(date +'%Y_%m_%d_%H:%M:%S') - Starting SEPIA 'Assist' server ..." >> "$LOG"
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
	echo "$(date +'%Y_%m_%d_%H:%M:%S') - It took too long to start the server. Please check error logs at 'sepia-assist-server/log.out'" >> "$LOG"
	exit 1
fi
cd ..
cd sepia-websocket-server-java
echo "$(date +'%Y_%m_%d_%H:%M:%S') - Starting SEPIA 'Chat' server ..." >> "$LOG"
./run.sh
cd ..
sleep 2
cd sepia-teach-server
echo "$(date +'%Y_%m_%d_%H:%M:%S') - Starting SEPIA 'Teach' server ..." >> "$LOG"
./run.sh
cd ..
sleep 2
echo -e '\n---- Wait a second (or 5) ----\n'
sleep 5
echo -e '---- Testing cluster ----\n'
./test-cluster.sh
echo "$(date +'%Y_%m_%d_%H:%M:%S') - DONE" >> "$LOG"
