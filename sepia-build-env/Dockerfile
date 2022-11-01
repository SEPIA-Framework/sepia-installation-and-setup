FROM debian:bullseye-slim

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# Get all packages, install Java OpenJDK 11 and create a user

RUN echo 'Installing SEPIA-Framework build environment ...' && \
#
#	Update package sources
	apt-get update && \
#
#	Fix for Debian9/10 slim to be able to install Java
	mkdir -p /usr/share/man/man1 && \
#
#	Get packages
	apt-get install -y --no-install-recommends \
        sudo git wget curl nano unzip zip procps ca-certificates \
		openjdk-11-jdk-headless ca-certificates-java maven && \
#
#   Clean up
    apt-get clean && apt-get autoclean && apt-get autoremove -y && \
#
#   Create a Linux user
    useradd --create-home --shell /bin/bash admin && \
	adduser admin sudo && \
	echo "admin ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Set JAVA_HOME path ... just in case - TODO: fix path for ARM or remove
#
# ENV JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
# ENV PATH="${JAVA_HOME}:${PATH}"
#
# Set a Docker ENV to identify container in scripts
ENV ISDOCKER="true"

USER admin

RUN echo "Creating build folders ..." && \
#
#	build
	mkdir -p /home/admin/build && \
	cd /home/admin && \
	echo "trap : TERM INT; sleep infinity & wait" > on-docker.sh

# Start
WORKDIR /home/admin
CMD bash on-docker.sh
