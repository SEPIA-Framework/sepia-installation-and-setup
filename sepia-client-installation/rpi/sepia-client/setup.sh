#!/bin/bash
set -e

# check commandline arguments
option=""
breakafterfirst="false"
if [ -n "$1" ]; then
    option=$1
	breakafterfirst="true"
fi

# env
client_settings="$HOME/clexi/www/sepia/settings.js"
clexi_settings="$HOME/clexi/settings.json"
client_run_script="$HOME/sepia-client/run.sh"

# stat menu loop
while true; do
	headless_mode=$(cat "$client_run_script" | grep is_headless= | grep -o .$)
	echo ""
	echo "What would you like to do?"
	echo ""
	echo "CLEXI connection:"
	echo "1: Change CLEXI ID (in CLEXI config and SEPIA Client settings.js)"
	echo ""
	echo "Client mode - Current mode: $headless_mode (0: display, 1: headless, 2: pseudo-headless)"
	echo "2: Set SEPIA Client mode to 'headless'"
	echo "3: Set SEPIA Client mode to 'pseudo-headless' (headless settings + display)"
	echo "4: Set SEPIA Client mode to 'display'"
	echo ""
	echo "SEPIA connection:"
	echo "5: Enter hostname of your SEPIA Server"
	echo "6: Set SEPIA Client device ID"
	echo ""
	echo "Other client settings:"
	echo "7: Activate CLEXI Bluetooth support"
	echo "8: Show audio devices (use this BEFORE settings volume)"
	echo "9: Set and store input/output volume via 'pulsemixer' (new)"
	echo "10: Set and store input/output volume via 'alsamixer' (old)"
	echo "11: Set audio input device (ALSA device - skip for Pulseaudio)"
	echo "12: Set audio output device (ALSA device - skip for Pulseaudio)"
	echo ""
	if [ -z "$option" ]; then
		read -p "Enter a number plz (0 to exit): " option
	else
		echo "Selected by cmd argument: $option"
    fi
	echo ""
	if [ -z "$option" ] || [ $option = "0" ]
	then
		break
	elif [ $option = "1" ]
	then
		read -p "Enter new CLEXI ID: " new_id
		sed -i "s/\"clexiServerId\": \".*\"/\"clexiServerId\": \"$new_id\"/" $client_settings
		sed -i "s/\"id\": \".*\"/\"id\": \"$new_id\"/" $clexi_settings
		echo "------------------------"
		echo "DONE."
		echo "------------------------"
	elif [ $option = "2" ]
	then
		echo "Setting SEPIA Client mode to 'headless'"
		sed -i 's/is_headless=./is_headless=1/' $client_run_script
		echo "------------------------"
		echo "DONE."
		echo "------------------------"
	elif [ $option = "3" ]
	then
		echo "Setting SEPIA Client mode to 'pseudo-headless'"
		sed -i 's/is_headless=./is_headless=2/' $client_run_script
		echo "------------------------"
		echo "DONE."
		echo "------------------------"
	elif [ $option = "4" ]
	then
		echo "Setting SEPIA Client mode to 'display'"
		sed -i 's/is_headless=./is_headless=0/' $client_run_script
		echo "------------------------"
		echo "DONE."
		echo "------------------------"
	elif [ $option = "5" ]
	then
		read -p "Enter new SEPIA Server host address (e.g.: localhost or IP): " new_host
		sed -i "s+\"host-name\": \".*\"+\"host-name\": \"$new_host\"+" $client_settings
		echo "------------------------"
		echo "DONE."
		echo "------------------------"
	elif [ $option = "6" ]
	then
		read -p "Enter new SEPIA Client device ID (e.g. o1): " new_device_id
		sed -i "s/\"deviceId\": \".*\"/\"deviceId\": \"$new_device_id\"/" $client_settings
		echo "------------------------"
		echo "DONE."
		echo "------------------------"
	elif [ $option = "7" ]
	then
		echo "NOTE: This will only work if you did NOT skip Bluetooth during the client installation (skipBLE flag)!"
		read -p "Type 'ok' to add CLEXI 'ble-beacon-scanner' module to settings.json: " add_ble_mod
		if [ -n "$add_ble_mod" ] && [ "$add_ble_mod" = "ok" ]
		then
			has_ble="$(cat "$clexi_settings" | grep ble-beacon-scanner | wc -l)"
            if [ "$has_ble" = "0" ]
			then
				sed -i "s|\"clexi-broadcaster\",|\"clexi-broadcaster\",\"ble-beacon-scanner\",|" $clexi_settings
				echo "Added 'ble-beacon-scanner' to $clexi_settings."
			else
				echo "It seems the module was already active. Check $clexi_settings for 'ble-beacon-scanner'."
			fi
		else
			echo "Ok, maybe later."
		fi
		echo "------------------------"
		echo "DONE."
		echo "------------------------"
	elif [ $option = "8" ]
	then
		sound_card_player_count=$(aplay -l | grep "^card" | wc -l)
		sound_card_recorder_count=$(arecord -l | grep "^card" | wc -l)
		seeed_voicecard_service=$(systemctl list-units --full -all | grep "seeed-voicecard.service" | wc -l)
		if [ $sound_card_player_count -eq 0 ] && [ $sound_card_recorder_count -eq 0 ]; then
			echo ""
			echo "No sound-cards found - RPi Audio HAT service down or service restart required?"
			if [ $seeed_voicecard_service -eq 1 ]; then
				echo "Try:"
				echo "sudo service seeed-voicecard stop && sudo service seeed-voicecard start && aplay -l"
			fi
			echo ""
		else
			echo "Found $sound_card_player_count devices to PLAY audio:"
			aplay -l | grep "^card"
			echo "Found $sound_card_recorder_count devices to RECORD audio:"
			arecord -l | grep "^card"
		fi
		echo "------------------------"
		echo "DONE."
		echo "------------------------"
	elif [ $option = "9" ]
	then
		if [ $(command -v pulsemixer | wc -l) -eq 1 ]; then
			echo "NOTE: Use TAB to switch between input, output and devices!"
			echo ""
			read -p "Press any key to continue (or CTRL+C to abort)."
			pulsemixer
		else
			echo "'pulsemixer' not found - Do you use Pulseaudio?"
		fi
		echo "------------------------"
		echo "DONE."
		echo "------------------------"
	elif [ $option = "10" ]
	then
		echo ""
		echo "NOTE: If 'alsamixer' settings don't have any effect on your audio input/output volume try 'pulsemixer'."
		echo ""
		echo "Inside alsamixer use F5 to show input and output. If your sound-card doesn't show up by default use F6 to switch."
		echo "You might need to edit ~/.asoundrc in certain cases to set the correct default devices (see asound examples in install folder)."
		if [ $seeed_voicecard_service -eq 1 ]; then
			echo "For WM8960 boards (ReSpeaker etc.) check 'Playback' and 'Capture' volumes."
		fi
		echo ""
		read -p "Press any key to continue (or CTRL+C to abort)."
		alsamixer
		alsamixerstate=~/sepia-client/my_amixer_volumes.state
		alsactl --file "$alsamixerstate" store
		echo ""
		echo "Stored alsamixer settings at: $alsamixerstate"
		echo "------------------------"
		echo "DONE."
		echo "------------------------"
	elif [ $option = "11" ]
	then
		current_audio_input="$(cat "$client_run_script" | grep ^audio_input_device)"
		echo "Current audio input device: $current_audio_input"
		read -p "Enter new input device (e.g. from '/etc/asound.conf'): " new_audio_input
		if [ -n "$new_audio_input" ]; then
			sed -i "s/audio_input_device=.*/audio_input_device='$new_audio_input'/" $client_run_script
		fi
		echo "------------------------"
		echo "DONE."
		echo "------------------------"
	elif [ $option = "12" ]
	then
		current_audio_output="$(cat "$client_run_script" | grep ^audio_output_device)"
		echo "Current audio output device: $current_audio_output"
		read -p "Enter new output device (e.g. from '/etc/asound.conf'): " new_audio_output
		if [ -n "$new_audio_output" ]; then
			sed -i "s/audio_output_device=.*/audio_output_device='$new_audio_output'/" $client_run_script
		fi
		echo "------------------------"
		echo "DONE."
		echo "------------------------"
	else
		echo "------------------------"
		echo "Not an option, please try again."
		echo "------------------------"
	fi
	option=""
	if [ $breakafterfirst = "true" ]
	then
		break
	else
		read -p "Press any key to return to menu (or CTRL+C to abort)."
	fi
done
echo "Cu :-) ... ah and don't forget to restart your client ;-)"
echo ""
