#!/bin/bash
echo 'Waiting for Elasticsearch on port 20724 ...'
until $(curl --output /dev/null --silent --head --fail http://localhost:20724); do
	printf '.'
	sleep 4
done
echo ''
echo 'Elasticsearch is ready for action.'
