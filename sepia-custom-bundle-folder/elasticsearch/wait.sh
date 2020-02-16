#!/bin/bash
echo 'Waiting for Elasticsearch on port 20724 ...'
n=0
until $(curl --output /dev/null --silent --head --fail http://localhost:20724); do
	printf '.'
	sleep 4
	((n++))
	if [ "$n" -gt 30 ]; then
		echo 'TIMEOUT - process took too long!'
		exit 1
	fi
done
echo ''
echo 'Elasticsearch is ready for action.'
