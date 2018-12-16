#!/bin/bash
echo -e "\n-----Assist API-----\n"
curl -X GET http://localhost:20721/ping

echo -e '\n\n-----Teach API-----\n'
curl -X GET http://localhost:20722/ping

echo -e '\n\n-----Chat API - WebSocket Server-----\n'
curl -X GET http://localhost:20723/ping

echo -e '\n\n-----Database: Elasticsearch-----\n'
curl -X GET http://localhost:20724/_cluster/health?pretty

echo -e '\nDONE. Please check output for errors!\n'
echo -e "If all looks good you should be able to reach your SEPIA server via: $(hostname).local"

