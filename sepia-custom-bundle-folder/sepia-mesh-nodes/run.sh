#!/bin/bash
NOW=$(date +"%Y_%m_%d_%H%M%S")
cp log.out logs/backup_$NOW.out
rm log.out
JAR_NAME=$(ls | grep "^sepia-mesh-node-.*jar" | tail -n 1)
echo "Running SEPIA Mesh-Node ($JAR_NAME)"
nohup java -jar -Xms24m -Xmx24m $JAR_NAME --my &> log.out&
