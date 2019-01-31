#!/bin/bash
echo "Shutting down SEPIA Mesh-Node"
pkill -f 'java -jar .*sepia-mesh-node-.*'
