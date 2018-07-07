#!/bin/bash
JAR_NAME=$(ls | grep "^sepia-reverse-proxy-.*jar" | tail -n 1)
echo "Running SEPIA Reverse-Proxy ($JAR_NAME)"
java -jar -Xms25m -Xmx25m $JAR_NAME tiny -port=20726 -host=localhost -defaultPaths=true &> log.out&
