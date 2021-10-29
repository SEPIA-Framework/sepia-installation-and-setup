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
es_yellow_or_green=$(curl --silent -XGET 'http://localhost:20724/_cluster/health?pretty=true&wait_for_status=yellow&timeout=30s' | grep -E "status.*(green|yellow)" | wc -l)
if [ $es_yellow_or_green -eq 1 ]; then
	echo 'Status YELLOW or GREEN: true'
else
	echo 'Status RED or unknown! Abort.'
	exit 1
fi
echo ''
echo 'Elasticsearch is ready for action.'
