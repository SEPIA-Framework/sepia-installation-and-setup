#!/bin/bash
apt-get install -y --no-install-recommends openjdk-8-jdk-headless ca-certificates-java
echo "JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/" >> /etc/environment
source /etc/environment
