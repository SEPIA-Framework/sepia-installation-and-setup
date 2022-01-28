#!/bin/sh

# SETUP VM FOR ELASTICSEARCH - https://www.elastic.co/guide/en/elasticsearch/reference/5.3/vm-max-map-count.html
# To make this setting permanent you can try: 'sudo su -c "echo 'vm.max_map_count=262144' >> /etc/sysctl.d/99-sysctl.conf"'
if [ $(sysctl vm.max_map_count | grep 262144 | wc -l) -eq 0 ]; then
	sudo sysctl -w vm.max_map_count=262144
fi

# START
SCRIPT_PATH="$(realpath "$BASH_SOURCE")"
SEPIA_FOLDER="$(dirname "$SCRIPT_PATH")"
cd "$SEPIA_FOLDER"
bash run-sepia.sh
