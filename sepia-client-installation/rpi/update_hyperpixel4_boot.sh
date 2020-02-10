#!/bin/bash
set -e
if [[ $EUID -eq 0 ]]; then
    echo "This script will try to fix your Hyperpixel 4.0 touchscreen calibration and orientation."
else
	echo "This script needs to be run as root via 'sudo'"
	exit
fi
echo "Are you sure that you want to continue?"
read -p "Enter 'yes' to continue: " yesno
echo ""
if [ -n "$yesno" ] && [ $yesno = "yes" ]; then
	echo "Ok. Let's go ;-)"	
else
	echo "Ok, cu later :-)"
	exit
fi
bootfile="/boot/config.txt"
echo "Updating $bootfile ..."
# clean up
sed -i 's/^dtoverlay=vc4-fkms-v3d/#dtoverlay=vc4-fkms-v3d/' $bootfile
sed -i '/^display_lcd_rotate=/d' $bootfile
sed -i '/^dtparam=touchscreen-swapped-x-y/d' $bootfile
sed -i '/^dtparam=touchscreen-inverted-x/d' $bootfile
sed -i '/^dtparam=touchscreen-inverted-y/d' $bootfile
# add new
sed -i '/\[all\]/ a display_lcd_rotate=2' $bootfile
echo "Set display_lcd_rotate=2"
sed -i '/dtoverlay=hyperpixel4/ a dtparam=touchscreen-swapped-x-y' $bootfile
echo "Set dtparam=touchscreen-swapped-x-y"
if grep -q "dtoverlay=gpio-poweroff,gpiopin=19,active_low=1" $bootfile; then 
    echo "Found 'dtoverlay=gpio-poweroff,gpiopin=19,active_low=1'"
else
    echo "dtoverlay=gpio-poweroff,gpiopin=19,active_low=1" >> $bootfile
	echo "Added 'dtoverlay=gpio-poweroff,gpiopin=19,active_low=1'"
fi
