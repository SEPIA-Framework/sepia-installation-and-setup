#!/bin/bash
cd sepia-assist-server
./shutdown.sh
cd ..
cd sepia-teach-server
./shutdown.sh
cd ..
cd sepia-websocket-server-java
./shutdown.sh
cd ..
cd elasticsearch
./shutdown.sh
cd ..
echo -e '\n---- wait a second (or 3) ----\n'
sleep 3
echo -e '\n---- testing ----\n'
./sepia-status.sh
