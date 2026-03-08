#!/bin/bash
get_bootfile_path() {
	if [ -f /boot/firmware/config.txt ]; then
		echo "/boot/firmware/config.txt"
	elif [ -f /boot/config.txt ] && ! grep -q "boot/firmware" /boot/config.txt; then
		echo "/boot/config.txt"
	else
		echo "Error: config.txt not found!" >&2
		return 1
	fi
}
if [[ $EUID -eq 0 ]]; then
    echo "Deactivating Raspberry Pi on-board audio and default headphone jack."
else
	echo "This script needs to be run as root via 'sudo'"
	exit
fi
bootfile=$(get_bootfile_path) || exit 1
sed -i 's/^dtparam=audio=on/dtparam=audio=off/' $bootfile
echo "DONE"