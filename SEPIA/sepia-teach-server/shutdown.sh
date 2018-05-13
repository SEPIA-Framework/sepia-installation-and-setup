#!/bin/bash
echo "Shutting down Teach-API"
pkill -f 'java -jar .*sepia-teach.*'
