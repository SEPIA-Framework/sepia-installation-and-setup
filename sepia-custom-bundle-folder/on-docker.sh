#!/bin/sh

# SETUP AND RUN GUIDE
echo ""
echo "/--------------------------------------------------------------------------------"
echo "| Instructions to run SEPIA as Docker container"
echo "| More info: https://github.com/SEPIA-Framework/sepia-docs/wiki/SEPIA-inside-virtual-environments"
echo "| "
echo "| On your HOST (the machine that runs the Docker container) you need to increase"
echo "| virtual memory (mmap counts) for Elasticsearch via the command (Linux):"
echo "| - sudo sysctl -w vm.max_map_count=262144"
echo "| In Windows and Mac you might need to SSH into your Docker VM first, e.g. via"
echo "| - Mac (xhyve): screen ~/Library/Containers/com.docker.docker/Data/vms/0/tty"
echo "| - Windows (Docker Toolbox): docker-machine ssh"
echo "| The SEPIA Docker container will inherit this setting form the host."
echo "| "
echo "| Create an EMPTY Docker volume so that the container can copy persistent data (Linux example):"
echo "| - SEPIA_SHARE=/home/[my-user]/sepia-home-share && mkdir -p $SEPIA_SHARE"
echo "| - docker volume create --opt type=none --opt device=$SEPIA_SHARE --opt o=bind sepia-home-share"
echo "| "
echo "| On the first run use the terminal to finish the SEPIA setup, e.g.:"
echo "| - docker run --rm --name=sepia_home -it -v sepia-home-share:/home/admin/SEPIA sepia/home:vX.Y.Z /bin/bash"
echo "| - bash setup.sh  (steps 4 and 1)"
echo "| "
echo "| Exit setup and terminal and use a default run command like this:"
echo "| - docker run --rm --name=sepia_home -p 20726:20726 -v sepia-home-share:/home/admin/SEPIA sepia/home:vX.Y.Z"
echo "\--------------------------------------------------------------------------------"
echo ""

# START
cd ~/SEPIA
./run-sepia.sh
if [ $? -eq 1 ]; then
	exit 1
fi

# ADD PROXY - NOTE: replaced by Nginx
#./run-reverse-proxy.sh

# KEEP DOCKER ALIVE (alternatively run proxy or websocket server in foreground)
trap : TERM INT; sleep infinity & wait