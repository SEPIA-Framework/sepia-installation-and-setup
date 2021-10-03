#!/bin/bash
if [[ $EUID -eq 0 ]]; then
    echo "Deactivating default headphone jack."
else
	echo "This script needs to be run as root via 'sudo'"
	exit
fi
bootfile="/boot/config.txt"
sed -i 's/^dtparam=audio=on/dtparam=audio=off/' $bootfile
# previously required (now problematic):
# sed -i 's/#.*dtoverlay=seeed-2mic-voicecard/dtoverlay=seeed-2mic-voicecard/' $bootfile
# if grep -q "dtoverlay=seeed-2mic-voicecard" $bootfile; then 
#     echo "Found 'dtoverlay=seeed-2mic-voicecard'"
# else
#     echo "dtoverlay=seeed-2mic-voicecard" >> $bootfile
# fi
echo "DONE"