#!/bin/sh
cd ~/SEPIA
NOW=$(date +"%Y_%m_%d_%H%M%S")
echo "$NOW - Restarting SEPIA Home" >> restart.log
bash restart-sepia.sh
