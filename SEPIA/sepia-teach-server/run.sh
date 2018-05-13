#!/bin/bash
NOW=$(date +"%Y_%m_%d_%H%M%S")
cp log.out logs/backup_$NOW.out
rm log.out
JAR_NAME=$(ls | grep "^sepia-teach.*jar" | tail -n 1)
echo "Running SEPIA Teach ($JAR_NAME)"
nohup java -jar -Xms128m -Xmx128m $JAR_NAME --my &> log.out&
