#!/bin/bash
version=latest
if [ -n "$1" ]; then
	version=$1
fi
sudo docker manifest create sepia/home:latest \
--amend "sepia/home:$1_amd64_auto" \
--amend "sepia/home:$1_aarch64_auto" \
--amend "sepia/home:$1_armv7l_auto"

sudo docker manifest push sepia/home:latest