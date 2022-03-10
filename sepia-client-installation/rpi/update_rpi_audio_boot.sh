#!/bin/bash
if [[ $EUID -eq 0 ]]; then
    echo "Deactivating Raspberry Pi on-board audio and default headphone jack."
else
	echo "This script needs to be run as root via 'sudo'"
	exit
fi
bootfile="/boot/config.txt"
sed -i 's/^dtparam=audio=on/dtparam=audio=off/' $bootfile
echo "DONE"