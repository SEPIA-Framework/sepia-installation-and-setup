#!/bin/bash
echo -e "\n-----Assist API-----\n"
curl -X GET http://localhost:20721/ping

echo -e '\n\n-----Teach API-----\n'
curl -X GET http://localhost:20722/ping

echo -e '\n\n-----Chat API - WebSocket Server-----\n'
curl -X GET http://localhost:20723/ping

echo -e '\n\n-----Database: Elasticsearch-----\n'
curl -X GET http://localhost:20724

echo -e '\nAll done, please check output for errors!\n'

