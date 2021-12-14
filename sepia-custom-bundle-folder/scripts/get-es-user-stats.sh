#!/bin/bash
if [ -n "$1" ]
then
	curl -X GET "http://localhost:20724/users/all/_search?pretty=true&_source=Email,statistics&q=Guuid:$1"
else
	curl -X GET "http://localhost:20724/users/all/_search?pretty=true&_source=Email,statistics"
fi
echo ""
echo "NOTE: You can use for example 'bash get-es-user-stats.sh uid1007' to show specific UID."
echo ""
