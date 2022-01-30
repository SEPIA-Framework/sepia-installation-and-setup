#!/bin/bash
#
# make sure we are in the right folder
SCRIPT_PATH="$(realpath "$BASH_SOURCE")"
SEPIA_FOLDER="$(dirname "$SCRIPT_PATH")"
cd "$SEPIA_FOLDER"
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
./shutdown.sh
cd ..
cd sepia-teach-server
./shutdown.sh
cd ..
cd sepia-websocket-server-java
./shutdown.sh
cd ..
cd elasticsearch
./shutdown.sh
cd ..
echo "Shutting down Extensions: MaryTTS server"
pkill -f 'java .*sepia-assist.*marytts.server.*'
echo -e '\n---- wait a second (or 3) ----\n'
sleep 3
echo -e '---- testing ----\n'
./sepia-status.sh
