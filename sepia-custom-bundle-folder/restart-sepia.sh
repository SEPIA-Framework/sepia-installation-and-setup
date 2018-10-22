#!/bin/bash
#Preliminary restart script, we should replace the sleep with a real check, e.g. via HTTP GET
./shutdown-sepia.sh 
sleep 5
./run-sepia.sh
