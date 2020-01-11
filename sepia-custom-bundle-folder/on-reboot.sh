#!/bin/sh

# SETUP VM FOR ELASTICSEARCH - https://www.elastic.co/guide/en/elasticsearch/reference/5.3/vm-max-map-count.html
sudo sysctl -w vm.max_map_count=262144

# START
cd ~/SEPIA
./run-sepia.sh

# ADD PROXY?
# ./run-reverse-proxy.sh