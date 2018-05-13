#!/bin/bash
v=$(<VERSION)
echo "Running Elasticsearch $v"
cd bin
PIDFile="elasticPID.pid"
touch $PIDFile
./elasticsearch -p $PIDFile -d
cat $PIDFile && echo
