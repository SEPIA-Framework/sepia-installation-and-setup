#!/bin/bash
#
# make sure we are in the right folder
SCRIPT_PATH="$(realpath "$BASH_SOURCE")"
SEPIA_FOLDER="$(dirname "$SCRIPT_PATH")"
LOG="${SEPIA_FOLDER}/startup-log.out"
cd "$SEPIA_FOLDER"
echo "$(date +'%Y_%m_%d_%H:%M:%S') - Running cluster test ..." >> "$LOG"
#
# set local Java path
if [ -f "java/version" ]; then
	new_java_home=$(cat java/version)
	export JAVA_HOME=$(pwd)/java/$new_java_home
	export PATH=$JAVA_HOME/bin:$PATH
	echo "Found local Java version: $JAVA_HOME"
	echo
fi
# check commandline arguments
do_all_tests=0
if [ -n "$1" ]; then
	if [ $1 = "all" ]; then
		do_all_tests=1
	fi
fi
#
RES_CODE=0
#
cd sepia-assist-server
TOOLS_JAR=$(ls | grep "^sepia-core-tools.*jar" | tail -n 1)
echo -e "\n-----Assist API-----\n"
java -jar $TOOLS_JAR connection-check httpGetJson -url=http://localhost:20721/ping -maxTries=3 -waitBetween=1500 -expectKey=result -expectValue=success
if [ $? -eq 0 ]
then
	echo "OK"
	echo "$(date +'%Y_%m_%d_%H:%M:%S') - Assist API: OK" >> "$LOG"
else
	echo "Error: Assist API NOT working or NOT reachable (localhost:20721)"
	echo "$(date +'%Y_%m_%d_%H:%M:%S') - Assist API: ERROR" >> "$LOG"
	curl --silent -X GET http://localhost:20721/ping
	RES_CODE=1
	if [ $do_all_tests -eq 0 ]; then
		exit 1
	fi
fi
echo -e "\n-----Teach API-----\n"
java -jar $TOOLS_JAR connection-check httpGetJson -url=http://localhost:20722/ping -maxTries=3 -waitBetween=1500 -expectKey=result -expectValue=success
if [ $? -eq 0 ]
then
	echo "OK"
	echo "$(date +'%Y_%m_%d_%H:%M:%S') - Teach API: OK" >> "$LOG"
else
	echo "Error: Teach API NOT working or NOT reachable (localhost:20722)"
	echo "$(date +'%Y_%m_%d_%H:%M:%S') - Teach API: ERROR" >> "$LOG"
	curl --silent -X GET http://localhost:20722/ping
	RES_CODE=1
fi
echo -e "\n-----Chat API - WebSocket Server-----\n"
java -jar $TOOLS_JAR connection-check httpGetJson -url=http://localhost:20723/ping -maxTries=3 -waitBetween=1500 -expectKey=result -expectValue=success
if [ $? -eq 0 ]
then
	echo "OK"
	echo "$(date +'%Y_%m_%d_%H:%M:%S') - Chat API: OK" >> "$LOG"
else
	echo "Error: Chat API NOT working or NOT reachable (localhost:20723)"
	echo "$(date +'%Y_%m_%d_%H:%M:%S') - Chat API: ERROR" >> "$LOG"
	curl --silent -X GET http://localhost:20723/ping
	RES_CODE=1
fi
echo -e "\n-----Proxy-----\n"
PROXY_URL=
PROXY_MODE=
PROXY_HAS_SS_SSL="false"
PROXY_STATUS=
if [ "$(ls -l /etc/nginx/sites-enabled/sepia-fw-https-self-* 2> /dev/null | wc -l)" -gt 0 ]
then
	# check non-ssl localhost version on port 20727 to avoid any cert issues locally
	PROXY_URL=http://localhost:20727/sepia/assist/ping
	PROXY_MODE="self-signed SSL + fallback"
	PROXY_HAS_SS_SSL="true"
	# PROXY_URL=https://$(hostname -s).local:20726/sepia/assist/ping
elif [ "$(ls -l /etc/nginx/sites-enabled/sepia-fw-http* 2> /dev/null | wc -l)" -gt 0 ]
then
	PROXY_URL=http://localhost:20726/sepia/assist/ping
	PROXY_MODE="Default/no SSL"
fi
if [ -z "$PROXY_URL" ]
then
	echo "No NGINX proxy configuration found at: '/etc/nginx/sites-enabled/'"
	echo "$(date +'%Y_%m_%d_%H:%M:%S') - Skipped - No proxy configuration found at: '/etc/nginx/sites-enabled/'" >> "$LOG"
else
	echo "Proxy URL: $PROXY_URL"
	java -jar $TOOLS_JAR connection-check httpGetJson -url=$PROXY_URL -maxTries=3 -waitBetween=1500 -expectKey=result -expectValue=success
	if [ $? -eq 0 ]
	then
		echo "Proxy OK"
		echo "$(date +'%Y_%m_%d_%H:%M:%S') - Proxy OK - URL: $PROXY_URL" >> "$LOG"
		PROXY_STATUS="OK"
	else
		echo "Info: Proxy seems to be OFFLINE!"
		echo "$(date +'%Y_%m_%d_%H:%M:%S') - Proxy OFFLINE - URL: $PROXY_URL" >> "$LOG"
		PROXY_STATUS="OFFLINE"
	fi
fi
if [ -f "Xtensions/TTS/marytts/bin/marytts-server" ]; then
	echo -e '\n-----Extensions-----\n'
	STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:59125/voices)
	if [ $STATUS -eq 200 ]; then
		echo "MaryTTS server is running."
		echo "$(date +'%Y_%m_%d_%H:%M:%S') - MaryTTS server: OK" >> "$LOG"
	else
		echo "MaryTTS server is NOT running."
		echo "$(date +'%Y_%m_%d_%H:%M:%S') - MaryTTS server is NOT running" >> "$LOG"
	fi
fi
echo -e '\n-----Database: Elasticsearch-----\n'
ES_RES=$(curl --silent -X GET http://localhost:20724/_cluster/health?pretty | grep 'yellow\|green')
if [ -z "$ES_RES" ]; then
	echo "Error: Elasticsearch NOT working or NOT reachable (localhost:20724)"
	echo "$(date +'%Y_%m_%d_%H:%M:%S') - Elasticsearch NOT working or NOT reachable (localhost:20724)" >> "$LOG"
	curl --silent -X GET http://localhost:20724/_cluster/health?pretty
	RES_CODE=1
	if [ $do_all_tests -eq 0 ]; then
		exit 1
	fi
else
	echo "OK"
	echo "$(date +'%Y_%m_%d_%H:%M:%S') - Elasticsearch: OK" >> "$LOG"
fi
if [ $RES_CODE -eq 1 ]; then
	echo -e '\nDONE - It seems there were one or more critical ERRORS, please check the output!'
	echo "$(date +'%Y_%m_%d_%H:%M:%S') - Cluster test FAILED - It seems there were one or more critical ERRORS" >> "$LOG"
	echo -e 'Before you continue consider running the shutdown script once.\n'
	exit 1
fi
echo -e '\nDONE - If you made it this far the basic setup looks GOOD, but please double-check the output.\n'
hostname_dot_local="$(hostname -s).local"
ip_adr=""
if [ -x "$(command -v ip)" ]; then
	# old: ifconfig
	ip_adr=$(ip a | grep -E 'eth0|wlan0' | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' | head -1)
fi
if [ -z "$ip_adr" ]; then
	ip_adr="[IP]"
fi
echo "You should be able to reach your SEPIA server via:"
if [ -n "$ISDOCKER" ]; then
	echo "[docker-machine].local (or IP)"
	echo "$(date +'%Y_%m_%d_%H:%M:%S') - You should be able to reach your SEPIA server via: [docker-machine].local or IP" >> "$LOG"
	echo ''
	echo "Example1: http://[docker-machine].local:20726/sepia/assist/tools/index.html"
	echo "Example2: http://[docker-machine].local:20726/sepia/assist/app/index.html"
	echo ''
	echo "If your Docker host machine uses SSL, a proxy or you've changed the PORT (run command), adjust the URLs accordingly."
else
	echo "'$hostname_dot_local' or '$ip_adr'"
	echo "$(date +'%Y_%m_%d_%H:%M:%S') - You should be able to reach your SEPIA server via: $hostname_dot_local or $ip_adr" >> "$LOG"
	if [ -n "$PROXY_URL" ]; then
		echo "Proxy setting: $PROXY_MODE - Status: $PROXY_STATUS"
		echo "Proxy test URL: ${PROXY_URL/localhost/$hostname_dot_local}"
	else
		echo "Proxy: not configured" 
	fi
	echo ''
	echo "Example1: http://$hostname_dot_local:20721/tools/index.html"
	echo "Example2: http://$ip_adr:20721/tools/index.html"
	echo "Example3: http://$ip_adr:20721/app/index.html"
	echo ''
	if [ -n "$PROXY_URL" ]; then
		if [ "$PROXY_HAS_SS_SSL" = "true" ]; then
			echo "Via proxy with self-signed SSL (port 20726) and non-SSL fallback (port 20727):"
			echo ''
			echo "Example4: https://$hostname_dot_local:20726/sepia/assist/tools/index.html"
			echo "Example5: https://$hostname_dot_local:20726/sepia/assist/app/index.html"
			echo "Example6: http://$ip_adr:20727/sepia/assist/tools/index.html"
			echo "Example7: http://$ip_adr:20727/sepia/assist/app/index.html"
		else
			echo "Via proxy:"
			echo ''
			echo "Example4: http://$hostname_dot_local:20726/sepia/assist/tools/index.html"
			echo "Example5: http://$hostname_dot_local:20726/sepia/assist/app/index.html"
			echo ''
			echo "If you use \"real\" SSL certificates (Let's Encrypt etc.) use HTTPS and your domain instead."
		fi
	else
		echo "After you've set up the proxy (check setup menu) try the following URLs:"
		echo ''
		echo "Example4: https://$hostname_dot_local:20726/sepia/assist/tools/index.html"
		echo "Example5: https://$hostname_dot_local:20726/sepia/assist/app/index.html"
	fi
fi
echo ''
echo "For more info about secure context and microphone access in the SEPIA client see: "
echo "https://github.com/SEPIA-Framework/sepia-docs/wiki/SSL-for-your-Server"
echo ''
