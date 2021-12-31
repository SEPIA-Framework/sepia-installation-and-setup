#!/bin/bash
NOW=$(date +"%Y_%m_%d_%H%M%S")
mkdir -p logs
if [ -f "log.out" ]; then
	cp log.out logs/backup_$NOW.out
	rm log.out
fi
echo "Running SEPIA STT-Server"
echo "$NOW - Start" > log.out
cd server
nohup python -u -m launch &>> ../log.out &
sleep 3
cd ..
#bash status.sh
cat log.out
echo ""
