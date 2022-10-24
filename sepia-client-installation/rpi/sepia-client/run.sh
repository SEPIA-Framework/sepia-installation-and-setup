#!/bin/bash
set -e
SCRIPT_PATH="$(realpath "$BASH_SOURCE")"
LOG="$(dirname "$SCRIPT_PATH")""/log-run.out"
LOG_CLIENT="/dev/null"
#LOG_CLIENT="$(dirname "$SCRIPT_PATH")""/log-client.out"
echo "Last run attempt: $(date +'%Y_%m_%d_%H:%M:%S') - via: run.sh" > "$LOG"

# Client mode
is_headless=1
chromium_remote_debug=0

# Check sound devices
sound_card_player_count=$(aplay -l | grep -E "^[[:alpha:]]+ [[:digit:]]" | wc -l)
sound_card_recorder_count=$(arecord -l | grep -E "^[[:alpha:]]+ [[:digit:]]" | wc -l)
echo "$(date +'%Y_%m_%d_%H:%M:%S') - Found sound-cards to play audio: $sound_card_player_count" >> "$LOG"
echo "$(date +'%Y_%m_%d_%H:%M:%S') - Found sound-cards to record audio: $sound_card_recorder_count" >> "$LOG"
if [ $sound_card_recorder_count -eq 0 ]; then
	echo "$(date +'%Y_%m_%d_%H:%M:%S') - No recorder found - RPi Audio HAT service down or restart required?" >> "$LOG"
	# TODO: restart service if known one exists
	seeed_voicecard_service=$(systemctl list-units --full -all | grep "seeed-voicecard.service" | wc -l)
	if [ $seeed_voicecard_service -eq 1 ]; then
		echo "$(date +'%Y_%m_%d_%H:%M:%S') - Trying to restart seeed-voicecard.service" >> "$LOG"
		sudo service seeed-voicecard stop && sudo service seeed-voicecard start
		sleep 3
	fi
fi

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

# Restore alsamixer settings (if you use Pulseaudio maybe skip this)
alsamixerstate=~/sepia-client/my_amixer_volumes.state
if [ -f "$alsamixerstate" ]; then
	echo "Restoring alsamixer settings from: $alsamixerstate"
	echo "$(date +'%Y_%m_%d_%H:%M:%S') - Restoring alsamixer settings from: $alsamixerstate" >> "$LOG"
	alsactl --file "$alsamixerstate" restore
	echo "$(date +'%Y_%m_%d_%H:%M:%S') - alsamixer settings restored. NOTE: If you use Pulseaudio you might need to delete the state file." >> "$LOG"
fi
# Set volume for specific amixer controls
# headphone_count=$(amixer scontrols | grep "Headphone" | wc -l)
# if [ $headphone_count -gt 0 ];
# then
#    amixer sset 'Headphone' 80%
#    echo "Note: Automatically set headphone input volume to 80%"
# fi

# Restore Pulseaudio settings
#echo "$(date +'%Y_%m_%d_%H:%M:%S') - Loading Pulseaudio modules"
#bash $HOME/install/pulseaudio/aec_only.sh
#
# Prevent Pulseaudio suspending - Improves reaction time of input/ouput but might lead to low vol constant white-noise in speaker
if [ $(pactl list modules short | grep module-suspend-on-idle | wc -l) -gt 0 ]; then
	pactl unload-module module-suspend-on-idle
	echo "$(date +'%Y_%m_%d_%H:%M:%S') - Pulseaudio: unloaded module 'module-suspend-on-idle'" >> "$LOG"
fi

# Notify user
echo "$(date +'%Y_%m_%d_%H:%M:%S') - Notifying user (audio message) ..." >> "$LOG"
espeak-ng "Hello friend! I'll be right there, just a second."

# Start CLEXI
echo "$(date +'%Y_%m_%d_%H:%M:%S') - Starting CLEXI ..." >> "$LOG"
cd ~/clexi
is_clexi_running=0
case "$(ps aux | grep clexi)" in *clexi-server.js*) is_clexi_running=1;; *) is_clexi_running=0;; esac
if [ "$is_clexi_running" -eq "1" ]; then
	echo "Restarting CLEXI server"
	echo "$(date +'%Y_%m_%d_%H:%M:%S') - CLEXI already running, restarting ..." >> "$LOG"
	pkill -f "clexi-server.js"
	sleep 2
else
	echo "Starting CLEXI server"
fi
nohup node --title=clexi-server.js server.js &> log-clexi.out&
echo "$(date +'%Y_%m_%d_%H:%M:%S') - CLEXI ready" >> "$LOG"
sleep 2

# Start Chromium in kiosk mode
echo "$(date +'%Y_%m_%d_%H:%M:%S') - Preparing Chromium ..." >> "$LOG"
client_url="http://localhost:8080/sepia/index.html"
clexi_ws_url="ws://[IP]:9090/clexi"
# NOTE: 'chromium-browser' was replaced by 'chromium' because of version issues - Better keep an eye on this
chromecmd=""
if [ -n "$(command -v chromium-browser)" ]; then
	chromecmd="chromium-browser"
elif [ -n "$(command -v chromium)" ]; then
	chromecmd="chromium"
else
	echo "$(date +'%Y_%m_%d_%H:%M:%S') - Chromium seems to be missing! Please reinstall browser!" >> "$LOG"
	exit
fi
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
audio_input_device='default'
audio_output_device='default'
default_chrome_flags="--user-data-dir=$chromedatadir --alsa-output-device=$audio_output_device --alsa-input-device=$audio_input_device --allow-insecure-localhost --autoplay-policy=no-user-gesture-required --disable-infobars --enable-features=OverlayScrollbar --hide-scrollbars --no-default-browser-check --check-for-update-interval=31536000"
#NOTE: It seems there is a new fix for Chromium 98 required: '--use-gl=egl' (https://github.com/RPi-Distro/chromium-browser/issues/28)
#default_chrome_flags="$default_chrome_flags --use-gl=egl"
#If you can't resolve your self-signed SSL issues (and you know what you're doing ^^):
#default_chrome_flags="$default_chrome_flags --ignore-certificate-errors --unsafely-treat-insecure-origin-as-secure=http://sepia-home.local"
if [ "$chromium_remote_debug" -eq "1" ]; then
	default_chrome_flags="--remote-debugging-port=9222 ""$default_chrome_flags"
	echo "Remote debugging on port 9222 ACTIVE! To access externally use SSH tunnel or proxy port."
	echo "$(date +'%Y_%m_%d_%H:%M:%S') - REMOTE DEBUGGING for Chromium on port 9222 ACTIVE" >> "$LOG"
fi
# comma separated list of extensions:
chrome_extensions="--load-extension=~/sepia-client/chromium-extensions/sepia-fw"
# headless or with display:
pi_model=$(tr -d '\0' </proc/device-tree/model)
is_pi4=0
case "$pi_model" in *"Pi 4"*) is_pi4=1;; *) is_pi4=0;; esac
echo "RPi model: $pi_model - Is Pi4: $is_pi4"
echo "$(date +'%Y_%m_%d_%H:%M:%S') - Starting Chromium - Mode: $is_headless - Is RPi4: $is_pi4" >> "$LOG"
if [ "$is_headless" -eq "0" ]; then
	echo "Running SEPIA-Client in 'display' mode. Use SEPIA Control-HUB to connect and control via remote terminal, default URL is: $clexi_ws_url"
	$chromecmd $default_chrome_flags $chrome_extensions --kiosk "$client_url?isApp=true&hasTouch=true" >"$LOG_CLIENT" 2>&1
elif [ "$is_headless" -eq "2" ]; then
	echo "Running SEPIA-Client in 'pseudo-headless' mode. Use SEPIA Control-HUB to connect and control via remote terminal, default URL is: $clexi_ws_url"
	$chromecmd $default_chrome_flags $chrome_extensions --kiosk "$client_url?isApp=true&isHeadless=true&hasTouch=true" >"$LOG_CLIENT" 2>&1
elif [ "$is_pi4" = "1" ]; then
	echo "Running SEPIA-Client in 'headless Pi4' mode. Use SEPIA Control-HUB to connect and control via remote terminal, default URL is: $clexi_ws_url"
	xvfb-run -n 2072 --server-args="-screen 0 500x800x24" $chromecmd --disable-features=VizDisplayCompositor $default_chrome_flags $chrome_extensions --kiosk "$client_url?isApp=true&isHeadless=true" >"$LOG_CLIENT" 2>&1
else
	echo "Running SEPIA-Client in 'headless' mode. Use SEPIA Control-HUB to connect and control via remote terminal, default URL is: $clexi_ws_url"
	xvfb-run -n 2072 --server-args="-screen 0 320x480x16" $chromecmd $default_chrome_flags $chrome_extensions --kiosk "$client_url?isApp=true&isHeadless=true" >"$LOG_CLIENT" 2>&1
fi
echo "Closed SEPIA-Client. Cu later :-)"
echo "$(date +'%Y_%m_%d_%H:%M:%S') - Closed SEPIA-Client" >> "$LOG"
espeak-ng "Bye bye, see you!"
