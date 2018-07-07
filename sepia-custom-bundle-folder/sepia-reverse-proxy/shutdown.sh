#!/bin/bash
echo "Shutting down SEPIA Reverse-Proxy"
pkill -f 'java -jar .*sepia-reverse-proxy.*'
