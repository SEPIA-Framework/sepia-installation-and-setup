#!/bin/bash
# SEPIA-Client auto-start on (non SSH) login
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
    client_run_script="$HOME/sepia-client/run.sh"
    if [ -z $(cat "$client_run_script" | grep is_headless=1) ]; then
        exec startx
    else
        bash $client_run_script login
    fi
fi