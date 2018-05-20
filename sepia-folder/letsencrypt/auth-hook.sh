#! /bin/bash

# The SEPIA folder
SEPIA_FOLDER="~/SEPIA"

# Get DuckDNS DOMAIN and TOKEN
source $SEPIA_FOLDER/letsencrypt/duck-dns-settings.sh

echo url="https://www.duckdns.org/update?domains=$DOMAIN&token=$TOKEN&txt=$CERTBOT_VALIDATION&verbose=true" | curl -k -o $SEPIA_FOLDER/letsencrypt/logs/DuckDNS_update.log -K -