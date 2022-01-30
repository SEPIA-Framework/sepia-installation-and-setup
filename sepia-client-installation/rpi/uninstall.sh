#!/bin/bash
set -e
clear
echo "This will backup some settings and then remove:"
echo "- SEPIA entry in '~/.bashrc'"
echo "- SEPIA client folder"
echo "- CLEXI folder"
echo "- Openbox and '~/.config/openbox'"
echo "- Chromium"
echo "- Nginx with SEPIA config"
echo "- '~/.asoundrc'"
echo ""
read -p "Press any key to continue (or CTRL+C to abort)."
echo ""
NOW=$(date +"%Y_%m_%d_%H%M%S")
echo "Make sure everything is shutdown ..."
cd "$HOME/sepia-client"
bash shutdown.sh
echo "Creating backup at '$HOME/sepia-client_bck_$NOW' ..."
cd "$HOME"
mkdir -p "sepia-client_bck_$NOW/clexi/www/sepia"
cp clexi/www/sepia/settings.js "sepia-client_bck_$NOW/clexi/www/sepia/"
cp clexi/settings.json "sepia-client_bck_$NOW/clexi/"
if [ -f ".asoundrc" ]; then
	cp ".asoundrc" "sepia-client_bck_$NOW/"
fi
cp -r "sepia-client/chromium" "sepia-client_bck_$NOW/"
mkdir -p "sepia-client_bck_$NOW/nginx"
cp /etc/nginx/sites-enabled/sepia* "sepia-client_bck_$NOW/nginx/"
echo ""
echo "Removing .bashrc entries ..."
sed -i '/^# Run SEPIA-Client/,+4d' ".bashrc"
echo ""
echo "Removing SEPIA client and CLEXI folders ..."
rm -rf sepia-client
rm -rf clexi
echo ""
echo "Removing Openbox, Nginx and Chromium ..."
rm -rf ".config/openbox"
sudo rm -rf /etc/nginx/sites-enabled/sepia*
sudo apt-get remove openbox nginx chromium chromium-browser
sudo service nginx restart
echo ""
if [ -f ".asoundrc" ]; then
	echo "Removing .asoundrc ..."
	rm -rf ".asoundrc"
fi
echo ""
echo "DONE"