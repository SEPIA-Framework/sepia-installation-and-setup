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
echo ""
echo "Do you want to install a service that tries to turn off the backlight automatically on shutdown? (Recommended for Linux kernel >= 5, e.g. Raspberry OS >= August 2020)"
read -p "Enter 'yes' to install the service: " yesno2
echo ""
if [ -n "$yesno2" ] && [ $yesno2 = "yes" ]; then
	echo "Ok"	
	cp hyperpixel4-backlight.service /etc/systemd/system/
	systemctl enable hyperpixel4-backlight.service
else
	echo "Do you want to try the old way of switching of backlight on shutdown? (Recommended for Linux kernel < 5)"
	read -p "Enter 'yes' to install the service: " yesno3
	echo ""
	if [ -n "$yesno3" ] && [ $yesno3 = "yes" ]; then
		echo "Ok"	
		if grep -q "dtoverlay=gpio-poweroff,gpiopin=19,active_low=1" $bootfile; then 
			echo "Found 'dtoverlay=gpio-poweroff,gpiopin=19,active_low=1'"
		else
			echo "dtoverlay=gpio-poweroff,gpiopin=19,active_low=1" >> $bootfile
			echo "Added 'dtoverlay=gpio-poweroff,gpiopin=19,active_low=1'"
		fi
	else
		echo "Ok, maybe later :-)"
	fi
fi
echo ""
echo "INFO: Here are some commands that might be useful to control the backlight manually:"
echo "- raspi-gpio set 19 op dl"
echo "- DISPLAY=:0.0 xset dpms force off"
echo "- echo '1' > /sys/class/backlight/rpi_backlight/bl_power"
echo ""
echo "DONE. Have fun :-)"
echo ""