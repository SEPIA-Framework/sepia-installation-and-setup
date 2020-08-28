#!/bin/bash
set -e

# Client mode
is_headless=1

# Source and XServer check
script_source=""
is_xserver_running=0
if [ -n "$1" ]; then
    script_source=$1
fi
if [ "$script_source" = "xserver" ] || [ -n "$DISPLAY" ]; then
	is_xserver_running=1
fi
if [ "$is_xserver_running" -eq "0" ]; then
	if [ "$is_headless" -eq "0" ] || [ "$is_headless" -eq "2" ]; then
		echo "Starting X-Server to support display ..."
		startx
		exit
	fi
fi

# Notify user
headphone_count=$(amixer scontrols | grep "Headphone" | wc -l)
if [ $headphone_count -gt 0 ];
then
    amixer sset 'Headphone' 80%
fi
espeak-ng "Hello friend! I'll be right there, just a second."

# Start CLEXI
cd ~/clexi
is_clexi_running=0
case "$(ps aux | grep clexi)" in *clexi-server.js*) is_clexi_running=1;; *) is_clexi_running=0;; esac
if [ "$is_clexi_running" -eq "1" ]; then
    echo "Restarting CLEXI server"
    pkill -f "clexi-server.js"
    sleep 2
else
    echo "Starting CLEXI server"
fi
nohup node --title=clexi-server.js server.js &> log.out&
sleep 2

# Start Chromium in kiosk mode
client_url="http://localhost:8080/sepia/index.html"
clexi_ws_url="ws://[IP]:9090/clexi"
chromedatadir=~/sepia-client/chromium
if [ -f "$chromedatadir/Default/Preferences" ]; then
    sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' $chromedatadir/'Local State'
    sed -i 's/"exited_cleanly":false/"exited_cleanly":true/; s/"exit_type":"[^"]\+"/"exit_type":"Normal"/' $chromedatadir/Default/Preferences
    sed -i 's/"notifications":{}/"notifications":{"http:\/\/localhost:8080,*":{"last_modified":"13224291659276737","setting":1}}/' $chromedatadir/Default/Preferences
    sed -i 's/"geolocation":{}/"geolocation":{"http:\/\/localhost:8080,http:\/\/localhost:8080":{"last_modified":"13224291716729005","setting":1}}/' $chromedatadir/Default/Preferences
    sed -i 's/"media_stream_mic":{}/"media_stream_mic":{"http:\/\/localhost:8080,*":{"last_modified":"13224291643099497","setting":1}}/' $chromedatadir/Default/Preferences
fi
audio_input_device='default'
audio_output_device='default'
default_chrome_flags="--user-data-dir=$chromedatadir --alsa-output-device=$audio_output_device --alsa-input-device=$audio_input_device --allow-insecure-localhost --autoplay-policy=no-user-gesture-required --disable-infobars --enable-features=OverlayScrollbar --hide-scrollbars --no-default-browser-check --check-for-update-interval=31536000"
# headless or with display:
pi_model=$(tr -d '\0' </proc/device-tree/model)
is_pi4=0
case "$pi_model" in *"Pi 4"*) is_pi4=1;; *) is_pi4=0;; esac
echo "RPi model: $pi_model - Is Pi4: $is_pi4"
if [ "$is_headless" -eq "0" ]; then
	echo "Running SEPIA-Client in 'display' mode. Use SEPIA Control-HUB to connect and control via remote terminal, default URL is: $clexi_ws_url"
	chromium-browser $default_chrome_flags --kiosk "$client_url?isApp=true" >/dev/null 2>&1
elif [ "$is_headless" -eq "2" ]; then
	echo "Running SEPIA-Client in 'pseudo-headless' mode. Use SEPIA Control-HUB to connect and control via remote terminal, default URL is: $clexi_ws_url"
	chromium-browser $default_chrome_flags --kiosk "$client_url?isApp=true&isHeadless=true" >/dev/null 2>&1
elif [ "$is_pi4" = "1" ]; then
	echo "Running SEPIA-Client in 'headless Pi4' mode. Use SEPIA Control-HUB to connect and control via remote terminal, default URL is: $clexi_ws_url"
    xvfb-run -n 2072 --server-args="-screen 0 500x800x24" chromium-browser --disable-features=VizDisplayCompositor $default_chrome_flags --kiosk "$client_url?isApp=true&isHeadless=true" >/dev/null 2>&1
else
	echo "Running SEPIA-Client in 'headless' mode. Use SEPIA Control-HUB to connect and control via remote terminal, default URL is: $clexi_ws_url"
    xvfb-run -n 2072 --server-args="-screen 0 320x480x16" chromium-browser $default_chrome_flags --kiosk "$client_url?isApp=true&isHeadless=true" >/dev/null 2>&1
fi
echo "Closed SEPIA-Client. Cu later :-)"
espeak-ng "Bye bye, see you!"
