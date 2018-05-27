#!/bin/bash

# INSTALL CERTBOT FOR LET'S ENCRYPT

# Debian Stretch
sudo apt-get install certbot

# Debian Jessie - see: https://backports.debian.org/Instructions/
# sudo apt-get install certbot -t jessie-backports

# CALL CERTBOT WITH DNS CHALLENGE

# The SEPIA folder
SEPIA_FOLDER=~/SEPIA

# Run certbot script
cd $SEPIA_FOLDER/letsencrypt
./run-certbot-duckdns.sh
