#!/bin/bash
LOG="$(dirname "$SCRIPT_PATH")""/log-run.out"
LOG_CLIENT="/dev/null"
echo "$(date +'%Y_%m_%d_%H:%M:%S') - Log file: $LOG" >> "$LOG"

is_headless=0

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
                if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
                        # On device call
                        echo "Starting X-Server to support display ..."
                        echo "$(date +'%Y_%m_%d_%H:%M:%S') - Starting X-Server to support display ..." >> "$LOG"
                        startx
                        exit
                else
                        # Call from SSH terminal
                        echo "Cannot start client in display-mode via SSH terminal (no X-Server support)."
                        echo "Please use reboot + auto-login or call directly on device."
                        echo "$(date +'%Y_%m_%d_%H:%M:%S') - Cannot start client in display-mode via SSH terminal (no X-Server support) - Use reboot + auto-login or call directly on device." >> "$LOG"
                        exit
                fi
        fi
fi

# Start Chromium in kiosk mode
echo "$(date +'%Y_%m_%d_%H:%M:%S') - Preparing Chromium ..." >> "$LOG"
client_url="http://localhost:20721/app/index.html"

chromedatadir=~/sepia-client/chromium
if [ -f "$chromedatadir/Default/Preferences" ]; then
        echo "$(date +'%Y_%m_%d_%H:%M:%S') - Setting default preferences for Chromium (permissions: mic, location, notifications)" >> "$LOG"
        sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' $chromedatadir/'Local State'
        sed -i 's/"exited_cleanly":false/"exited_cleanly":true/; s/"exit_type":"[^"]\+"/"exit_type":"Normal"/' $chromedatadir/Default/Preferences
        sed -i 's/"notifications":{}/"notifications":{"http:\/\/localhost:8080,*":{"last_modified":"13224291659276737","setting":1}}/' $chromedatadir/Default/Preferences
        sed -i 's/"geolocation":{}/"geolocation":{"http:\/\/localhost:8080,http:\/\/localhost:8080":{"last_modified":"13224291716729005","setting":1}}/' $chromedatadir/Default/Preferences
        sed -i 's/"media_stream_mic":{}/"media_stream_mic":{"http:\/\/localhost:8080,*":{"last_modified":"13224291643099497","setting":1}}/' $chromedatadir/Default/Preferences
else
        echo "$(date +'%Y_%m_%d_%H:%M:%S') - Could not set default preferences for Chromium (yet?) - Please restart client once more and check if 'chromium/Default/Preferences' was created." >> "$LOG"
fi

default_chrome_flags="--user-data-dir=$chromedatadir --allow-insecure-localhost --autoplay-policy=no-user-gesture-required --disable-infobars --enable-features=OverlayScrollbar --hide-scrollbars --no-default-browser-check --check-for-update-interval=31536000"
chrome_extensions="--load-extension=~/sepia-client/chromium-extensions/sepia-fw"

echo "Running SEPIA-Client in 'display' mode. Use SEPIA Control-HUB to connect and control via remote terminal, default URL is: $clexi_ws_url"
chromium $default_chrome_flags $chrome_extensions --kiosk "$client_url?isApp=true&hasTouch=true" >"$LOG_CLIENT" 2>&1
