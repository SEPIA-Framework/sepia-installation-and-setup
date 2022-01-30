#!/bin/bash
ENGINE="vosk"
echo "Engine: $ENGINE"
PLATFORM=""
if [ -n "$(uname -m | grep aarch64)" ]; then
	PLATFORM=aarch64
elif [ -n "$(uname -m | grep armv7l)" ]; then
	PLATFORM=armv7l
elif [ -n "$(uname -m | grep x86_64)" ]; then
	PLATFORM=amd64
elif [ -n "$(uname -m | grep armv6l)" ]; then
	echo "Platform: armv6l - NOT SUPPORTED"
	exit 1
else
	echo "Platform: x86_32 - NOT SUPPORTED"
	exit 1
fi
echo "Platform: $PLATFORM"
sudo docker run --rm --name=sepia-stt -p 20741:20741 -d sepia/stt-server:"${ENGINE}_${PLATFORM}"
