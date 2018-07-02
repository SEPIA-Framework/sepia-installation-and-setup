#!/bin/bash
echo "Shutting down WebSocket Chat-API"
pkill -f 'java -jar .*sepia-chat.*'
