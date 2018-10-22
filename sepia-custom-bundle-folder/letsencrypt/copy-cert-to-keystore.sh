#!/bin/bash

# The SEPIA folder
SEPIA_FOLDER=~/SEPIA

# Get domain variable (DOMAIN) set via SEPIA DuckDNS setup
echo "Loading settings from $SEPIA_FOLDER/letsencrypt/duck-dns-settings.sh"
cd $SEPIA_FOLDER/letsencrypt
source duck-dns-settings.sh
if [ -n "$DOMAIN" ]
then
	echo "Domain: $DOMAIN"
	echo "Cleanig up old files..."
	if [ -f "sepia-proxy-keystore.p12" ]
	then
		rm sepia-proxy-keystore.p12
	fi
	if [ -f "sepia-proxy-keystore.jks" ]
	then
		rm sepia-proxy-keystore.jks
	fi
	openssl pkcs12 -export -in config/live/$DOMAIN/fullchain.pem -inkey config/live/$DOMAIN/privkey.pem -out sepia-proxy-keystore.p12 -name sepia-proxy-keystore -passout pass:noextrapwdhere
	if [ $? -ne 0 ]
	then
		echo "Failed to convert PEM files!"
		exit 1
	fi
	keytool -importkeystore -deststorepass noextrapwdhere  -destkeypass noextrapwdhere -destkeystore sepia-proxy-keystore.jks -deststoretype PKCS12 -srckeystore sepia-proxy-keystore.p12 -srcstoretype PKCS12 -srcstorepass noextrapwdhere -alias sepia-proxy-keystore
	if [ $? -ne 0 ]
	then
		echo "Failed to create keystore!"
		exit 1
	else
		echo "Done! New keystore can be used. Consider restarting proxy now."
	fi
else
	echo "No domain found in settings file. Exiting."
fi
