#!/bin/bash

# Check Chromium
is_chromium_running=0
case "$(ps aux | grep chromium-browser)" in *"sepia-client"*) is_chromium_running=1;; *) is_chromium_running=0;; esac
if [ "$is_chromium_running" -eq "1" ]; then
    echo "Chromium with SEPIA is: active"
else
    echo "Chromium with SEPIA is: off"
fi

# Check Xvfb
is_xvfb_running=0
case "$(ps aux | grep Xvfb)" in *"Xvfb :2072"*) is_xvfb_running=1;; *) is_xvfb_running=0;; esac
if [ "$is_xvfb_running" -eq "1" ]; then
    echo "Xvfb server is: active"
else
    echo "Xvfb server is: off"
fi

# Check CLEXI
is_clexi_running=0
case "$(ps aux | grep clexi)" in *clexi-server.js*) is_clexi_running=1;; *) is_clexi_running=0;; esac
if [ "$is_clexi_running" -eq "1" ]; then
    echo "CLEXI server is: active"
else
    echo "CLEXI server is: off"
fi
