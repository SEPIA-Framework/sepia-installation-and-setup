FROM debian:buster-slim

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# Get all packages, install Java OpenJDK 11 and create a user

RUN echo 'Installing SEPIA-Home...' && \
#
#	Update package sources
	apt-get update && \
#
#	Fix for Debian9/10 slim to be able to install Java
	mkdir -p /usr/share/man/man1 && \
#
#	Get packages
	apt-get install -y --no-install-recommends \
        sudo git wget curl nano unzip zip procps \
		openjdk-11-jdk-headless ca-certificates-java \
		ntpdate nginx \
		espeak-ng espeak-ng-espeak libpopt0 && \
#
# 	Update time-sync - NOTE: not possible in Docker; will use host clock
#	sudo ntpdate -u ntp.ubuntu.com
#
#   Clean up
    apt-get clean && apt-get autoclean && apt-get autoremove -y && \
#
#   Create a Linux user
    useradd --create-home --shell /bin/bash admin && \
	adduser admin sudo && \
	echo "admin ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Set JAVA_HOME path ... just in case

ENV JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
ENV PATH="${JAVA_HOME}:${PATH}"

# Download SEPIA-Home (custom-bundle, single-server, SBC version)

USER admin

RUN echo "Downloading SEPIA-Home (custom bundle) ..." && \
#
#	Make target and temporary folder (SEPIA should be in ~/SEPIA !!)
	mkdir -p ~/SEPIA/tmp && \
	cd ~/SEPIA/tmp && \
#
#	Download files
	wget "https://github.com/SEPIA-Framework/sepia-installation-and-setup/releases/latest/download/SEPIA-Home.zip" && \
	unzip SEPIA-Home.zip -d ~/SEPIA && \
#
#	Clean up
	cd ~/SEPIA && \
	find . -iname "*.sh" -exec chmod +x {} \; && \
	chmod +x elasticsearch/bin/elasticsearch && \
	rm -rf ~/SEPIA/tmp && \
#
#	Run setup to install TTS engine
	bash setup.sh 7 && \
#
#	Set up Nginx (HTTP)
	sudo cp nginx/sites-available/sepia-fw-http.conf /etc/nginx/sites-enabled/sepia-fw-http.conf
#
# Optional, final modifications imported from build folder:
# ADD *.sh /home/admin/SEPIA/
# RUN cd ~/SEPIA && sudo find . -iname "*.sh" -exec chmod +x {} \;
#
#	---------------------
#	Please read: https://github.com/SEPIA-Framework/sepia-docs/wiki/SEPIA-inside-virtual-environments
#
#	Set up Elasticsearch
#	Run this on your HOST (the machine that starts the Docker container): 	sudo sysctl -w vm.max_map_count=262144
#	Comment: https://www.elastic.co/guide/en/elasticsearch/reference/5.3/vm-max-map-count.html (the container will inherit this from the host)
#
#	Set up SEPIA
#	NOTE: This has to be done (e.g. by sharing external config folder) before server can run without error
#	e.g.:
#	0 - Create an EMPTY shared folder:	SEPIA_SHARE=/home/[my-user]/sepia-home-share && mkdir -p $SEPIA_SHARE
#	1 - Make a Docker volume out of it:	docker volume create --opt type=none --opt device=$SEPIA_SHARE --opt o=bind sepia-home-share
#	1 - Run container with terminal:	docker run --rm --name=sepia_home -it -v sepia-home-share:/home/admin/SEPIA sepia/home:vX.X.X /bin/bash
#	2 - Inside container finish setup:	bash setup.sh (run at least setup steps 4 and 1)
#	3 - Exit container and run as server:	docker run --rm --name=sepia_home -p 20726:20726 -d -v sepia-home-share:/home/admin/SEPIA sepia/home:vX.X.X
#	---------------------

# Start
WORKDIR /home/admin/SEPIA
CMD sudo service nginx start && bash on-docker.sh
