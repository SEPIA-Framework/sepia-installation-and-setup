#!/bin/bash
# SEPIA-Client auto-start on (non SSH) login
SCRIPT_PATH="$(realpath "$BASH_SOURCE")"
LOG="$(dirname "$SCRIPT_PATH")""/log-autostart.out"
NOW=$(date +"%Y_%m_%d_%H:%M:%S")
echo "Last autostart: $NOW via on-login.sh" > "$LOG"
# Ignore SSH logins:
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
    client_run_script="$HOME/sepia-client/run.sh"
    if [ -z $(cat "$client_run_script" | grep is_headless=1) ]; then
		# Client with display:
		echo "Command: startx" >> "$LOG"
		exec startx
    else
		# Headless client:
		echo "Command: bash $client_run_script login" >> "$LOG"
		bash $client_run_script login
    fi
fi
