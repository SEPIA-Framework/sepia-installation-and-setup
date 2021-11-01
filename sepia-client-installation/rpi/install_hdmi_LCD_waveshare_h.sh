#!/bin/bash
set -e
if [[ $EUID -eq 0 ]]; then
	echo ""
	echo "Setup for: Waveshare 7inch HDMI LCD (H) touchscreen"
    echo "This script will add the following entries to your '/boot/config.txt':"
	echo ""
	echo "max_usb_current=1"
	echo "hdmi_force_hotplug=1"
	echo "config_hdmi_boost=10"
	echo "hdmi_group=2"
	echo "hdmi_mode=87"
	echo "hdmi_cvt 1024 600 60 6 0 0 0"
	echo ""
	echo "The following lines will be removed:"
	echo ""
	echo "dtoverlay=vc4-fkms-v3d"
	echo ""
	echo "NOTE: Old entries with the same name will be removed."
	echo "If you are not sure if this works for your display or confix.txt please edit the file manually."
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
sed -i '/^max_usb_current=/d' $bootfile
sed -i '/^hdmi_force_hotplug=/d' $bootfile
sed -i '/^config_hdmi_boost=/d' $bootfile
sed -i '/^hdmi_group=/d' $bootfile
sed -i '/^hdmi_mode=/d' $bootfile
sed -i '/^hdmi_cvt 1024 600 60 6 0 0 0/d' $bootfile
# add new
echo "max_usb_current=1" >> $bootfile
echo "hdmi_force_hotplug=1" >> $bootfile
echo "config_hdmi_boost=10" >> $bootfile
echo "hdmi_group=2" >> $bootfile
echo "hdmi_mode=87" >> $bootfile
echo "hdmi_cvt 1024 600 60 6 0 0 0" >> $bootfile
echo ""
echo "DONE. Have fun :-)"
echo ""