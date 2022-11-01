#!/bin/bash

# Install X-Server and Openbox
sudo pacman -S xorg-server xorg-xinit xorg-server-xvfb xterm openbox unclutter

# Add Openbox to X-Server autostart
cd $HOME
echo "exec openbox-session" >> .xinitrc

# Copy some Openbox settings
mkdir -p $HOME/.config/openbox
cp /etc/xdg/openbox/rc.xml $HOME/.config/openbox/
cp /etc/xdg/openbox/menu.xml $HOME/.config/openbox/
wget https://raw.githubusercontent.com/SEPIA-Framework/sepia-installation-and-setup/master/sepia-client-installation/rpi/openbox
mv openbox $HOME/.config/openbox/autostart.sh

# Install Chromium with SEPIA extension and user folder
sudo pacman -S chromium
mkdir -p $HOME/sepia-client/chromium
mkdir -p $HOME/sepia-client/chromium-extensions/sepia-fw
cd $HOME/sepia-client
mkdir -p tmp
git clone --single-branch -b master https://github.com/SEPIA-Framework/sepia-browser-extensions tmp/sepia-client-browser-ex-git
mv tmp/sepia-client-browser-ex-git/chromium/* ~/sepia-client/chromium-extensions/sepia-fw/
rm -rf tmp/sepia-client-browser-ex-git