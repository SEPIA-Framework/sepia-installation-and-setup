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
cd ..
echo -e '\nStarting SEPIA servers ...\n'
cd sepia-assist-server
./run.sh
cd ..
sleep 10
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
echo -e '\n---- Testing cluster ----\n'
./test-cluster.sh
