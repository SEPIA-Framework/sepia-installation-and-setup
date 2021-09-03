#!/bin/bash
set -e
CLIENT_BRANCH="master"
if [ -n "$1" ]; then
	CLIENT_BRANCH="$1"
fi
NOW=$(date +"%Y_%m_%d_%H%M%S")
echo "Saving backup of old settings ..."
cp ~/clexi/www/sepia/settings.js ~/clexi/www/sepia/settings_$NOW.js
echo "Updating SEPIA Client from current '$CLIENT_BRANCH' branch ..."
mkdir -p ~/clexi/www/sepia
mkdir -p ~/tmp
git clone --single-branch -b $CLIENT_BRANCH https://github.com/SEPIA-Framework/sepia-html-client-app.git ~/tmp/sepia-client-git
cp -rf ~/tmp/sepia-client-git/www/* ~/clexi/www/sepia/
rm -rf ~/tmp/sepia-client-git
echo "DONE"
