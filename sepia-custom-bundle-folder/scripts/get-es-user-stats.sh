#!/bin/bash
if [ -n "$1" ]
then
	curl -X GET "localhost:20724/users/all/_search?pretty=true&_source=Email,statistics&q=Guuid:$1"
else
	curl -X GET "localhost:20724/users/all/_search?pretty=true&_source=Email,statistics"
fi
