#!/bin/bash

# CALL CERTBOT WITH DNS CHALLENGE

# The SEPIA folder
SEPIA_FOLDER=~/SEPIA

# Check certbot
if [ -x "$(command -v certbot)" ]
then
	echo "Certbot found: $(command -v certbot)"
else
	echo "Installing certbot ..."
	sudo apt-get update
	sudo apt-get install certbot
	echo ""
fi

# Get domain variable (DOMAIN) set via SEPIA DuckDNS setup
echo "Loading settings from $SEPIA_FOLDER/letsencrypt/duck-dns-settings.sh"
cd $SEPIA_FOLDER/letsencrypt
source duck-dns-settings.sh
if [ -n "$DOMAIN" ]
then
	echo "Domain: $DOMAIN"
	certbot certonly --manual --preferred-challenges=dns --manual-auth-hook $SEPIA_FOLDER/letsencrypt/auth-hook.sh --manual-cleanup-hook $SEPIA_FOLDER/letsencrypt/cleanup-hook.sh -d $DOMAIN --config-dir $SEPIA_FOLDER/letsencrypt/config --logs-dir $SEPIA_FOLDER/letsencrypt/logs --work-dir $SEPIA_FOLDER/letsencrypt/work
	echo "DONE. Restarting nginx ..."
	sudo nginx -s reload
else
	echo "No domain found in settings file. Exiting."
fi
