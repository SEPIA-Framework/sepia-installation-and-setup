#!/bin/bash
STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:20724)
echo "Elasticsearch status: $STATUS"
if [ $STATUS -eq 200 ]; then
	echo "Elasticsearch is already running"
	exit
fi
v=$(<VERSION)
echo "Starting Elasticsearch $v"
cd bin
PIDFile="elasticPID.pid"
touch $PIDFile
./elasticsearch -p $PIDFile -d
if [ $? -eq 0 ]; then
	cat $PIDFile && echo
else
	exit 1
fi
