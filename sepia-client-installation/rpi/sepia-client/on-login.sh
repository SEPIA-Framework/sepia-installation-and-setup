#!/bin/bash
# SEPIA-Client auto-start on (non SSH) login
NOW=$(date +"%Y_%m_%d_%H:%M:%S")
LOG=$(dirname "$BASH_SOURCE")"/log-autostart.out"
echo "Last autostart: $NOW via on-login.sh" > "$LOG"
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
    client_run_script="$HOME/sepia-client/run.sh"
    if [ -z $(cat "$client_run_script" | grep is_headless=1) ]; then
		echo "Command: startx" >> "$LOG"
		exec startx
    else
		echo "Command: bash $client_run_script login" >> "$LOG"
		bash $client_run_script login
    fi
fi
