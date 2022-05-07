#!/bin/sh

# SETUP AND RUN GUIDE
echo ''
echo '/--------------------------------------------------------------------------------------------------'
echo '| How to run SEPIA-Home as Docker container:'
echo '| https://github.com/SEPIA-Framework/sepia-docs/wiki/SEPIA-inside-virtual-environments'
echo '| '
echo '| Quick start guide:'
echo '| '
echo '| On your HOST machine (the one that runs Docker) make sure virtual memory (mmap counts)'
echo '| is set properly for Elasticsearch via the command (Linux):'
echo '| * sudo sysctl -w vm.max_map_count=262144'
echo '| The SEPIA Docker container will inherit this setting form the host.'
echo '| In Windows and Mac you might need to SSH into your Docker VM first (see sepia-docs).'
echo '| '
echo '| Create an EMPTY(!) Docker volume for persistent user data (Linux example):'
echo '| * SEPIA_SHARE=/home/[my-user]/sepia-home-share && mkdir -p $SEPIA_SHARE'
echo '| * docker volume create --opt type=none --opt device=$SEPIA_SHARE --opt o=bind sepia-home-share'
echo '| '
echo '| Run the container via:'
echo '| * docker run --rm --name=sepia_home -p 20726:20726 \'
echo '|    -v sepia-home-share:/home/admin/sepia-home-data sepia/home:vX.Y.Z'
echo '| '
echo '| The container will look for "$SEPIA_SHARE/setup/automatic-setup/docker-setup" at start-up'
echo '| and enter automatic-setup mode EVERY time as long as the file still exists.'
echo '| Check "$SEPIA_SHARE/setup/automatic-setup/results.log" afterwards to see the results.'
echo '| '
echo '| If you experience any problems you can run the container with terminal as entry point:'
echo '| * docker run --rm --name=sepia_home -p 20726:20726 -it \'
echo '|    -v sepia-home-share:/home/admin/sepia-home-data sepia/home:vX.Y.Z /bin/bash'
echo '| '
echo '| Or enter the running container via:'
echo '| * docker exec -it sepia_home /bin/bash'
echo '\--------------------------------------------------------------------------------------------------'
echo ''

# SETUP
SEPIA_FOLDER="$HOME/SEPIA"
SEPIA_DATA="$HOME/sepia-home-data"
LOG="$SEPIA_DATA/docker-log.out"

echo "$(date +'%Y_%m_%d_%H:%M:%S') - DOCKER START" >> "$LOG"
cd "$SEPIA_FOLDER"
echo "LOG file: $LOG"
echo ""

# Check if ENV is set
if [ -z "$ISDOCKER" ]; then
	echo "$(date +'%Y_%m_%d_%H:%M:%S') - 'ISDOCKER' environment variable is NOT set." >> "$LOG"
	echo "$(date +'%Y_%m_%d_%H:%M:%S') - EXIT" >> "$LOG"
	echo "EXIT - please check the LOG for errors"
	exit 1
fi

# Check if external data folder is setup properly
echo "$(date +'%Y_%m_%d_%H:%M:%S') - Checking data folder '$SEPIA_DATA' ..." >> "$LOG"
if [ ! -f "${SEPIA_DATA}/settings/assist.custom.properties" ]; then
	echo "$(date +'%Y_%m_%d_%H:%M:%S') - Data is MISSING - Is your shared volume setup properly?" >> "$LOG"
	echo "$(date +'%Y_%m_%d_%H:%M:%S') - Please make sure your folder is EMPTY when you create the volume!" >> "$LOG"
	echo "$(date +'%Y_%m_%d_%H:%M:%S') - 'docker run' argument: '-v sepia-home-share:${SEPIA_DATA}'" >> "$LOG"
	echo "$(date +'%Y_%m_%d_%H:%M:%S') - EXIT" >> "$LOG"
	echo "EXIT - please check the LOG for errors"
	exit 1
fi

# Check if symlinks are set
if [ ! -L "${SEPIA_FOLDER}/es-data" ]; then
	echo "$(date +'%Y_%m_%d_%H:%M:%S') - Your container is not yet set up for the new external data folder!" >> "$LOG"
	echo "$(date +'%Y_%m_%d_%H:%M:%S') - If you've updated an old container please check the SEPIA Docker docs" >> "$LOG"
	echo "$(date +'%Y_%m_%d_%H:%M:%S') - EXIT" >> "$LOG"
	echo "EXIT - please check the LOG for errors"
	exit 1
fi

# Run automatic setup?
if [ $(ls automatic-setup | grep docker-setup | wc -l) -gt 0 ]; then
	echo "$(date +'%Y_%m_%d_%H:%M:%S') - Found '$SEPIA_DATA/automatic-setup/docker-setup'" >> "$LOG"
	echo "$(date +'%Y_%m_%d_%H:%M:%S') - Starting setup using '$SEPIA_DATA/automatic-setup/config.yaml' ..." >> "$LOG"
	bash setup.sh --automatic
	if [ $? -gt 0 ]; then
		echo "$(date +'%Y_%m_%d_%H:%M:%S') - Setup FAILED - Please check log for errors." >> "$LOG"
		echo "$(date +'%Y_%m_%d_%H:%M:%S') - EXIT" >> "$LOG"
		echo "EXIT - please check the LOG for errors"
		exit 1
	fi
	echo "$(date +'%Y_%m_%d_%H:%M:%S') - Setup DONE - Removing 'docker-setup' file ..." >> "$LOG"
	rm automatic-setup/docker-setup*
	echo "$(date +'%Y_%m_%d_%H:%M:%S') - Please check: 'automatic-setup/results.log'" >> "$LOG"
fi

# START
echo "$(date +'%Y_%m_%d_%H:%M:%S') - Starting SEPIA-Home ..." >> "$LOG"
bash run-sepia.sh
if [ $? -gt 0 ]; then
	echo "$(date +'%Y_%m_%d_%H:%M:%S') - EXIT" >> "$LOG"
	echo "EXIT - please check the LOG for errors"
	exit 1
fi

# KEEP DOCKER ALIVE (alternatively run proxy or websocket server in foreground)
trap : TERM INT; sleep infinity & wait