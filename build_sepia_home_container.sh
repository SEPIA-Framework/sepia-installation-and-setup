#!/bin/bash
version=latest
if [ -n "$1" ]; then
	version=$1
else
	echo "Please specify the version to use for this release, e.g. 'v2.6.3'"
	exit
fi
if [ -n "$(uname -m | grep aarch64)" ]; then
	echo "Building SEPIA-Home Docker container: sepia/home:${version}_aarch64_auto"
	sudo docker build --no-cache -t "sepia/home:${version}_aarch64_auto" .
elif [ -n "$(uname -m | grep armv7l)" ]; then
	echo "Building SEPIA-Home Docker container: sepia/home:${version}_armv7l_auto"
	sudo docker build --no-cache -t "sepia/home:${version}_armv7l_auto" .
else
	# NOTE: x86 32bit build not supported atm
	echo "Building SEPIA-Home Docker container: sepia/home:${version}_amd64_auto"
	sudo docker build --no-cache -t "sepia/home:${version}_amd64_auto" .
fi
