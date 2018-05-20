#!/bin/sh

# INSTALL CERTBOT FOR LET'S ENCRYPT

# Debian Stretch
sudo apt-get install certbot

# Debian Jessie - see: https://backports.debian.org/Instructions/
# sudo apt-get install certbot -t jessie-backports

# CALL CERTBOT WITH DNS CHALLENGE

# The SEPIA folder
SEPIA_FOLDER="~/SEPIA"

# Get domain variable (DOMAIN) set via SEPIA DuckDNS setup
source $SEPIA_FOLDER/letsencrypt/duck-dns-settings.sh
certbot certonly --manual --preferred-challenges=dns --manual-auth-hook $SEPIA_FOLDER/letsencrypt/auth-hook.sh --manual-cleanup-hook $SEPIA_FOLDER/letsencrypt/cleanup-hook.sh -d $DOMAIN
