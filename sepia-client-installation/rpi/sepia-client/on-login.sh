#!/bin/bash
# SEPIA-Client auto-start on (non SSH) login
SCRIPT_PATH="$(realpath "$BASH_SOURCE")"
LOG="$(dirname "$SCRIPT_PATH")""/log-autostart.out"
NOW=$(date +"%Y_%m_%d_%H:%M:%S")

# Display mode: "xserver" (X11 + Openbox) or "wayland" (Wayland + labwc)
# NOTE: this value is set during installation via install_sepia_client.sh
DISPLAY_MODE="xserver"

# Trigger only on device (ignore SSH logins):
if [[ ! $DISPLAY && ! $WAYLAND_DISPLAY && $XDG_VTNR -eq 1 ]]; then
	echo "===========================================" > "$LOG"
	echo "Last autostart: $NOW via on-login.sh" >> "$LOG"
	echo "DISPLAY_MODE=$DISPLAY_MODE" >> "$LOG"
	echo "XDG_SESSION_TYPE=$XDG_SESSION_TYPE" >> "$LOG"
	echo "XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR" >> "$LOG"
	echo "XDG_VTNR=$XDG_VTNR" >> "$LOG"
	echo "Kernel: $(uname -r)" >> "$LOG"
	echo "DRI devices: $(ls /dev/dri/ 2>/dev/null || echo 'none')" >> "$LOG"
	echo "===========================================" >> "$LOG"
	client_run_script="$HOME/sepia-client/run.sh"
	if [ "$(cat "$client_run_script" | grep is_headless=1 | wc -l)" = "0" ]; then
		# Client with display:
		if [ "$DISPLAY_MODE" = "wayland" ]; then
			echo "Command: labwc" >> "$LOG"
			echo "NOTE: labwc logs can be found at: ~/.local/share/labwc/labwc.log" >> "$LOG"
			exec labwc
		else
			echo "Command: startx" >> "$LOG"
			echo "NOTE: X server logs can be found at: ~/.local/share/xorg/Xorg.0.log (user) or /var/log/Xorg.0.log (root/SUID)" >> "$LOG"
			exec startx
		fi
	else
		# Headless client:
		echo "Command: bash $client_run_script login" >> "$LOG"
		bash $client_run_script login
	fi
fi
