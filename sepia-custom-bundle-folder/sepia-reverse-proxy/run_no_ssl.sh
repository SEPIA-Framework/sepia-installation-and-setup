#!/bin/bash
JAR_NAME=$(ls | grep "^sepia-reverse-proxy-.*jar" | tail -n 1)
echo "Running SEPIA Reverse-Proxy ($JAR_NAME)"
java -jar -Xms25m -Xmx25m $JAR_NAME tiny -ssl=false &> log.out&
