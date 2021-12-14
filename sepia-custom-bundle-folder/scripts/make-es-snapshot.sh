#!/bin/bash
if [ -n "$1" ]
then
	echo ""
	echo "Before you continue please make sure that you've enabled 'path.repo'"
	echo "in your 'elasticsearch/config/elasticsearch.yml' folder, set the right path"
	echo "and that you have created the repo via 'bash create-es-snapshot-repo.sh'."
	echo ""
	echo "Snapshot name: $1"
	echo "NOTE: Don't use space or special characters as name!"
	echo ""
	read -p "Press any key to continue or CTRL+C to abort" anykey
	echo ""
	curl -X PUT "http://localhost:20724/_snapshot/sepia-backups/$1?wait_for_completion=true&pretty=" \
	  -H 'Content-Type: application/json' \
	  -d '{"ignore_unavailable": false, "include_global_state": false}'
	# NOTE: you can add specific indices by adding: "indices": "index_1,index_2"
	echo ""
else
	echo "Please use 'bash make-es-snapshot.sh [my-snapshot-name]'"
	exit
fi
