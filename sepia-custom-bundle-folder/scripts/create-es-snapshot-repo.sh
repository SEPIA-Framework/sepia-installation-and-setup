#!/bin/bash
echo ""
echo "Before you continue please make sure that you've enabled 'path.repo'"
echo "in your 'elasticsearch/config/elasticsearch.yml' folder and set the right path."
echo "RESTART Elasticsearch afterwards!"
echo ""
read -p "Press any key to continue or CTRL+C to abort" anykey
echo ""
curl -X PUT http://localhost:20724/_snapshot/sepia-backups \
  -H 'Content-Type: application/json' \
  -d '{"type": "fs", "settings": {"compress" : true, "location": "sepia"}}'
echo ""
