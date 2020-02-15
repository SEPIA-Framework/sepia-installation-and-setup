#!/bin/sh

# SETUP VM FOR ELASTICSEARCH
sudo sysctl -w vm.max_map_count=262144

# START
cd ~/SEPIA
./run-sepia.sh

# ADD PROXY - NOTE: replaced by Nginx
#./run-reverse-proxy.sh

# KEEP DOCKER ALIVE (alternatively run proxy or websocket server in foreground)
trap : TERM INT; sleep infinity & wait