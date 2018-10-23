#!/bin/bash
STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:20724)
echo "Elasticsearch status: $STATUS"
if [ $STATUS -eq 200 ]; then
	echo "ES is running"
else
	echo "ES is OFF or unreachable"
fi
