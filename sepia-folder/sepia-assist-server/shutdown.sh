#!/bin/bash
echo "Shutting down Assist-API"
pkill -f 'java -jar .*sepia-assist.*'
