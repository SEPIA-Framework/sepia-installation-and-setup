#!/bin/bash

# Stop Chromium - NOTE: 'chromium-browser' was replaced by 'chromium' because of version issues
is_chromium_running=0
case "$(ps aux | grep chromium)" in *"sepia-client"*) is_chromium_running=1;; *) is_chromium_running=0;; esac
if [ "$is_chromium_running" -eq "1" ]; then
    echo "Stopping Chromium with SEPIA"
    #kill $(ps aux | grep "[c]hromium-browser .*sepia-client" | awk '{print $2}')
    kill $(ps aux | grep "[c]hromium.*sepia-client.*index.html" | awk '{print $2}')
    sleep 2
else
    echo "It seems no Chromium with SEPIA was running"
fi

# Stop Xvfb
is_xvfb_running=0
case "$(ps aux | grep Xvfb)" in *"Xvfb :2072"*) is_xvfb_running=1;; *) is_xvfb_running=0;; esac
if [ "$is_xvfb_running" -eq "1" ]; then
    echo "Stopping Xvfb server"
    kill $(ps aux | grep '[X]vfb :2072' | awk '{print $2}')
    sleep 2
else
    echo "It seems no Xvfb server was running"
fi

# Stop CLEXI
is_clexi_running=0
case "$(ps aux | grep clexi)" in *clexi-server.js*) is_clexi_running=1;; *) is_clexi_running=0;; esac
if [ "$is_clexi_running" -eq "1" ]; then
    echo "Stopping CLEXI server"
    pkill -f "clexi-server.js"
else
    echo "It seems no CLEXI server was running"
fi

echo ""
echo "DONE."