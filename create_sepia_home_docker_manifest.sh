#!/bin/bash
version=latest
if [ -n "$1" ]; then
	version=$1
else
	echo "Please specify the version to use for 'latest' release, e.g. 'v2.6.2'"
	exit
fi
sudo docker manifest create sepia/home:latest \
--amend "sepia/home:${version}_amd64_auto" \
--amend "sepia/home:${version}_aarch64_auto" \
--amend "sepia/home:${version}_armv7l_auto"

sudo docker manifest push sepia/home:latest