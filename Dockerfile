FROM debian:buster-slim

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# Get all packages, install Java OpenJDK 11 and create a user

RUN echo 'Installing SEPIA-Home...' && \
#
#	Update package sources
	apt-get update && \
#
#	Get packages
	apt-get install -y --no-install-recommends \
        sudo git wget curl nano unzip zip procps \
		openjdk-11-jdk-headless ca-certificates-java \
		ntpdate nginx \
		espeak-ng espeak-ng-espeak && \
#
#   Clean up
    apt-get clean && apt-get autoclean && apt-get autoremove -y && \
#
# 	Update time-sync
	ntpdate -u ntp.ubuntu.com
#
#   Create a Linux user
    useradd --create-home --shell /bin/bash admin && \
	adduser admin sudo

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

#	Setup SEPIA
#	NOTE: This has to be done (e.g. by sharing external config folder) before server can run without error
#	e.g.: 
#	0 - Create an EMPTY shared folder:		export SEPIA_SHARE=/home/[my-user]/sepia-share && mkdir -p $SEPIA_SHARE
#	1 - Run setup with shared folder:		sudo docker run --rm --name=sepia_home -p 20726:20726 -it -v $SEPIA_SHARE/SEPIA:/home/admin/SEPIA sepia/home:latest bash setup.sh
#	2 - Run server:							sudo docker run --rm --name=sepia_home -p 20726:20726 -d -v $SEPIA_SHARE/SEPIA:/home/admin/SEPIA sepia/home:latest

# Start
WORKDIR /home/admin/SEPIA
CMD sudo service nginx start && bash on-docker.sh
